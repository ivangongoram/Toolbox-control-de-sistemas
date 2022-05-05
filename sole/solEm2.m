function [] = solEm2(ax,pold)  
%% solucion y presentacion de las constantes del controlador
errorn=" "; % error Empty sym: 1-by-0
l=length(ax);
for c=1:2
   if c==1 
for f=1:1:l
var=symvar(ax(f));
ct= strcmp(sym2str(var),errorn);
nv=length(var);
if (ct == false) & (nv == 1)
ax(f);
pold(f);
resu=solve(ax(f)==pold(f),symvar(ax(f)));
eval(strcat(char(var),'=',num2str(double(resu)),';'));
disp(strcat(char(var),'=',num2str(double(resu))))
end
end
   end
   if c==2
axa=subs(ax); %variable auxiliar
for f=1:1:l
var=symvar(axa(f));
ct= strcmp(sym2str(var),errorn);
nv=length(var);
if (ct == false) & (nv == 1)
axa(f);
pold(f);
resu=solve(axa(f)==pold(f),symvar(axa(f)));
eval(strcat(char(var),'=',num2str(double(resu)),';'));
disp(strcat(char(var),'=',num2str(double(resu))));
end
end
   end
end
end