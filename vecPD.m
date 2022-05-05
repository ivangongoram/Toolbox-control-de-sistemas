function [v] = vecPD(lm,zdp,wnd,d) 
%% polinomio deseado 
%definir la distancia del polo
% d=5;
if lm>2
pold=[1, 2*zdp*wnd, wnd^2];    
end
if lm>3
for f=1:lm-3
    pold=conv(pold,[1, d*zdp*wnd]); %probar cambiando la distancia del polo 5->10
end
end
if lm<=2
disp('error')
v=0;
else
v=vpa(pold);
end
end