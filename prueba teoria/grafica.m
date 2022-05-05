%% limpiar
clc 
clear
%% grafica
zd=[0.1:0.1:10]; %zita deseado de la planta 
tsd=[0.1:0.1:10];%tiempo de estabilizacion
%%ecuentra el wn
for f=1:100
if zd(f)<=1 %sub y criticamente
wnd(f)=4/(3*tsd(f))    
end
if zd(f)>1 %sobre
wnd(f)=4/(tsd(f)*(zd(f)-sqrt(zd(f)^2-1)))    
end
end
%raices del polinomio deseado
for f=1:100
pold=[1, 2*zd(f)*wnd(f), wnd(f)^2];
rpd=roots(pold)
z(f)=imag(rpd(1))
pold=0;
end
[X,Y]=meshgrid(zd,tsd);
[Z,Y]=meshgrid(z,tsd);
mesh(X,Y,Z), figure(gcf);