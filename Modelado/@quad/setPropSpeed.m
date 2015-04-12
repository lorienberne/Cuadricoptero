function this = setPropSpeed(this,attSignal, posSignal)
  this.rotorOmega = [509.35 + sign(posSignal)*sqrt(abs(posSignal)/4) + sign(attSignal(3))*sqrt(abs(attSignal(3))/2) + sign(attSignal(1))*sqrt(abs(attSignal(1))/4);
                     509.35 + sign(posSignal)*sqrt(abs(posSignal)/4) - sign(attSignal(2))*sqrt(abs(attSignal(2))/2) - sign(attSignal(1))*sqrt(abs(attSignal(1))/4);
                     509.35 + sign(posSignal)*sqrt(abs(posSignal)/4) - sign(attSignal(3))*sqrt(abs(attSignal(3))/2) + sign(attSignal(1))*sqrt(abs(attSignal(1))/4);
                     509.35 + sign(posSignal)*sqrt(abs(posSignal)/4) + sign(attSignal(2))*sqrt(abs(attSignal(2))/2) - sign(attSignal(1))*sqrt(abs(attSignal(1))/4)];

end
