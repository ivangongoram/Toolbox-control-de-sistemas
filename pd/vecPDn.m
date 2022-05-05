function [v] = vecPD(Ae,zdp,wnd) 
%% polinomio deseado 
lm=length(Ae); %bajo el criterio que indica que el grado del polinomio esta relacionado con el tamano de matriz
pold=[1, 2*zdp*wnd, wnd^2];
for f=1:lm-2
    pold=conv(pold,[1, 5*zdp*wnd]); %probar cambiando la distancia del polo 5->10
end
v=double(pold);
end