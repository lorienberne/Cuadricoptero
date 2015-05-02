classdef barometer
    properties
        cov;
    end
    methods
        function this = barometer(cov)
            this.cov = cov;
        end
        baroMeasure();
    end
end