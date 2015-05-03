function alt=baroMeasure(quad)
    alt = quad.posSttVect(3) + this.cov*randn(1,1);
end