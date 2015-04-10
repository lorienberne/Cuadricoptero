function xPri = CalcXPriori(this,quad)
%GET THE ANGULAR VELOCITY OF THE PROPELLERS WHICH IS THE INPUT OF THE SYSTEM
  rotorOmega = quad.getRotorOmega();
  u = [             rotorOmega(1)^2 - rotorOmega(3)^2;
                    rotorOmega(4)^2 - rotorOmega(2)^2;
       rotorOmega(1)^2 + rotorOmega(3)^2 - (rotorOmega(4)^2 + rotorOmega(2)^2)];
%CALCULATE THE STATE FOR THE NEXT TIMESTEP BASE ON THE PREVIOUS TIMESTEP AND THE
%MATHEMATICAL MODEL OF THE SYSTEM (SS);
  xPri = this.xPosteriori + this.dt * (this.A * this.xPosteriori + this.B * u);
end
