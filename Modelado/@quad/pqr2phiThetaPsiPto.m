function phiThetaPsiPto = pqr2phiThetaPsiPto(pqr,pOp)
  phiOmegaPsiPto = [(pqr(1) + tan(pOp(2)) * (pqr(2) * sin(pOp(1)) + pqr(3)*cos(pOp(1))));
                    (pqr(2) * cos(pOp(1)) +  pqr(3) * sin(pOp(1)))                      ;
                   ((pqr(2) * sin(pOp(1)) +  pqr(3) * cos(pOp(1)))/cos(pOp(2)))        ];
end
