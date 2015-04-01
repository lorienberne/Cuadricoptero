%%  Kalman Filter Class
% Creates a Kalman Filter object from Q and R matrices
%
classdef Kalman
    properties
        P;
        Q;
        R;
        K;
    end

    methods
        function this = Kalman(Q,R)
        %%Constructor
            this.Q = Q;
            this.R = R;
        end

        quad = addError(quad);
        this = xPriori(this);
        this = xPosteriori(this);
        this = pPriori(this);
        this = pPosteriori(this);
        this = kCalc(this);
    end
end
