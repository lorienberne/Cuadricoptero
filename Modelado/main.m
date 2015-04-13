clc;
close all;
tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PARAMETERS DECLARATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SIMULATION PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TIME IN SECONDS BETWEEN EACH TIME STEP
dt = 0.01;


%% KALMAN FILTER PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MCov        = 0.002^2;
ACov        = 0.0004^2;
GCov        = (0.005*pi/180)^2;
GPSPosCov   = 1;
GPSSpeedCov = 0.1;

% COVARIANCE MATRIX
attQ = [MCov 0 0 0 0 0; % M -> MAGNETOMETER'S COVARIANCE
        0 ACov 0 0 0 0; % A -> ACCELEROMETER'S COVARIANCE
        0 0 ACov 0 0 0;
        0 0 0 GCov 0 0; % G -> GYROSCOPE'S COVARIANCE
        0 0 0 0 GCov 0;
        0 0 0 0 0 GCov];

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

attB = [     0         0         0     ;
             0         0         0     ;
             0         0         0     ;
             0         0     0.0000638 ;
             0     0.000212      0     ;
          0.000212     0         0     ];

attC = eye(6);
attD = zeros(6,3);


% COVARIANCE MATRIX
posQ = [GPSPosCov 0 0 0 0 0;
        0 GPSPosCov 0 0 0 0;
        0 0 GPSPosCov 0 0 0;
        0 0 0 GPSSpeedCov 0 0;
        0 0 0 0 GPSSpeedCov 0;
        0 0 0 0 0 GPSSpeedCov];

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

posB = [      0          0        0       0    ;
              0          0        0       0    ;
              0          0        0       0    ;
              0          0     -96.145     0    ;
              0          0        0    96.145 ;
        -0.0000094838    0        0       0    ];

posC = eye(6);
posD = zeros(6,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% QUAD OBJECT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% HALF DISTANCE BETWEEN EACH PAIR OF PROPELLER'S AXES
l = 0.1;

% MASS OF THE QUADCOPTER
m = 1.05;

% DIAGONAL ELEMENTS OF THE INERTIA TENSOR OF THE QUADCOPTER
I = [0.0128 0.0128 0.0256];

% INTERTIA MOMENT OF INERTIA OF THE PROPELLER
rotorIz = 0.0001;

% THRUST AND TORQUE CONSTANTS
kProp = [0.000009958, 0.0000009315];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% FEEDBACK PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

attK =  [      0     0    1166    0     0    6224;
               0   1166    0     0    6224     0;
              387.5    0     0     20683     0    0];

posK =  [    0      0       -33029      0       0        -62140    ;
             0      0       0       0       0         0    ;
            -0.033      0       0      -0.061     0         0    ;
             0      0.033       0       0        0.061        0    ];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INITIAL CONDITIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ATTITUDE STATE VECTOR (PHI THETA PSI PHIDOT THETADOT PSIDOT)
attitSttVect = [0; 0; 0; 0; 0; 0];

% POSITION STATE VECTOR (X Y Z XDOT YDOT ZDOT)
posSttVect   = zeros(6,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


posDesState = [0; 0.5; -0.5; 0; 0; 0];
posFBSignal = [0; 0; 0; 0];

plotPos     = [];
plotEPos    = [];
plotRPos    = [];

plotAtt     = [];
plotEAtt    = [];
plotRatt    = [];

for t = 0:dt:10
%GET INPUT
  rotorOmega = q.getRotorOmega();
  attU = [             rotorOmega(1)^2 - rotorOmega(3)^2;
                       rotorOmega(4)^2 - rotorOmega(2)^2;
     rotorOmega(1)^2 + rotorOmega(3)^2 - (rotorOmega(4)^2 + rotorOmega(2)^2)];

  posU = posFBSignal;

%GET SENSOR MEASUREMENTS
  attMState = [magnetSensor.magMeasure(q);
               q.attitSttVect(2:3);
               gyroSensor.gyroMeasure(q)];
  posMState =  gpsSensor.gpsMeasure(q);

%ESTIMATE QUAD STATE
  attKalFil = attKalFil.updateKalman(attU, attMState);
  posKalFil = posKalFil.updateKalman(posU, posMState);

%GET CONTROL SIGNAL AND SET PROPS TO THAT SPEED
  posFBSignal = posfback.getControlSignal(posKalFil, posDesState);
  attFBSignal = attfback.getControlSignal(attKalFil,[posFBSignal(2:4,1); 0; 0; 0]);
  q = q.setPropSpeed(attFBSignal,posFBSignal(1,1));
    
%CARRY OUT A SIMULATION TIMESTEP
  q = q.simQuad();

%PLOT THE RESULT
  q.drawQuad(5);
  pause(dt);
  plotPos  = [plotPos posKalFil.getState()];
  plotEPos = [plotEPos posMState];
  plotRPos = [plotRPos q.posSttVect];
  
  plotAtt  = [plotAtt attKalFil.getState()];
  plotEAtt = [plotEAtt attMState];
  plotRatt = [plotRatt q.attitSttVect];
end


t = 0:dt:10;

figure();
hold on;
plot(t,plotPos(1,:));
plot(t,plotEPos(1,:));
plot(t,plotRPos(1,:));
hold off;

figure();
hold on;
plot(t,plotAtt(1,:));
plot(t,plotEAtt(1,:));
plot(t,plotRatt(1,:));
hold off;

hold on;
plot(t,plotPos(2,:));
plot(t,plotEPos(2,:));
plot(t,plotRPos(2,:));
hold off;

figure();
hold on;
plot(t,plotAtt(2,:));
plot(t,plotEAtt(2,:));
plot(t,plotRatt(2,:));
hold off;

hold on;
plot(t,plotPos(3,:));
plot(t,plotEPos(3,:));
plot(t,plotRPos(3,:));
hold off;

figure();
hold on;
plot(t,plotAtt(3,:));
plot(t,plotEAtt(3,:));
plot(t,plotRatt(3,:));
hold off;
toc;
