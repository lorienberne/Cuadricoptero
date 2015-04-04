%%  Kalman Filter Class
% Creates a Kalman Filter object from Q and R matrices
%
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
    end

    methods
        function this = Kalman(Q,R,A,B,C,D)
        %% CONSTRUCTOR. INTIALIZATION OF VARIABLES
            this.Q      = Q;
            this.R      = R;
            this.gyro   = gyro (%%%%);
            this.accel  = accel(%%%%);
            this.magnet = magnet(%%%%);
            this.A      = A;
            this.B      = B;
            this.C      = C;
            this.D      = D;
        end

        this = xPriori(this,quad);
        this = xPosteriori(this);
        this = pPriori(this);
        this = pPosteriori(this);
        this = kCalc(this);
        this = updateKalman(this,quad);
    end
end
