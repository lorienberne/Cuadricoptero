function this = updateKalman(this)
  this.xPriori     = this.xPriori();
  this.pPriori     = this.pPriori();
  this.K           = this.kCalc();
  this.xPosteriori = this.xPosteriori();
  this.pPosteriori = this.pPosteriori();
end
