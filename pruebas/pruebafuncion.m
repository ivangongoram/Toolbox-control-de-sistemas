% function [numo,deno] = tfz2p(numi,deni)
%%limpiar espacio de trabajo
clear 
clc
close all
%defincion
syms s z p
nums=0.05093
dens=s + 0.1541
nums=sym(nums)
dens=sym(dens)
num=double(sym2poly(nums))
den=double(sym2poly(dens))
fts=tf(num,den)

% step(fts)
info=stepinfo(fts,'SettlingTimeThreshold',0.02)
tsp=info.SettlingTime
%% caracteristicas de la planta
zd=0.7; %zita deseado de la planta 
tsd=(tsp)
%ecuentra el wn
if zd<=1 %sub y criticamente
% wnd=4/(3*tsd)    
wnd=4/(zd*tsd)
end
if zd>1 %sobre
wnd=4/(tsd*(zd-sqrt(zd^2-1)))    
end
%% discretizacion de la planta
% 'zoh'- Retención de orden cero (predeterminado). 
% 'foh'- Aproximación triangular (retención modificada de primer orden). 
% 'impulse' - Impulso de discretización invariante
% 'tustin'- Método bilineal (Tustin). 
% 'matched' - Método de coincidencia de polo cero
% 'least-squares' - Método de mínimos cuadrados
meth=['zoh','foh','impulse','tustin','matched','least-squares'];
%limites del tiempo de muestreo para z<=1
ts1=0.25%/wn
ts2=1.25%/wn
%hay infinitos valores
x=0.5;%x=(0->1)
ts=x*(ts2-ts1)+ts1
%revisar que metodo es el adecuado
ftz=c2d(fts,ts,meth(1))
[numz,denz]=tfdata(ftz,'v')
numz=poly2sym(numz,z)
denz=poly2sym(denz,z)
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%entra num y den como sym 
syms z p
ln=length(sym2poly(numz))
ld=length(sym2poly(denz))
if ln>=ld
numz=numz/(z^(ln-1))
denz=denz/(z^(ln-1))
else
numz=numz/(z^(ld-1))
denz=denz/(z^(ld-1))
end
numz=vpa(collect(subs(numz,z,1/p)))
denz=vpa(collect(subs(denz,z,1/p)))
numz=coeffs(numz,p,'all')
denz=coeffs(denz,p,'all')
% end