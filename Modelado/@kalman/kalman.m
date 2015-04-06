%%  Kalman Filter Class
% Creates a Kalman Filter object from Q and R matrices
%
% R MATRIX MUST BE ARRANGED AS FOLLOWS
% R = [M 0 0 0 0 0;   M -> MAGNETOMETER'S COVARIANCE
%      0 A 0 0 0 0;   A -> ACCELEROMETER'S COVARIANCE
%      0 0 A 0 0 0;
%      0 0 0 G 0 0;   G -> GYROSCOPE'S COVARIANCE
%      0 0 0 0 G 0;
%      0 0 0 0 0 G];


classdef kalman
    properties
        xPriori = [0; 0; 0];
        xPosteriori = [0; 0; 0];
        P = [0; 0; 0];
        K = [0; 0; 0];

% COVARIANCE MATRICES
        Q;
        R;

% MODEL MATRICES

        A;
        B;
        C;
        D;

% SENSORS OBJECTS
        gyro;
        accel;
        magnet;

        phiThetaPsi = [0; 0; 0];
        xyz         = [0; 0; 0];

        dt;
    end

    methods
        function this = kalman(Q,R,A,B,C,D,dt)
        %% CONSTRUCTOR. INTIALIZATION OF VARIABLES
            this.Q      = Q;
            this.R      = R;
            this.magnet = magnet(R(1,1));
            this.accel  = accel(R(2,2));
            this.gyro   = gyro(R(4,4));
            this.A      = A;
            this.B      = B;
            this.C      = C;
            this.D      = D;
            this.dt     = dt;
        end

        this = CalcXPriori(this,quad);
        this = CalcXPosteriori(this);
        this = CalcPPriori(this);
        this = CalcPPosteriori(this);
        this = CalcK(this);
        this = CalcUpdateKalman(this,quad);
    end
end
