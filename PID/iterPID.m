function [pce] = iterPID(nu,de,t,z) 
%% PID 
%% definicion de las caracteristicas del controlador
%se va hacer un control con respecto a la entrada Ta
tsp=t %se definio este porque no se encontro ninguno para la planta
zd=z  %zita deseado de la planta 
tsd=0.95*tsp
%%ecuentra el wn
if zd<=1 %sub y criticamente
wnd=4/(3*tsd) 
end
if zd>1 %sobre
wnd=4/(tsd*(zd-sqrt(zd-1)))    
end

%defincion
syms s;
%% establecer la planta 
nump=nu;
denp=de;
tf(nump,denp);
%%creacion del polinomio de la planta
npolp= poly2sym(vpa(nump),s);
dpolp= poly2sym(vpa(denp),s);

%% detrminar cuantos ceros y polos en cero tiene la planta
n=length(nump)-1; %grado del numerador
d=length(denp)-1; %grado del denominador
%%ceros en el origen
co=0; %ceros en el origen
po=0; %polos en el origen
for f = n+1:-1:1
        if nump(f) ~=0
            break;
        end
        if nump(f)==0
        co=co+1;
        end
end
%%polos en el origen
    for f = d+1:-1:1
        if denp(f) ~=0
            break;
        end
        if denp(f)==0
         po=po+1;  
        end
    end
    
%% calculo de las aciones integrales puras disponibles en la planta
inp=po-co;
%%calculo de acciones integrales necesarias para asegurar error cero
aie=1-inp; %%seguimiento a escalon  
air=2-inp; %%seguimiento a rampa
aip=3-inp; %%seguimiento a parabola
%%determinamos el grado del polinomio del denominador
if (po-co)>=0
gd=d-co;
end
if (po-co)<0
gd=d-po;   
end
%%determinamos el grado con el que queda el denominador y num de constantes
if aie>0 
gde=gd+aie;
else
gde=gd;
end
if  air>0
gdr=gd+air;
else
gdr=gd;
end
if aip>0
gdp=gd+aip;
else
gdp=gd;
end
%% creacion del controlador
polce='';polcr='';polcp='';
ai=[aie, air, aip];
dif=[aie-gde, air-gdr, aip-gdp];
dif2=[gde, gdr, gdp];
polc=[" "," "," "];
for c=1:1 %cambia de 1 a 3-1 solo escalon-reduce tiempo
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
polce=polc(1);
% polcr=polc(2);polcp=polc(3);
%% polinomios del controlador por cada entrada
polce=str2sym(polce);

%%estraccion del numerador y denominador para simplificar calculos simbolicos
[nce,dce] = numden(polce);

%%generacion del polinomio caracteristico
de=dpolp*dce;
ne=npolp*nce;

%% creacion del sistema de ecuaciones
%%organizar los coeficientes para crear ecuaciones
re=collect(de+ne, s);
axe=coeffs(re,s,'all');

%%calcular longitud del polinomio
le=length(axe);

%% generar el polinomio deseado
polde=vecPD2(le,zd,wnd); 

%% solucion y presentacion de las constantes del controlador
disp('========Escalon=======')
pce=vpa(solE(axe,polde,polce));
end