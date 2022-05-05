function [pce] = Ceval(pcc,res)
%evalua el polinomio simbolico del controlador en las soluciones de
%encontradas para este
[l,c]=size(res);
for f=1:l
eval(strcat(char(res(f,1)),'=',char(res(f,2)),';'));
end
pce=subs(pcc);
end