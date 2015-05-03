function dir = getGPSDir(this,quad)
    dir = quad.attitSttVect + this.cov(3)*randn(1,1);
end