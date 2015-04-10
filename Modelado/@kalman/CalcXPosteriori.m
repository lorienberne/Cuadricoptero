function xPost = CalcXPosteriori(this,quad)
%CONSTRUCT THE MEASUREMENT VECTOR FROM DATA FROM THE GYRO AND ACCELEROMETER
    mg = this.magnet.magMeasure(quad);
    ac = this.accel.getAccelAngle(quad);
    gy = this.gyro.gyroMeasure(quad);
    y = [mg; ac; gy];

%%%%%%%%%%%%
    xPost = this.xPriori + this.K * (y - this.C * this.xPriori);
end
