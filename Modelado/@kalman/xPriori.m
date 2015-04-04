function xPri = xPriori(this,quad)
%GET THE ANGULAR VELOCITY OF THE PROPELLERS WHICH IS THE INPUT OF THE SYSTEM
  u = quad.getRotorOmega();

%CALCULATE THE STATE FOR THE NEXT TIMESTEP BASE ON THE PREVIOUS TIMESTEP AND THE
%MATHEMATICAL MODEL OF THE SYSTEM (SS);
  xPri = this.xPosteriori + this.dt * (A * this.xPosteriori + B * u);
end
