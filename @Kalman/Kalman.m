%%  Kalman Filter Class
% Creates a Kalman Filter object from Q and R matrices
%
classdef kalman
    properties
        P;
        Q;
        R;
        K;
        gyro;
        accel;
        phiThetaPsi = [0; 0; 0];
        xyz         = [0; 0; 0];
    end

    methods
        function this = Kalman(Q,R)
        %%Constructor
            this.Q     = Q;
            this.R     = R;
            this.gyro  = gyro ();
            this.accel = accel();
        end

        this = xPriori(this);
        this = xPosteriori(this);
        this = pPriori(this);
        this = pPosteriori(this);
        this = kCalc(this);
        this = updateKalman(this);
    end
end
