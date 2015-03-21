syms xd;
syms t s;
syms k13 k16 k22 k25 k31 k34;

x = ilaplace(((-xd*k31)/s)/(s^2-k31-s*k34))
