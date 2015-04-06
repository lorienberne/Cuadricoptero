classdef feedback
  properties
    K = 0;
  end
  methods
    function this = feedback(K);
      this.K = K;
    end
    getControlSignal(this,quad);
  end
end
