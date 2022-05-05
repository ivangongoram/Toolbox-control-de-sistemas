function [fz] = c2d2(fts,ts,mth)
syms s z
[n,d]=tfdata(fts,'v');
ns=poly2sym(n,s);
ds=poly2sym(d,s);
if mth=="forward"
fz=subs(ns/ds,s,(z-1)/(ts)); 
end
if mth=="backward"
fz=subs(ns/ds,s,(z-1)/(z*ts));    
end
if mth=="tustin"
fz=subs(ns/ds,s,(2*(z-1))/(ts*(z+1)));    
end
[nz,dz]=numden(fz);
dzt=coeffs(dz,z,'all');
nz=collect(nz/dzt(1),z);
dz=collect(dz/dzt(1),z);
fz=tf(double(sym2poly(nz)),double(sym2poly(dz)),ts);
% fz=nz/dz;%%simbolico
% pretty(vpa(nz/dz,7))
end