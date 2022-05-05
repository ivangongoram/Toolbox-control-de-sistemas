function [yo,yi,to] =sysresz2(sys,C,ref,a,ts)
%sysres: garfica la respuesta de la funcion de transferencia con su
%contolador ante las entradas de control(escalon, rampa, parabola)
%sys: sistema creado por tf(*)
%C: contolador de la planta evaluado, de tipo simbolico
%ref:(escalon, rampa, parabola)
syms s z
% C=sym(C);
[ns,ds]=tfdata(sys,'v');
ns=poly2sym(ns,z);
ds=poly2sym(ds,z);
%%
% if(C~=1)
[nc,dc]=tfdata(C,'v');
nc=poly2sym(nc,z);
dc=poly2sym(dc,z);
% else
% nc=1;
% dc=1;
% end

%%
nsc=ns*nc
dsc=ds*dc
%%
if ref=="e"
    i=sym(1);
end
if ref=="r"
    i=(z-1);
end 
if ref=="p" 
    i=(z-1)^2;
end
nr=nsc;
dr=i*(a*nsc+dsc);
%% graficacion
figure('name','Simulacion') 
[yo,to]=step(tf(sym2poly(nr),sym2poly(dr),ts));
[yi,ti]=step(tf(1,double(sym2poly(i)),ts),to);
 
%limites de graficacion
info=stepinfo(yi-yo,to,'SettlingTimeThreshold',0.001);
xl=info.SettlingTime;

%%respuesta de la planta y su entrada
subplot(1,2,1);
hold on
% stem(to,yo,'LineStyle','none')
stairs(to,yo)
plot(ti,yi,':k')
xlim([0 xl])
hold off
legend('output','intpunt')
title('Respuesta C*FT')

%%grafico del error
subplot(1,2,2);
hold on
% stem(to,(yi-yo),'LineStyle','none')
stairs(to,(yi-yo))
plot(to,zeros(length(to),1),':k')
xlim([0 xl])
hold off
legend('error','0')
title('Grafico del error')
end