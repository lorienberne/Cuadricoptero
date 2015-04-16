classdef
  properties
    medidas;
    derMedidas;
  end
  methods
    function this = nmedidas(numMed)
      medidas    = zeros(numMed,1);
      derMedidas = zeros(numMed,1);
    end
    med = filtrar(this, new, derNew);
  end
end
