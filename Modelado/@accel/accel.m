classdef accel
  properties
    cov = 0; %ACCELEROMETER NOISE COVARIANCE
  end

  methods
    function this = accel(this,cov)
      this.cov = cov;
    end

    accelMmnts = accelMeasure(quad);
  end

end
