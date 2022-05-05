function [pe] = aproxE(t,ap)  
%serie de aproximacion de euler^x
% t es tao, el tiempo de retardo
% ap es para tomar mas terminos de la serie y generar una mejor aproximacion
% pe es el polinomio de salida, es un vector con la aproximacion, para
% luego utlizarlo para convolucionarlo con el denominador de la planta
%se va a manejar un redondeo de r cifras, donde r=5
%  x   ∞    
% e = sum[ x^n ]
%     n=0   n!
% r=10;
pe=double(zeros(1,ap+1)); %%ap = grado del polinomio
b=ap;
for c=1:ap+1
    pe(c)=double((t^b)/factorial(b));
    b=b-1;
end
end