function this = simthis(this)
    [LHb, LH1, L12, L2b] = calcRotMat(this.angles);

    T = [this.kProp(1) * this.rotorOmega(1)^2;
         this.kProp(1) * this.rotorOmega(2)^2;
         this.kProp(1) * this.rotorOmega(3)^2;
         this.kProp(1) * this.rotorOmega(4)^2];


    M = [                               (T(1) - T(3)) * this.l;
                                        (T(4) - T(2)) * this.l;
         this.kProp(2) * (this.rotorOmega(1)^2 - this.rotorOmega(2)^2 + this.rotorOmega(3)^2 - this.rotorOmega(4)^2)];



    this.pqrPto = this.inertia\(M - cross(this.pqr, this.inertia*this.pqr) - cross(this.pqr, [0; 0; (this.rotorIz * (-this.rotorOmega(1) + this.rotorOmega(2) - this.rotorOmega(3) + this.rotorOmega(4)))]));
    this.pqr = this.pqr + this.pqrPto * this.dt;
    this.angPto = [(this.pqr(1) + tan(this.angles(2))*(this.pqr(2)*sin(this.angles(1)) + this.pqr(3)*cos(this.angles(1))));
                                (this.pqr(2) * cos(this.angles(1)) + this.pqr(3) * sin(this.angles(1)));
                      ((this.pqr(2) * sin(this.angles(1)) + this.pqr(3) * cos(this.angles(1)))/cos(this.angles(2)))];

    this.attitSttVect = this.angles + this.angPto * this.dt;



    this.r2pto = (1/this.m)*(LHb\[0; 0; (-T(1) -T(2) - T(3) - T(4))]) + [0; 0; 9.81];
    this.rPto  = this.rPto + this.r2pto * this.dt;
    this.r     = this.r + this.rPto * this.dt;

end
