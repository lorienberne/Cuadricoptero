function this = updateKalman(this, quadc)
  this.xPriori     = this.CalcXPriori(quadc);
  this.pPriori     = this.CalcPPriori();
  this.K           = this.CalcK();
  this.xPosteriori = this.CalcXPosteriori(quadc);
  this.pPosteriori = this.CalcPPosteriori();
end
