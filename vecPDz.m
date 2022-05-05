function [v] = vecPDz(lm,zdp,wnd,T,d) 
%% polinomio deseado 
p1=-2*exp(-zdp*wnd*T)*cos(wnd*T*sqrt(1-zdp^2))
p2=exp(-2*zdp*wnd*T)
v1=-0.05;
v2=-0.5;
a=d*(v2-v1)+v1
% a=d;
if lm>2
pold=[p2, p1, 1];    
end
if lm>3
for f=1:lm-3
    pold=conv(pold,[a,1]);
end
end
if lm<=2
disp('error')
v=0;
else
v=(pold);
end
end