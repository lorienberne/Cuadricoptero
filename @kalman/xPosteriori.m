function xPost = xPosteriori(this,quad)
%CONSTRUCT THE MEASUREMENT VECTOR FROM DATA FROM THE GYRO AND ACCELEROMETER
    ac = this.accel.getAccelAngle(quad)
    gy = this.gyro.gyroMeasure(quad);
    y = [ac;gy];

%%%%%%%%%%%%
    xPost = this.xPriori + this.K * (y - C * this.xPriori);
end
