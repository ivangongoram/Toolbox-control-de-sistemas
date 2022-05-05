function [res] = solE2(ax,pold) 
%considerar el caso cuando no tengo ecuacion primer lugar
var=symvar(ax);
lv=length(var);
lx=length(ax);
A=double(jacobian(ax,var));
B=double(transpose(pold-subs(ax,var,zeros(1,lv))));
Ax=[A,B];
ra=rank(A);
rax=rank(Ax);
if ra ~= rax
disp('sistema incompatible')
%el sistema no tiene solucion
end
if ra==rax && ra==lv
disp('sistema compatible determinado')
%sistema con una unica solucion
end
if ra==rax && ra<lv
disp('sistema compatible indeterminado')
%sistema con multiples soluciones
end
[f,c]=size(A);%relacion con numero de ecuaciones y de incognitas
%% soluciones 
if lx>lv
x=inv(A.'*A)*(A.')*B;
disp('lx>lv')
end
if lv>lx
x=(A.')*inv(A*A.')*B;
disp('lv>lx')
end
if lv==lx
x=inv(A)*B;
disp('lv==lx')
end
res=[var.',vpa(x)];
end