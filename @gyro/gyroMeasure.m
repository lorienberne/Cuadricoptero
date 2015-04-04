function measurement = gyroMeasure(this,quad)
    measurement = this.cov * randn(3,1) + quad.pqr;
end
