%% limpiar espacio de trabajo
clear 
clc

syms x1 x2 x3 x4 u s
%syms  m L b g A w t x1p x2p x3p x4p
m=0.1;
lo=0.03;
k=0.1;
g=9.8;
t=0;
Ap=0;
w=0;

%x1=theta
%x2=thetapunto
%x3=l
%x4=lpunto

x1p=x2
x2p=(u-(2*m*x3*x4*x2)-(Ap*w^2*sin(w*t)-g)*m*x3*sin(x1))/(m*x3^2)
x3p=x4
x4p=x3*x2^2-(k/m)*(x3-lo)-(g-Ap*w^2*sin(w*t))*cos(x1)


x=[x1 x2 x3 x4] %Vector de estados
xp=[x1p x2p x3p x4p] 
y=x3 %Salida con respecto a la posicion angular del pendulo


%Linealizacion mediante jacobiano
A=jacobian(xp,x) %Derivada parciales respecto a los estados
B=jacobian(xp,u) %derivada parcial respecto a las entradas
C=jacobian(y,x) %Derivada parcial de mi salida con respecto a los estados
D=jacobian(y,u) %derivada parcial de mi salida con respecto a la entrada

%puntos de operacion
x1=0.5 %Cero ya que al reemplazar queda x1=0
x2=0 %cero al ser thetapunto= derivada}
% x3=166820559477067253/112589990684262400
x3=double(solve(-(g-Ap*w^2*sin(w*t))*cos(x1)-(k/m)*(x3-lo)==0,x3)) %Valor al que quiero que se acerque mi referencia, punto de operacion lineal
x4=0 %Cero al ser xpunto= derivada
u=double(solve(u-(Ap*w^2*sin(w*t)-g)*m*x3*sin(x1)==0,u)) %Al reemplazar los valores anteriores se obtiene U=0
%u=10773796106792924998096566571266968634337789075623/20086725553237378444274526154264532531527537422284910441267200
% 
% 
% %Para reemplazar los puntos de operacion en las matrices 
A=eval(A)
B=eval(B)
C=eval(C)
D=eval(D)
% 

% %Para pasar de valores simbolicos a valores numericos operables
A=double(A)
B=double(B)
C=double(C)
D=double(D)
% 
[num,den]=ss2tf(A,B,C,D)
ft=tf(num,den)

%Para verificar si el sistema es controlable
S=[B A*B A^2*B A^3*B] %Matrices originales 2x2
det(S)
% 
% %Determinacion de A empaquetado y B empaquetado para diseño del controlador por ackerman
Ae=[A zeros(4,1);-C 0]
Be=[B;0]
% 
% %Calculo del polinomio deseado para aplicacion mediante ackerman
% 
ee=ss(A,B,C,D)
step(ee) %Grafica para ver tiempo de establecimiento en lazo abierto
% 
 tsd=20
 cd=0.4
 wnd=4.6/(tsd*cd)
 pd=conv([1 2*cd*wnd wnd^2],[1 2*cd*wnd wnd^2]);
 pd=conv(pd,[1 5*cd*wnd])
 
 polos=roots(pd)
 K=acker(Ae,Be,polos)
 k=[K(1) K(2) K(3) K(4)] 
 ki=-K(5)
% %Calculo observador 
 tsdo=tsd/10
 cdo=0.4
 wndo=4.6/(tsdo*cdo)
 Co=[1 0 0 0]
 pdo=conv([1 2*cdo*wndo wndo^2],[1 2*cdo*wndo wndo^2])
 O=[Co;Co*A;Co*A^2;Co*A^3]
 det(O)
 poloso=roots(pdo)
 Lo=acker(A',Co',poloso).'
% %  acker(A',C',poloso)
% %  L=ans'