%%limpiar espacio de trabajo
clear 
clc
close all
%defincion
syms s

%% definicion de la planta y caracteristicas
nfs=2.5483828666546477492715894186404
dfs=s^2 + 0.000000000034964229840246996386675679629281*s + 0.080061817863362527702975057763979

nfs=sym(vpa(nfs))
dfs=sym(vpa(dfs))
%% planta con retardo(*dfs) o aproximacion de otra funcion(*nfs)
% faprox=aproxF(exp(s*0.1),3)%%serie de aproximacion
faprox=1; %cuando no hay ninguna funcion para aproximar=1, comentar cuando si hay
% nfs=nfs*faprox;
dfs=dfs*faprox;

%% grafica
fts=tf(double(sym2poly(nfs)),double(sym2poly(dfs)))
figure('name','respuesta de la FT')
step(fts)
info=stepinfo(fts,'SettlingTimeThreshold',0.02)
tsp=info.SettlingTime

%% caracteristicas de la planta deseada
zd=0.7; %zita deseado de la planta 
tsd=10
%ecuentra el wn
if zd<=1 %sub y criticamente
% wnd=4/(3*tsd)    
wnd=4/(zd*tsd)
end
if zd>1 %sobre
wnd=4/(tsd*(zd-sqrt(zd^2-1)))    
end
 
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
%%determinamos el grado del polinomio del denominador
disp('grado del denominador')
if (po-co)>=0
gd=length(sym2poly(dfs))-co-1
end
if (po-co)<0
gd=length(sym2poly(dfs))-po-1   
end
%%determinamos el grado con el que queda el denominador y num de constantes
disp('grado con el que queda el denominador por cada entrada')
if aie>0 
gde=gd+aie
else
gde=gd
end
if  air>0
gdr=gd+air
else
gdr=gd
end
if aip>0
gdp=gd+aip
else
gdp=gd
end
%% creacion del controlador
ai=[aie, air, aip];
dif=[aie-gde, air-gdr, aip-gdp];
dif2=[gde, gdr, gdp];
polc=[" "," "," "];
for c=1:3
    if ai(c)>=0
    for  f=ai(c):-1:dif(c)+1
    if f>0
    cad=strcat('ki',int2str(f));
    end
    if f==0 
    cad='kp';
    end
    if f<0 
    cad=strcat('kd',int2str(abs(f)));
    end
%     syms(cad) 
    polc(c)=strcat(polc(c),'+',cad,'*s^',int2str((-1)*f));
    end
    
    else
        for f=0:1:dif2(c)-1
    if f==0 
    cad='kp';
    end
    if f>0 
    cad=strcat('kd',int2str(abs(f)));
    end
%     syms(cad) 
    polc(c)=strcat(polc(c),'+',cad,'*s^',int2str(f));
        end
    end  
end
polce=polc(1);polcr=polc(2);polcp=polc(3);
%% polinomios del controlador por cada entrada
polce=str2sym(polce)
polcr=str2sym(polcr)
polcp=str2sym(polcp)

%%estraccion del numerador y denominador para simplificar calculos simbolicos
[nce,dce] = numden(polce); [ncr,dcr] = numden(polcr); [ncp,dcp] = numden(polcp);

%%generacion del polinomio caracteristico
ne=nfs*nce; nr=nfs*ncr; np=nfs*ncp;
de=dfs*dce; dr=dfs*dcr; dp=dfs*dcp;

%% creacion del sistema de ecuaciones
axe=coeffs(de+ne,s,'all')
axr=coeffs(dr+nr,s,'all')
axp=coeffs(dp+np,s,'all')

%%calcular longitud del polinomio
le=length(axe);lr=length(axr);lp=length(axp);

%% generar el polinomio deseado
syms z wn
d=10;
polde=vecPD(le,zd,wnd,d) 
poldr=vecPD(lr,zd,wnd,d) 
poldp=vecPD(lp,zd,wnd,d) 

figure('name','respuesta del polinomio deseado')
step(tf(wnd^2,double(poldp)))

%% solucion y presentacion de las constantes del controlador
disp('========Escalon=======')
gain=solE(axe,polde)
% disp('========Rampa=======')
% gain=solE(axr,poldr)
% disp('========Parabola=======')
% gain=solE(axp,poldp)

%% simulacion
co=Ceval(polce,gain)%controlador de la planta evaluado
[y1,y2,t]=sysres(fts,co,'e',1);
info=stepinfo(y1,t,'SettlingTimeThreshold',0.02)
tsp=info.SettlingTime

% % % % %% control continuo-discretizado
% % % % fco=tf(double(sym2poly(Ceval(nce,gain))),double(sym2poly(Ceval(dce,gain))))
% % % % %criterio de tiempo de muestreo
% % % % % wbw=bandwidth(ft)
% % % % % ts1=(2*pi)/(25*wbw);
% % % % % ts2=(2*pi)/(6*wbw);%wn de la planta?
% % % % % x=0.1;%x=(0->1)
% % % % % ts=x*(ts2-ts1)+ts1
% % % % ts=tsd/40
% % % % meth=["zoh","impulse","tustin","foh","matched","least-squares"];
% % % % meth2=["forward","backward","tustin"];%para c2d2
% % % % %revisar que metodo es el adecuado
% % % % ftz=c2d(fco,ts,meth(3))
% % % % [numz,denz]=tfdata(ftz,'v');
% % % % [numq,denq]=z2q(poly2sym(numz,z),poly2sym(denz,z));%cambio de variable p=z^-1
% % % % tf(double(sym2poly(numq)),double(sym2poly(denq)),ts,'Variable','q')
% % % % numpv=flip(double(sym2poly(numq)),2)
% % % % denpv=flip(double(sym2poly(denq)),2)



