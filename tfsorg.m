function [numo,deno] = tfsorg(numi,deni)
%%cuadrar simplificacion/?
syms s
if isfloat(numi) && isfloat(deni)
numo=numi/deni(1);
deno=deni/deni(1);  
end
if ~isfloat(numi) && ~isfloat(deni)
denit=coeffs(deni,s,'all');
numo=collect(numi/denit(1),s);
deno=collect(deni/denit(1),s);
end
end 