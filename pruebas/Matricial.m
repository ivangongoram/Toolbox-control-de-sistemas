%%limpiar espacio de trabajo
clear 
clc
close all
hold on

%% definicion del espacio de estados
%definicion de las constantes
% b=6
% k=3
% m=2

%%definicion de los puntos de opracion
% xb=1
% fab=abs(xb)*xb+k*xb
%definicion de matrices
A=[-6,2,0;4,0,7;-10,1,11]
B=[5;0;1]
C=[1,2,1]
Co=[1,0,0]
D=[0]

%% determinar y graficar funcion de transferencia
[n,d] = ss2tf(A,B,C,D)
ft=tf(n,d)
% step(fab*ft)
step(ft)
info = stepinfo(ft,'SettlingTimeThreshold',0.02)
% tsp=info.SettlingTime
tsp=10
%% definicion de las caracteristicas del controlador
zd=1.3  %zita deseado de la planta 
zdo=1
tsd=0.95*tsp
tsdo=(1/5)*tsd
%%ecuentra el wn
if zd<=1 %sub y criticamente
wnd=4/(3*tsd) 
end
if zd>1 %sobre
wnd=4/(tsd*(zd-sqrt(zd^2-1)))    
end
%%ecuentra el wndo
if zdo<=1 %sub y criticamente
wndo=4/(3*tsdo) %ya que el zita es usualmente 1
end
if zdo>1 %sobre
wndo=4/(tsd*(zdo-sqrt(zdo^2-1)))    
end

%% matriz de observabilidad del sistema
%determinar si es observable y controlable
M=matM(A)
S=matS(A,B)
T=S*M
dT=det(T)
V=matV(A,C)
Q=inv(M*V)
dQ=det(Q)
%matrices
disp('=====empaquetar=======')
if dT ~= 0
disp('====Matriz de controlabilidad========')
[Ac,Bc,Cc,Tc,kc] = ctrbf(A,B,C)
%empaquetar
[Aec,Bec]=empesc(Ac,Bc,Cc)
[Arc,Brc]=empram(Ac,Bc,Cc)
[Apc,Bpc]=emppar(Ac,Bc,Cc)
end
if dQ ~= 0
disp('=====Matriz de observabilidad=======')
[Ao,Bo,Co,To,ko] = obsvf(A,B,C)
%empaquetar
[Aeo,Beo]=empesc(Ao,Bo,Co)
[Aro,Bro]=empram(Ao,Bo,Co)
[Apo,Bpo]=emppar(Ao,Bo,Co)
end
%% hallar las constantes
%%por si no quiero llevarlo a ningun sub espacio vectorial
[Ae,Be]=empesc(A,B,C)
[Ar,Br]=empram(A,B,C)
[Ap,Bp]=emppar(A,B,C)

%% controlador
l=length(Ap)
S=matS(Ap,Bp)
pold=vecPD(l,zd,wnd,5) 
polc=vecPC(Ap)

%ackerman
% phia=phiA(Apo,pold)
% inv(S)
% Kacker=double([zeros(1,length(Ap)-1),1]*inv(S)*phia)
ackMatlab= acker(Ap,Bp,roots(pold))
%segundo metodo 
vk=delK(Ap,pold,polc) 
T=S*matM(Ap)
ksm=vk*inv(T)

%asignacion de polos
syms k1 k2 ki1 ki2 ki3 s
[Ax,Bx,Cx]=matXp(A,B,C,[k1,k2,k3],[ki3,ki2,ki1])
ec=vpa(det(s*eye(length(Ax))-Ax))
ec=sym2poly(ec,s)
solE(ec,pold)

%% simulacion de servo 
[Ax,Bx,Cx]= matXp(A,B,C,[Kacker(1),Kacker(2)],[-Kacker(3),-Kacker(4),-Kacker(5)])
[n,d] = ss2tf(Ax,Bx,Cx,D)
ft=tf(n,d)
step(fab*ft)
info = stepinfo(ft,'SettlingTimeThreshold',0.02)
tsp=info.SettlingTime

% % observador
% V=matV(A,Co)
% polc=vecPC(A)
% pold=vecPD(A,zdo,wndo)
% %segundo metodo
% polc=vecPC(A) 
% vk=delKo(A,pold,polc) 
% Q=inv(matM(A)*V)
% ksmob=Q*vk 
% %ackerman
% phiA=phiA2(A,pold)
% Kackob=phiA*inv(V)*[zeros(length(A)-1,1);1]

