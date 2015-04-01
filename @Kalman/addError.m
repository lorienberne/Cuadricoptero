function memtns = addError(quad)
  memtns = sqrt(this.Q) * randn(6,1) + quad.attitStateVector;
end
