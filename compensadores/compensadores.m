%% compensadores
%% limpiar
clc 
clear
close all
%% definicion de la planta
syms s kc
% fts=0.8587/(s*(0.2174*s+1))
n=s
d=(s^3)*(9*s + 5)
n1=sym(n)
d1=sym(d)
n1=double(sym2poly(n1))
d1=double(sym2poly(d1))
fts=n/d
%% respuesta
ft1=tf(n1,d1)
step(ft1)
info=stepinfo(ft1,'SettlingTimeThreshold',0.02)
tsp=info.SettlingTime

%% definicion del polinomio deseado
%caracteristicas de la planta
zd=0.3; %zita deseado de la planta 
tsd=24
%%ecuentra el wn
if zd<=1 %sub y criticamente
wnd=4/(zd*tsd)    
end
if zd>1 %sobre
wnd=4/(tsd*(zd-sqrt(zd^2-1)))    
end

%genera polinomio
pold=[1, 2*zd*wnd, wnd^2];
%raices del polinomio deseado
rpd=roots(pold)
repd=real(rpd(1))
impd=abs(imag(rpd(1)))
% pd=repd+impd*1i
%angulo del polinomio deseado
pd=repd+impd*1i
th=-atand(impd/repd)
th=-atan(impd/repd)%(180/pi)
%% determinar el angulo a compensar
%%%%%%%%%%%%%%%%%%%%%%metodo 1
disp('========metodo 1========')
if ~isempty(roots(n1))%caso de una constante
phiz=double(angle(subs((s-roots(n1)),s,pd)))
phiz=ones(1,length(phiz))*phiz
else
phiz=0
end
if ~isempty(roots(d1))%caso de una constante
phip=double(angle(subs((s-roots(d1)),s,pd)))
phip=ones(1,length(phip))*phip
else
phip=0
end
sg=-sign((phiz-phip))
n=1
phic=sg*pi*n+(phiz-phip)
phic*(180/pi)
%%%%%%%%%%%%%%%%%%%%%%%metodo 2
disp('========metodo 2========')
ft=double(subs(fts,s,pd))
% angle(ft)*(180/pi)
% phi=atan2d(imag(ft),real(ft))
phi=-atand(imag(ft)/real(ft))
phi=-atan(imag(ft)/real(ft))

comp=1;
n=ceil(phi/(pi/3))
for f=1:n
%% calculo del compensador
disp('===============')
disp(f)
phit=phi/n
mp=tan(th-phit/2)
mz=tan(th+phit/2)
xp=repd-impd/mp
xz=repd-impd/mz
vpa((s-xz)/(s-xp))
comp=comp*vpa((s-xz)/(s-xp));
k=double(solve(abs(subs(kc*comp*fts,s,pd))==1,kc))
end
%% rlocus
r=comp*fts
r=fts
[nr,dr]=numden(r)
rlocus(double(sym2poly(nr)),double(sym2poly(dr)))


