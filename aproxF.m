function [pe] = aproxF(fs,ap)
% fs => recive la funcion en terminos de s creado dentro de el programa externo
% ap => orden la aproximacion
% fs=str2sym(fs);
syms s
pe=taylor(fs,s,'ExpansionPoint',0,'Order',ap);
% pe=double(sym2poly(pe));
end