function [numo,deno] =z2q(numi,deni)
%entra num y den como sym/ sale num y den como sym
syms z q
ln=length(sym2poly(numi));
ld=length(sym2poly(deni));
if ln>=ld
numi=numi/(z^(ln-1));
deni=deni/(z^(ln-1));
else
numi=numi/(z^(ld-1));
deni=deni/(z^(ld-1));
end
numo=vpa(collect(subs(numi,z,1/q)),4);
deno=vpa(collect(subs(deni,z,1/q)),4);
% numi=coeffs(numi,q,'all')
% deni=coeffs(deni,q,'all')
end