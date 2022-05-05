%% ejemplo cuando me dan funcion de trasnferencia y la paso a espacio de estados
%%limpiar espacio de trabajo
clear 
clc
%% definicion de las caracteristicas del controlador
zd=1; %zita deseado de la planta 
tsp=20   %tiempo de establecimiento de la planta
% tsd=0.95*tsp; %tiempo deseado por un porcentaje de exigencia de la planta
tsd=1;
%%ecuentra el wn
if zd<=1 %sub y criticamente
wnd=4/(3*tsd)    
end
if zd>1 %sobre
wnd=4/(tsd(zd-sqrt(zd-1)))    
end
wnd=4
%% definir polinomio
syms s
syms x
fts=(4)/(s^2)
s=x %cambio de variable para utlizar funcion de matlab
fts=subs(fts)
[nft,dft] = numden(fts)
nft = sym2poly(nft)
dft = sym2poly(dft)
ft=tf(nft,dft)
% % csys = canon(ft,'companion') %%arroja la forma canonica observable
%% formas canonicas
disp('=====Matrices de la forma canocica observable=======')
[Afco,Bfco,Cfco,Dfco] = tf2ss(nft,dft) %forma canonica observable
%ecuaciones de relacion entre las formas 
disp('=====Matrices de la forma canocica controlable=======')
Afcc=transpose(Afco)
Bfcc=transpose(Cfco)
Cfcc=transpose(Bfco)
Dfcc=Dfco
% %% matriz de observabilidad del sistema
% disp('====Matriz de controlabilidad========')
% [Ac,Bc,Cc,Tc,kc] = ctrbf(A,B,C)
% disp('=====Matriz de observabilidad=======')
% [Ao,Bo,Co,To,ko] = obsvf(A,B,C)
%%aplicacion de los metodos
disp('=====empaquetar=======')
[Aee,Bee]=empesc(Afcc,Bfcc,Cfcc)
[Aer,Ber]=empram(Afcc,Bfcc,Cfcc)
[Aep,Bep]=emppar(Afcc,Bfcc,Cfcc)

%% calculo del S para parabola
lm=length(Aep) %calculo de la longitud de la matriz=grado del polinomio
% S='[Bep'
% for f=1:lm-1
%    S=strcat(S,',','Aep^',int2str(f),'*','Bep');
% end
% S=strcat(S,']')
% S=eval(S)
S=matS(Aep,Bep)
% %% polinomio deseado 
% pold=[1, 2*zd*wnd, wnd^2]
% for f=1:lm-2
%     pold=conv(pold,[1, 10*zd*wnd]); %probar cambiando la distancia del polo 5->10
% end
% pold
pold=vecPD(Aep,zd,wnd) 
%%%%%%%%%%%%%%%%%%%%%%%%
%% calculo del phiA
% phiA='0'
% c=1;
% for f=lm:-1:0
%   phiA=strcat(phiA,'+',num2str(pold(c)),'*Aep^',int2str(f));
%   c=c+1;
% end
% phiA
% phiA=eval(phiA)
phiA=phiA(Aep,pold)
%% calculo de las constantes 
Kacker=[zeros(1,length(Aep)-1),1]*inv(S)*phiA

%% segundo metodo
% syms s
% syms x
% polc=det(s*eye(length(Aep)) - Aep)
% s=x
% polc=subs(polc)
% polc=sym2poly(polc)
polc=vecPC(Aep) 
% vk='['
% for f=lm+1:-1:2
%   vk=strcat(vk,num2str(pold(f)),'-',num2str(polc(f)),',');
% end
% vk=strcat(vk,']')
% vk=eval(vk)
vk=delK(Aep,pold,polc) 
T=S*matM(Aep)
%hallar las constantes
ksm=vk*inv(T)