clc;
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PARAMETERS DECLARATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SIMULATION PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TIME IN SECONDS BETWEEN EACH TIME STEP
dt = 0.01;


%% KALMAN FILTER PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MCov        = 0.002^2;
ACov        = 0.0004^2;
GCov        = (0.05*pi/180)^2;
GPSPosCov   = 2^2;
GPSSpeedCov = 0.1^2;

% COVARIANCE MATRIX
attQ = [0 0 0 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0];

% COVARIANCE MATRIX
attR = [MCov 0 0 0 0 0; % M -> MAGNETOMETER'S COVARIANCE
        0 ACov 0 0 0 0; % A -> ACCELEROMETER'S COVARIANCE
        0 0 ACov 0 0 0;
        0 0 0 GCov 0 0; % G -> GYROSCOPE'S COVARIANCE
        0 0 0 0 GCov 0;
        0 0 0 0 0 GCov];

% KALMAN MATHEMATICAL MODEL MATRICES
attA = [0 0 0 1 0 0;
        0 0 0 0 1 0;
        0 0 0 0 0 1;
        0 0 0 0 0 0;
        0 0 0 0 0 0;
        0 0 0 0 0 0];

attB = [   0       0       0     ;
        0       0       0     ;
        0       0       0     ;
     0.000212   0       0     ;
        0    0.000212   0     ;
        0       0    0.000212];

attC = eye(6);
attD = zeros(6,3);


% COVARIANCE MATRIX
posQ = [0 0 0 0 0 0;
        0 0 0 0 0 0;
        0 0 0 0 0 0;
        0 0 0 0 0 0;
        0 0 0 0 0 0;
        0 0 0 0 0 0];

% COVARIANCE MATRIX
posR = [GPSPosCov   0 0 0 0 0;
        0  GPSPosCov  0 0 0 0;
        0 0  GPSPosCov  0 0 0;
        0 0 0 GPSSpeedCov 0 0;
        0 0 0 0 GPSSpeedCov 0;
        0 0 0 0 0 GPSSpeedCov];

% KALMAN MATHEMATICAL MODEL MATRICES
posA = [0 0 0 1 0 0;
        0 0 0 0 1 0;
        0 0 0 0 0 1;
        0 0 0 0 0 0;
        0 0 0 0 0 0;
        0 0 0 0 0 0];

posB = [      0          0        0     ;
              0          0        0     ;
              0          0        0     ;
              0          0     96.145   ;
              0       -96.145     0     ;
        -0.0000094838    0        0     ];

posC = eye(6);
posD = zeros(6,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% QUAD OBJECT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% HALF DISTANCE BETWEEN EACH PAIR OF PROPELLER'S AXES
l = 0.1;

% MASS OF THE QUADCOPTER
m = 1.05;

% DIAGONAL ELEMENTS OF THE INERTIA TENSOR OF THE QUADCOPTER
I = [0.0128 0.0128 0.0256];

% INTERTIA MOMENT OF INERTIA OF THE PROPELLER
rotorIz = 0.001;

% THRUST AND TORQUE CONSTANTS
kProp = [0.000009958, 0.0000009315];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% FEEDBACK PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

attK = [10 0 0 50 0 0;
        0 10 0 0 50 0;
        0 0 10 0 0 50];

posK = 0.01*ones(4,6);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INITIAL CONDITIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ATTITUDE STATE VECTOR (PHI THETA PSI PHIDOT THETADOT PSIDOT)
attitSttVect = zeros(6,1);

% POSITION STATE VECTOR (X Y Z XDOT YDOT ZDOT)
posSttVect   = zeros(6,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OBJECT INSTANTIATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%luenObs = luenberger(K) %UNCOMMENT TO USE A LUENBERGER OBSERVER
attKalFil    = kalman(attQ, attR, attA, attB, attC, attD, dt); %COMMENT IF YOU USE A LUENBERGER OBSERVER
posKalFil    = kalman(posQ, posR, posA, posB, posC, posD, dt);
q            = quad(posSttVect, attitSttVect, m, l, I, rotorIz, kProp, dt);
attfback     = fback(attK);
posfback     = fback(posK);
accelSensor  = accel(ACov);
magnetSensor = magnet(MCov);
gyroSensor   = gyro(GCov);
gpsSensor    = gps([GPSPosCov; GPSSpeedCov]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SIMULATION LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


posDesState = [0; 0; 0; 0; 0; 0];

for t = 0:dt:10

%GET SENSOR MEASUREMENTS
  attMState = [magnetSensor.magMeasure(q);
               accelSensor.getAccelAngle(q);
               gyroSensor.gyroMeasure(q)];
  posMState =  gpsSensor.gpsMeasure(q);

%ESTIMATE QUAD STATE
  attKalFil = attKalFil.updateKalman(q, attMState);
  posKalFil = posKalFil.updateKalman(q, posMState);

%GET CONTROL SIGNAL AND SET PROPS TO THAT SPEED
  posFBSignal = posfback.getControlSignal(posKalFil, posDesState);
  attFBSignal = attfback.getControlSignal(attKalFil, [posFBSignal(2:4,1); 0; 0; 0]);
  q = q.setPropSpeed(attFBSignal,posFBSignal(1,1));

%CARRY OUT A SIMULATION TIMESTEP
  q = q.simQuad();

%PLOT THE RESULT
  q.drawQuad(1);
  pause(dt);
end
