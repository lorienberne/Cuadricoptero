classdef quad
    properties
        l       = 0.1;
        m       = 0;
        rotorIz = 0;
        inertia = [0 0 0;
                   0 0 0;
                   0 0 0];
        kProp   = [0 0];


        attitSttVect    = [0; 0; 0; 0; 0; 0]; %PHI, THETA, PSI, PHIPTO, THETAPTO, PSIPTO;
        attitSttVectPto = [0; 0; 0; 0; 0; 0]; %PHIPTO, THETAPTO, PSIPTO, PHI2PTO, THETA2PTO, PSI2PTO;

        posSttVect = [0; 0; 0; 0; 0; 0]; %X, Y, Z, XPTO, YPTO, ZPTO;
        posSttVectPto = [0; 0; 0; 0; 0; 0]; %XPTO, YPTO, ZPTO, X2PTO, Y2PTO, Z2PTO;

        r       = [0; 0; 0];
        rPto    = [0; 0; 0];
        r2pto   = [0; 0; 0];

        angles  = [0; 0; 0];
        angPto  = [0; 0; 0];
        ang2Pto = [0; 0; 0];

        pqr     = [0; 0; 0];
        pqrPto  = [0; 0; 0];

        rotorOmega = [0 0 0 0];
        quadFig;
        dt;

    end

    methods
        %CONSTRUCTOR -> INTIALICE CLASS ATTRIBUTES
        function this = quad(r, angles, m, l, i, rotorIz, kProp, dt)
            this.r       = r;
            this.angles  = angles;
            this.l       = l;
            this.m       = m;
            this.quadFig = figure();
            this.inertia = [i(1)  0    0 ;
                             0   i(2)  0 ;
                             0    0  i(3)];
            this.rotorIz = rotorIz;
            this.kProp = kProp;
            this.dt = dt;
        end
        drawQuad(this, axScale);
        this = simQuad(this);
    end

end
