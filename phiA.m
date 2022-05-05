function [p] = phiA(Aphi,poldp) 
%% calculo del phiA
lm=length(Aphi);
p='0';
c=1;
for f=lm:-1:0
  p=strcat(p,'+',num2str(poldp(c)),'*Aphi^',int2str(f));
  c=c+1;
end
p=vpa(eval(p));
end
