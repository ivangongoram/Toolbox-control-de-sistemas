function [V] = matV(Aev,Cev) 
lm=length(Aev);
V='[Cev';
for f=1:lm-1
   V=strcat(V,';','Cev*','Aev^',int2str(f));
end
V=strcat(V,']');
V=vpa(eval(V));
end