%%limpiar espacio de trabajo
clear 
clc
%% definicion del espacio de estados
%definicion de las constantes
b=6
k=3
m=2
xb=1
%definicion de matrices
A=[0, 1; 
  -((xb^2/abs(xb))+k)/m, -b/m]
B=[0;1/m]
C=[1,0]
D=[0]

%% determinar y graficar funcion de transferencia
[n,d] = ss2tf(A,B,C,D)
ft=tf(n,d)
step(4*ft)
info = stepinfo(ft,'SettlingTimeThreshold',0.02)
tsp=info.SettlingTime
%% definicion de las caracteristicas del controlador
zd=1.3; %zita deseado de la planta 
zdo=1
tsd=0.95*tsp;
tsdo=(1/5)*tsd;
%%ecuentra el wn
if zd<=1 %sub y criticamente
wnd=4/(3*tsd) 
wndo=4/(3*tsdo) %ya que el zita es usualmente 1
end
if zd>1 %sobre
wnd=4/(tsd*(zd-sqrt(zd-1)))    
end
%%ecuentra el wndo
if zdo<=1 %sub y criticamente
wndo=4/(3*tsdo) %ya que el zita es usualmente 1
end
if zdo>1 %sobre
wndo=4/(tsd*(zdo-sqrt(zdo-1)))    
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
S=matS(Ap,Bp)
pold=vecPD(Ap,zd,wnd) 
polc=vecPC(Ap)
%ackerman
phiA=phiA(Ap,pold)
Kacker=[zeros(1,length(Ap)-1),1]*inv(S)*phiA
Kacker=double(Kacker)
%segundo metodo 
vk=delK(Ap,pold,polc) 
T=S*matM(Ap)
ksm=vk*inv(T)

%% observador
V=matV(A,C)
polc=vecPC(A)
pold=vecPD(A,zdo,wndo)
%segundo metodo
polc=vecPC(A) 
vk=delKo(A,pold,polc) 
Q=inv(matM(A)*V)
ksmob=Q*vk 
%ackerman
phiA=phiA(A,pold)
Kackob=phiA*inv(V)*[zeros(length(A)-1,1);1]
