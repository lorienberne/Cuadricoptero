function measurement = gyroMeasure(this,quad)
    measurement = this.cov * randn(3,1) + quad.attitSttVect(1:3);
end
