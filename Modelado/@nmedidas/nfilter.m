function med = nfilter(this, new, derNew)
  for i = 2:this.numMed
    this.medidas(i-1)    = this.medidas(i);
    this.derMedidas(i-1) = this.derMedidas(i);
  end
  this.medidas(this.numMed)    = new;
  this.derMedidas(this.numMed) = derNew;

  med = sum(this.medidas + this.derMedidas.*this.dt)/this.numMed;
end
