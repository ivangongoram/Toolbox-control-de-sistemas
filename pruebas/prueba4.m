%%limpiar espacio de trabajo
clear 
clc
%% definicion de las caracteristicas del controlador
zd=0.95; %zita deseado de la planta 
zdo=1
tsp=20 
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
%% def
A=[1,2;3,-5]
B=[-2;0]
C=[1,-1]
D=[0]
zd=1
wnd=40

%% matriz de observabilidad del sistema
disp('====Matriz de controlabilidad========')
[Ac,Bc,Cc,Tc,kc] = ctrbf(A,B,C)
disp('=====Matriz de observabilidad=======')
[Ao,Bo,Co,To,ko] = obsvf(A,B,C)
% ==============
pold=vecPD(A,zdo,wndo)
V=matV(A,C)
phiA=phiA(A,pold)
a=[zeros(length(A)-1,1);1]
Kacker=phiA*inv(V)*[zeros(length(A)-1,1);1]

polc=vecPC(A) 
vk=delKo(A,pold,polc) 
Q=inv(matM(A)*V)
ksm=Q*vk 