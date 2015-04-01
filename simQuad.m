function quad = simQuad(quad)
    [LHb, LH1, L12, L2b] = calcRotMat(quad.angles);

    T = [quad.kProp(1) * quad.rotorOmega(1)^2;
         quad.kProp(1) * quad.rotorOmega(2)^2;
         quad.kProp(1) * quad.rotorOmega(3)^2;
         quad.kProp(1) * quad.rotorOmega(4)^2];


    M = [                               (T(1) - T(3)) * quad.l;
                                        (T(4) - T(2)) * quad.l;
         quad.kProp(2) * (quad.rotorOmega(1)^2 - quad.rotorOmega(2)^2 + quad.rotorOmega(3)^2 - quad.rotorOmega(4)^2)];



    quad.pqrPto = quad.inertia\(M - cross(quad.pqr, quad.inertia*quad.pqr) - cross(quad.pqr, [0; 0; (quad.rotorIz * (-quad.rotorOmega(1) + quad.rotorOmega(2) - quad.rotorOmega(3) + quad.rotorOmega(4)))]));
    quad.pqr = quad.pqr + quad.pqrPto * quad.dt;
    quad.angPto = [(quad.pqr(1) + tan(quad.angles(2))*(quad.pqr(2)*sin(quad.angles(1)) + quad.pqr(3)*cos(quad.angles(1))));
                                (quad.pqr(2) * cos(quad.angles(1)) + quad.pqr(3) * sin(quad.angles(1)));
                      ((quad.pqr(2) * sin(quad.angles(1)) + quad.pqr(3) * cos(quad.angles(1)))/cos(quad.angles(2)))];

    quad.angles = quad.angles + quad.angPto * quad.dt;



    quad.r2pto = (1/quad.m)*(LHb\[0; 0; (-T(1) -T(2) - T(3) - T(4))]) + [0; 0; 9.81];
    quad.rPto  = quad.rPto + quad.r2pto * quad.dt;
    quad.r     = quad.r + quad.rPto * quad.dt;

end
