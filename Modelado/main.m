clc;
close all;
clear all;
tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PARAMETERS DECLARATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SIMULATION PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TIME IN SECONDS BETWEEN EACH TIME STEP
dt = 0.01;


%% KALMAN FILTER PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MCov        = 0.002^2;
% ACov        = 0.0004^2;
% GCov        = (0.5*pi/180)^2;
% GPSPosCov   = 1;
% GPSSpeedCov = 0.1;

MCov        = 0.0001;
ACov        = 0.0001;
GCov        = 0.0001;
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
      0.000212         0         0     ;
             0     0.000212      0     ;
             0         0    0.0000638 ];

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
              0          0     -96.145    0    ;
              0          96.145   0       0     ;
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

attK =  [1.9707   0     0  0.9067   0     0  ;
            0  1.9707   0    0   0.9067   0  ;
            0     0  6.5484  0      0  3.0127]*1000000;

posK =  [         0           0      -1000000       0               0         -4592200  ;
                  0      0.1*0.8*1.5    0           0          0.10103*1.5*1.3    0     ;
             -0.1*0.8*1.5     0         0      -0.10103*1.5*1.3     0             0     ;
                  0           0         0           0               0             0     ];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INITIAL CONDITIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ATTITUDE STATE VECTOR (PHI THETA PSI PHIDOT THETADOT PSIDOT)
attitSttVect = [0; 0; 0; 0; 0; 0];

% POSITION STATE VECTOR (X Y Z XDOT YDOT ZDOT)
posSttVect   = [0; 0; 0; 0; 0; 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OBJECT INSTANTIATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%luenObs = luenberger(K) %UNCOMMENT TO USE A LUENBERGER OBSERVER
attKalFil       = kalman(attQ, attR, attA, attB, attC, attD, dt); %COMMENT IF YOU USE A LUENBERGER OBSERVER
posKalFil       = kalman(posQ, posR, posA, posB, posC, posD, dt);
q           	= quad(posSttVect, attitSttVect, m, l, I, rotorIz, kProp, dt);
attfback        = fback(attK);
posfback        = fback(posK);
accelSensor     = accel(ACov);
magnetSensor    = magnet(MCov);
gyroSensor      = gyro(GCov);
gpsSensor       = gps([GPSPosCov; GPSSpeedCov]);
abFilter        = alphabeta();
posNmedFilter   = nmedidas(5,3,dt);
attNmedFilter   = nmedidas(5,3,dt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SIMULATION LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


posDesState = [0; 4; 0; 0; 0; 0];
posFBSignal = [0; 0; 0; 0];

% VARIABLES TO SAVE INFORMATION FOR LATER PLOTS
plotPos        = [];
plotEPos       = [];
plotRPos       = [];

plotPosV       = [];

plotAtt        = [];
plotEAtt       = [];
plotRatt       = [];

plotAttV       = [];

plotPosSignal  = [];
plotAttSignal  = [];


for t = 0:dt:5
%GET INPUT
  rotorOmega = q.getRotorOmega();
  attU = [             rotorOmega(1)^2 - rotorOmega(3)^2;
                       rotorOmega(4)^2 - rotorOmega(2)^2;
     rotorOmega(1)^2 + rotorOmega(3)^2 - (rotorOmega(4)^2 + rotorOmega(2)^2)];

  posU = posFBSignal;

%GET SENSOR MEASUREMENTS
  attMState = [q.attitSttVect(1:2)
               magnetSensor.magMeasure(q);
               gyroSensor.gyroMeasure(q)];
  posMState =  gpsSensor.gpsMeasure(q);
  
%ESTIMATE QUAD STATE
  attKalFil = attKalFil.updateKalman(attU, attMState);
  posKalFil = posKalFil.updateKalman(posU, posMState); 
    
  attState = attKalFil.getState();
  posState = posKalFil.getState();
%FILTER WITH ALPHA BETA FILTER
 %zAlphaFiltered   = abFilter.alphaFilter(posKalFil.pPosteriori());
 %dirAlphaFiltered = abFilter.alphaFilter(); 

%UPDATE N MEASUREMENTS FILTER
 posNmedFilter = posNmedFilter.nfilter(posState(1:3), posState(4:6));
 attNmedFilter = attNmedFilter.nfilter(attState(1:3), attState(4:6));
 
%GET AVEARAGE MEASUREMENTS FROM N MEASUREMENTS FILTER
 attNFil = attNmedFilter.getNMes();
 posNFil = posNmedFilter.getNMes();

 
%GET CONTROL SIGNAL AND SET PROPS TO THAT SPEED
  posFBSignal = posfback.getControlSignal(posNFil, posDesState);
  attFBSignal = attfback.getControlSignal(attNFil,[posFBSignal(2:4,1); 0; 0; 0]);
  q = q.setPropSpeed(attFBSignal,posFBSignal(1,1));
    
%CARRY OUT A SIMULATION TIMESTEP
  q = q.simQuad();
  q.posSttVect
%PLOT THE RESULT
  q.drawQuad(5);
  pause(dt);
  plotPos  = [plotPos posNFil];
  plotEPos = [plotEPos posMState];
  plotRPos = [plotRPos q.posSttVect];

  plotPosV  = [plotPosV q.posSttVect(4:6)];

  plotAtt  = [plotAtt attNFil];
  plotEAtt = [plotEAtt attMState];
  plotRatt = [plotRatt q.attitSttVect];

  plotAttV  = [plotAttV q.attitSttVect(4:6)];

  plotPosSignal = [plotPosSignal posFBSignal(1:3)];
  plotAttSignal = [plotAttSignal attFBSignal];
end


t = 0:dt:5;

figure();
hold on;
title('Posicion X');
plot(t,plotPos(1,:), 'r');
plot(t,plotEPos(1,:),'g');
plot(t,plotRPos(1,:),'b');
legend('Filtered','Measured','Real');
hold off;

figure();
hold on;
title('Actitud PSI');
plot(t,plotAtt(3,:), 'r');
plot(t,plotEAtt(3,:),'g');
plot(t,plotRatt(3,:),'b');
legend('Filtered','Measured','Real');
hold off;

figure();
hold on;
title('Posicion Y');
plot(t,plotPos(2,:), 'r');
plot(t,plotEPos(2,:),'g');
plot(t,plotRPos(2,:),'b');
legend('Filtered','Measured','Real');
hold off;

figure();
hold on;
title('Actitud THETA');
plot(t,plotAtt(2,:), 'r');
plot(t,plotEAtt(2,:),'g');
plot(t,plotRatt(2,:),'b');
legend('Filtered','Measured','Real');
hold off;

figure();
hold on; 
title('Posicion Z');
plot(t,plotPos(3,:), 'r');
plot(t,plotEPos(3,:),'g');
plot(t,plotRPos(3,:),'b');
legend('Filtered','Measured','Real');
hold off;

figure();
hold on;
title('Actitud PHI');
plot(t,plotAtt(1,:), 'r');
plot(t,plotEAtt(1,:),'g');
plot(t,plotRatt(1,:),'b');
legend('Filtered','Measured','Real');
hold off;

figure();
hold on;
title('Señal Posicion');
plot(t,plotPosSignal(3,:),'r');
plot(t,plotPosSignal(2,:),'g');
plot(t,plotPosSignal(1,:),'b');
legend('X','Y','Z');
hold off;

figure();
hold on;
title('Señal Actitud');
plot(t,plotAttSignal(3,:),'r');
plot(t,plotAttSignal(2,:),'g');
plot(t,plotAttSignal(1,:),'b');
legend('Psi','Theta','Phi');
hold off;

figure();
hold on;
title('Velocidad Posicion');
plot(t,plotPos(4,:),'r');
plot(t,plotPos(5,:),'g');
plot(t,plotPos(6,:),'b');
legend('x','y','z');
hold off;

figure();
hold on;
title('Velocidad Actitud');
plot(t,plotAttV(3,:));
hold off;
toc;
