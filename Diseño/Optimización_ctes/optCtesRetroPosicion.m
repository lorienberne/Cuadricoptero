syms xd;
syms t s;
syms k1 k2;

Xd = 1;
ke = 100;
kv = 1500;
ku = 10;


x = subs(ilaplace(((-xd*k1)/s)/(s^2-k1-s*k2)),xd,Xd);
e = Xd-x;
u = k2*diff(x,t) + k1*e;

fc = ke*int((e)^2,t,0,10) + kv*int(diff(x,t)^2,t,0,10) + ku*int(u^2,t,0,10);


K1 = -100;
K2 = -100;
while 1
    dk1 = double(subs(subs(diff(fc,k1),k1,K1),k2,K2));
    dk2 = double(subs(subs(diff(fc,k2),k1,K1),k2,K2));

    K1 = K1 - 0.0001*dk1;
    K2 = K2 - 0.0001*dk2;

    if( abs(dk1) < 0.01 && abs(dk2) < 0.01)
        break;
    end
end


f = subs(subs(x,k1,K1),k2,K2);
ezplot(f,[0 10]);
axis([-5 10 0 5]);

K1
K2

Kp = [0 0 K1/-0.0000094838 0 0 K2/-0.0000094838;
      0 0     0       0 0      0;
      K1/-96.145 0 0 K2/-96.145 0  0;
      0 K1/96.145 0 0 K2/96.145 0];