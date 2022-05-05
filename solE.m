function [res] = solE(ax,pold) 
%considerar el caso cuando no tengo ecuacion primer lugar
var=symvar(ax);
nv=length(var);
nx=length(ax);
A=double(jacobian(ax,var))
B=double(transpose(pold-subs(ax,var,zeros(1,nv))))
%% soluciones 
if nx>nv
x=inv(A.'*A)*(A.')*B;
end
if nv>nx
x=(A.')*inv(A*A.')*B;
end
if nv==nx
x=inv(A)*B;
end
res=[var.',vpa(x)];
end