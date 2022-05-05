function [v] = vecPC(Aev) 
%polinomio caracteristico
syms s;
polc=det(s*eye(length(Aev)) - Aev);
polc=sym2poly(polc);
v=double(polc);
end