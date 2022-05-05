function [yo,yi,to] =sysres(sys,C,ref,a)
%sysres: garfica la respuesta de la funcion de transferencia con su
%contolador ante las entradas de control(escalon, rampa, parabola)
%sys: sistema creado por tf(*)
%C: contolador de la planta evaluado, de tipo simbolico
%ref:(escalon, rampa, parabola)
syms s
C=sym(C);
[ns,ds]=tfdata(sys,'v');
[nc,dc]=numden(C);
ns=poly2sym(ns,s); ds=poly2sym(ds,s);
nsc=ns*nc;
dsc=ds*dc;
if ref=="e"
    i=sym(1);
end
if ref=="r"
    i=s;
end 
if ref=="p" 
    i=s^2;
end
nr=nsc; dr=i*(a*nsc+dsc);
%% graficacion
figure('name','Simulacion') 
[yo,to]=step(tf(double(sym2poly(nr)),double(sym2poly(dr))));
[yi,ti]=step(tf(1,double(sym2poly(i))),to);

%limites de graficacion
info=stepinfo(yi-yo,to,'SettlingTimeThreshold',0.001);
xl=info.SettlingTime;

%%respuesta de la planta y su entrada
subplot(1,2,1);
hold on
plot(to,yo)
plot(ti,yi,':k')
xlim([0 xl])
hold off
legend('output','intpunt')
title('Respuesta C*FT')

%%grafico del error
subplot(1,2,2);
hold on
plot(to,(yi-yo))
plot(to,zeros(length(to),1),':k')
xlim([0 xl])
hold off
legend('error','0')
title('Grafico del error')
end