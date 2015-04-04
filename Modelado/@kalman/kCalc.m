function k = kCalc(this)
    k = this.pPriori * (this.C)' * pinv(this.H * this.pPriori * (this.C)' + this.R)
end
