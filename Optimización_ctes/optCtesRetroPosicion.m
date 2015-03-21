syms xd;
syms t s;
syms k13 k16 k22 k25 k31 k34;

Xd = 1;
ke = 10000;
kv = 2000;
ku = 0.01;


x = subs(ilaplace(((-xd*k31)/s)/(s^2-k31-s*k34)),xd,Xd);
e = Xd-x;
u = k34*diff(x,t) + k31*e;

fc = ke*int((e)^2,t,0,10) + kv*int(diff(x,t)^2,t,0,10) + ku*int(u^2,t,0,10);


K31 = -100; 
K34 = -100;
while 1
    dk31 = double(subs(subs(diff(fc,k31),k31,K31),k34,K34));
    dk34 = double(subs(subs(diff(fc,k34),k31,K31),k34,K34));
    
    K31 = K31 - 0.01*dk31;
    K34 = K34 - 0.01*dk34;
    
    if( abs(dk31) < 0.01 && abs(dk34) < 0.01)
        break;
    end
end


f = subs(subs(x,k31,K31),k34,K34);
ezplot(f,[0 10]);
axis([-5 10 0 5]);