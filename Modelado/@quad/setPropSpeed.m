function this = setPropSpeed(this,signal)
  this.rotorOmega = [this.rotorOmega(1) + sqrt(signal(1)/2) + sqrt(signal(3)/4);
                     this.rotorOmega(2) - sqrt(signal(2)/2) - sqrt(signal(3)/4);
                     this.rotorOmega(3) - sqrt(signal(1)/2) + sqrt(signal(3)/4);
                     this.rotorOmega(4) + sqrt(signal(2)/2) - sqrt(signal(3)/4)];
end
