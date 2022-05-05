%%limpiar espacio de trabajo
clear 
clc
close all
%defincion
syms s z q k%q=z^-1 cambio de variable

%% definicion de la planta y caracteristicas
nfs=2.847649071432879
dfs=s^2
nfs=sym(nfs)
dfs=sym(dfs)

%% comprobar quien domina la dinamica del sistema
figure('name','polos y ceros de FT')
H = tf(sym2poly(nfs),sym2poly(dfs));
pzmap(H)

%% planta con retardo(*dfs) o aproximacion de otra funcion(*nfs)
%  faprox=aproxF(exp(s),2)%%serie de aproximacion n-1:orden
faprox=1; %cuando no hay ninguna funcion para aproximar=1, comentar cuando si hay
% nfs=nfs*faprox; %para aproximaciones diferentes a la exponencial
dfs=dfs*faprox;
%---------
% figure('name','polos y ceros de la aproximacion')
% H = tf(1,sym2poly(faprox)); %para el caso de la exponencial
% pzmap(H)


%% grafica
fts=tf(double(sym2poly(nfs)),double(sym2poly(dfs)))
figure('name','respuesta de la FT')
step(fts)
info=stepinfo(fts,'SettlingTimeThreshold',0.02)
tsp=info.SettlingTime

%% caracteristicas de la planta deseada
zd=0.7 %zita deseado de la planta 
% tsd=tsp*0.75
tsd=15
%ecuentra el wn
if zd<=1 %sub y criticamente
% wnd=4/(3*tsd)    
wnd=4/(zd*tsd)
end
if zd>1 %sobre
wnd=4/(tsd*(zd-sqrt(zd^2-1)))    
end

%% discretizacion de la planta
%criterio de tiempo de muestreo
wbw=bandwidth(fts)
ts1=(2*pi)/(25*wbw);
ts2=(2*pi)/(6*wbw);
%hay infinitos valores
x=0.5;%x=(0->1)
ts=x*(ts2-ts1)+ts1
% ts=ts/100
ts=0.1 %comentar cuando se dermine matematicamente el tiempo
meth=["zoh","foh","impulse","tustin","matched","least-squares"];
meth2=["forward","backward","tustin"];%para c2d2
%revisar que metodo es el adecuado
m=1;
ftz=c2d(fts,ts,meth(1))
[ncz,dcz]=tfdata(ftz,'v');
[numq,denq]=z2q(poly2sym(ncz,z),poly2sym(dcz,z));%cambio de variable p=z^-1
tf(double(sym2poly(numq)),double(sym2poly(denq)),ts,'Variable','q')
%%determina grado del num y den en q=z^-1
gn=length(sym2poly(numq))-1; %grado del numerador
gd=length(sym2poly(denq))-1; %grado del denominador

%% detrminar cuantos ceros y polos en cero tiene la planta 
disp('cantidad de ceros en el origen')
co=so(sym2poly(nfs))
disp('cantidad de polos en el origen')
po=so(sym2poly(dfs)) 

%% calculo de las aciones integrales puras disponibles en la planta
disp('acciones integrales disponibles en la planta')
inp=po-co
%%calculo de acciones integrales necesarias para asegurar error cero
disp('acciones integrales necesarias para asegurar error cero para cada entrada')
aie=1-inp %%seguimiento a escalon  
air=2-inp %%seguimiento a rampa
aip=3-inp %%seguimiento a parabola

%% creacion del controlador
ai=[aie, air, aip];
S=[" "," "," "];
R=[" "," "," "];
fil=["1","1","1"];
for c=1:3
if ai(c)>=0
S(c)=(1-q)^(ai(c));
sn=ai(c);
else
S(c)=1;
sn=0;
end
rn=sn+gd-1;
for k=0:rn
R(c)=strcat(R(c),'+','r',int2str(k),'*q^',int2str(k));
end
f=(rn+gn)-(sn+gd);
for k=0:f
if k>0
fil(c)=strcat(fil(c),'+','s',int2str(abs(k-1)),'*q^',int2str(k));
end
end
end

%% polinomios del controlador por cada entrada
Re=str2sym(R(1));Rr=str2sym(R(2));Rp=str2sym(R(3));
Se=str2sym(S(1));Sr=str2sym(S(2));Sp=str2sym(S(3));
file=str2sym(fil(1));filr=str2sym(fil(2));filp=str2sym(fil(3));
%%generacion del polinomio del controlador
nce=Re;dce=(Se*file);
ncr=Rr;dcr=(Sr*filr);
ncp=Rp;dcp=(Sp*filp);
%presentacion del controlador
disp("==============================================")
pretty(Re/(Se*file));pretty(Rr/(Sr*filr));pretty(Rp/(Sp*filp));
disp("==============================================")
%%generacion del polinomio caracteristico
ne=numq*Re;nr=numq*Rr;np=numq*Rp;
de=denq*Se*file;dr=denq*Sr*filr;dp=denq*Sp*filp;

%% creacion del sistema de ecuaciones
axe=vpa(coeffs(de+ne,q,'all'),4)
axr=vpa(coeffs(dr+nr,q,'all'),4)
axp=vpa(coeffs(dp+np,q,'all'),4)

%%calcular longitud del polinomio
le=length(axe);lr=length(axr);lp=length(axp);

%% generar el polinomio deseado
d=1;%(0->1)distancia de los polos no dominante
polde=vecPDz(le,zd,wnd,ts,d) 
poldr=vecPDz(lr,zd,wnd,ts,d)
poldp=vecPDz(lp,zd,wnd,ts,d) 

ftze=tf(1,flip(polde,2),ts)
ftzr=tf(1,flip(poldr,2),ts)
ftzp=tf(1,flip(poldp,2),ts)

figure('name','respuesta deseada')
hold on
step(ftze,'k');
step(ftzr,'g');
step(ftzp,'r');
hold off
%% solucion y presentacion de las constantes del controlador
disp('========Escalon=======')
xe=solE(axe,polde)
ncxe=Ceval(nce,xe); dcxe=Ceval(dce,xe);
pretty(vpa(ncxe/dcxe,6))
ncxef=flip(double(sym2poly(ncxe)),2)
dcxef=flip(double(sym2poly(dcxe)),2)

% disp('========Rampa=======')
% xr=solE(axr,poldr)
% ncxr=Ceval(ncr,xr); dcxr=Ceval(dcr,xr);
% pretty(vpa(ncxr/dcxr,6))
% ncxrf=flip(double(sym2poly(ncxr)),2)
% dcxrf=flip(double(sym2poly(dcxr)),2)
% % 
% disp('========Parabola=======')
% xp=solE(axp,poldp)
% ncxp=Ceval(ncp,xp); dcxp=Ceval(dcp,xp);
% pretty(vpa(ncxp/dcxp,6))
% ncxpf=flip(double(sym2poly(ncxp)),2)
% dcxpf=flip(double(sym2poly(dcxp)),2)

%% simulacion
[ncz,dcz]=q2z(ncxe,dcxe)
fcz=tf(double(sym2poly(ncz)),double(sym2poly(dcz)),ts)
% cs=d2c(fz,meth(m)) %paso a continuo para poder graficasr
% [ncs,dcs]=tfdata(cs,'v');
% pretty(vpa(poly2sym(ncs,s)/poly2sym(dcs,s),4))
[y1,y2,t]=sysresz2(ftz,fcz,'e',1,ts);
info=stepinfo(y1,t,'SettlingTimeThreshold',0.02)
tsp=info.SettlingTime
[nz,dz]=tfdata(ftz,'v')