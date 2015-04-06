function this = updateKalman(this)
  this.xPriori     = this.CalcXPriori();
  this.pPriori     = this.CalcPPriori();
  this.K           = this.CalcK();
  this.xPosteriori = this.CalcXPosteriori();
  this.pPosteriori = this.CalcPPosteriori();
end
