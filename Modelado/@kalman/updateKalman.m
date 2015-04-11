function this = updateKalman(this, quad, mState)
  this.xPriori     = this.CalcXPriori(quad);
  this.pPriori     = this.CalcPPriori();
  this.K           = this.CalcK();
  this.xPosteriori = this.CalcXPosteriori(mState);
  this.pPosteriori = this.CalcPPosteriori();
end
