function pPost = CalPPosteriori(this)
  pPost = (eye(6) - this.K * this.C) * this.pPriori;
end
