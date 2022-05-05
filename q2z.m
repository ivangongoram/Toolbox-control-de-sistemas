function [numo,deno] =q2z(numi,deni)
%entra num y den como sym/ sale num y den como sym
syms z q
ln=length(sym2poly(numi));
ld=length(sym2poly(deni));
if ln>=ld
numi=numi/(q^(ln-1));
deni=deni/(q^(ln-1));
else
numi=numi/(q^(ld-1));
deni=deni/(q^(ld-1));
end
numo=vpa(collect(subs(numi,q,1/z)),4);
deno=vpa(collect(subs(deni,q,1/z)),4);
% numi=coeffs(numi,z,'all')
% deni=coeffs(deni,z,'all')
end