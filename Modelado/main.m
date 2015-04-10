clc;
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PARAMETERS DECLARATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SIMULATION PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TIME IN SECONDS BETWEEN EACH TIME STEP
dt = 0.01;


%% KALMAN FILTER PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MCov = 0.002^2;
ACov = 0.0004^2;
GCov = (0.05*pi/360)^2;


% COVARIANCE MATRIX
Q = [0 0 0 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0];

% COVARIANCE MATRIX
R = [MCov 0 0 0 0 0; % M -> MAGNETOMETER'S COVARIANCE
     0 ACov 0 0 0 0; % A -> ACCELEROMETER'S COVARIANCE
     0 0 ACov 0 0 0;
     0 0 0 GCov 0 0; % G -> GYROSCOPE'S COVARIANCE
     0 0 0 0 GCov 0;
     0 0 0 0 0 GCov];

% KALMAN MATHEMATICAL MODEL MATRICES
A = [0 0 0 1 0 0;
     0 0 0 0 1 0;
     0 0 0 0 0 1;
     0 0 0 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0];

B = [   0       0       0     ;
        0       0       0     ;
        0       0       0     ;
     0.000212   0       0     ;
        0    0.000212   0     ;
        0       0    0.000212];

C = eye(6);
D = zeros(6,3);

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

K = [1 0 0 1 0 0;
     0 1 0 0 1 0;
     0 0 1 0 0 1];



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
kalFil = kalman(Q,R,A,B,C,D,dt); %COMMENT IF YOU USE A LUENBERGER OBSERVER
q      = quad(posSttVect, attitSttVect, m, l, I, rotorIz, kProp, dt);
attfback  = fback(K);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SIMULATION LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


dState = [0; 0; pi/16; 0; 0; 0];
t=0;
d = figure();
anE = [];
st = [];
while(1)  %INFINITE LOOP

%ESTIMATE QUAD STATE
  kalFil = kalFil.updateKalman(q);

%GET CONTROL SIGNAL AND SET PROPS TO THAT SPEED
  q = q.setPropSpeed( attfback.getControlSignal(kalFil, dState) );

%CARRY OUT A SIMULATION TIMESTEP
  q = q.simQuad();

%PLOT THE RESULT
  q.drawQuad(1);

  an  = kalFil.accel.getAccelAngle(q);
  sts = kalFil.getState();
  anE = [anE an(1)];
  st  = [st sts(2)];
  t  = [t 0.01];
  
  pause(0.01);
end
