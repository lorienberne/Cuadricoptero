classdef
  properties
    numMed;
    medidas;
    derMedidas;
    dt;
  end
  methods
    function this = nmedidas(numMed,dt)
      this.numMed     = numMed;
      this.medidas    = zeros(numMed,1);
      this.derMedidas = zeros(numMed,1);
      this.dt         = dt;
    end
    med = nfilter(this, new, derNew);
  end
end
