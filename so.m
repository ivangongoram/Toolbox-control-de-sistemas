function [n] = so(v)
%% detrminar cuantos ceros y polos en cero tiene la planta
l=length(v); %grado del numerador
n=0; %s en el origen o en cero
for f = l:-1:1
        if v(f) ~=0
            break;
        end
        if v(f)==0
        n=n+1;
        end
end
end