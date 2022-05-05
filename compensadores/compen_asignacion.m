%%limpiar espacio de trabajo
clear 
clc
close all
syms s kc z1 z2 z3 z4
%% compenzador por asignacion de polos
n= 0.4974
d=(s + 0.3972)
n1=sym(n)
d1=sym(d)
nc=sym(s^4+z1*s^3+z2*s^2+z3*s+z4)
dc=sym((s^3))
pc=dc*d1+nc*n1
pc=vpa(collect(pc,s),5)
ax=coeffs(pc,s,'all')
l=length(ax);
%% definicion del polinomio deseado
%caracteristicas de la planta
zd=0.4; %zita deseado de la planta 
tsd=20
%%ecuentra el wn
if zd<=1 %sub y criticamente
wnd=4/(zd*tsd)    
end
%%pold
pd=vecPD2(l,zd,wnd,5)
disp('========solucion=======')
gain=solE(ax,pd)
Ceval(pc,gain)
% %% rlocus
% comp=vpa((s+0.50261359067146416101934391917894)/(s+4.1202906447980103266104379144963))
% fts=vpa(n/d)
% r=vpa(comp*fts)
% % r=fts
% [nr,dr]=numden(r)
% rlocus(double(sym2poly(nr)),double(sym2poly(dr)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ki1=1427.7166468929030997969675809145
% ki2=8302.8399434770035441033542156219
% ki3=23376.74593612691023736260831356
% kp=86.097466023218487407575594261289
% % c=(1.013e16*s^3 + 1.756e16*s^2 + 1.068e16*s + 3.142e15)/(1.126e15)
% % vpa(collect(c,s),5)
% % c=double(coeffs(c,s,'all'))
% c=[1,ki1/kp,ki2/kp,ki3/kp]
% roots(c)