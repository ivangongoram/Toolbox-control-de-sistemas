%% prueba de frecuencia de muestreo
%%limpiar espacio de trabajo
clear 
clc
close all
%defincion
syms s z p
%% hacer funcion de simplificacion de la planta
nums= (s+8)*(s+4)
dens=(s+10)*(s+5)*(s+7)
nums=sym(nums)
dens=sym(dens)
ilt=ilaplace(nums/dens)
%informacion de la planta
numsv=double(sym2poly(nums))
densv=double(sym2poly(dens))
sys=tf(numsv,densv)
% sys2=feedback(sys,1,-1)%retroalimentacion negativa
figure
bode(sys)
[wn,zeta,p] = damp(sys)
% figure
% bode(sys2)
% [wn,zeta,p] = damp(sys2)
% [mag,phase,wout] = bode(sys2);
% mag2=zeros(length(wout),1);
% for f=1:length(wout)
% mag2(f)=mag(1,1,f);
% end
% mag3=20*log10(squeeze(mag2));
% wq = interp1(mag3,wout,mag3(1)-3,'linear')
wbw = bandwidth(sys)
% fb2 = bandwidth(sys2)
%0.55 rad/s