function [S] = matS(Aes,Bes) 
lm=length(Aes);
S='[Bes';
for f=1:lm-1
   S=strcat(S,',','Aes^',int2str(f),'*','Bes');
end
S=strcat(S,']');
S=vpa(eval(S));
end