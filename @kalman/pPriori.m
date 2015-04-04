function pPri = pPriori(this)
  pPri = this.A * pPosteriori * (this.A)' + this.Q
end
