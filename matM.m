function [M] = matM(MAe)  %%%corregir error de simplificacion // mirar caso donde es 1x1
% %%limpiar espacio de trabajo
% clear 
% clc
syms x
% MAe=[1, 2,0,2;3,-5,3,0;-1,1,0,3;1, 2,4,2]
polc=det(x*eye(length(MAe)) - MAe);%;
polc=sym2poly(polc);%;
lp=length(polc);
gp=lp-1;
[nf,nc]=size(MAe);
if gp>=2 && nf==nc %%
polcv=zeros(1,lp);
%% dar vuelta al vector
a=0;
for f=1:lp
    polcv(f)=polc(lp-a);
    a=a+1;
end
% polcv;%;
%% dar vuelta a matriz identidad
I=eye(gp);
Iv=zeros(gp);
a=0;
for f=1:gp
    for c=1:gp
    Iv(f,c)=I(f,gp-a);
    a=a+1;
    end
    a=0;
end
%% calculo de m
M=zeros(gp);
for c=1:gp-1
    a=0;
    for f=1:gp-c
    M(f,c)=polcv(c+a+1);
    a=a+1;
    end
end
M=M+Iv;%;
else
    disp('error')
end 
end