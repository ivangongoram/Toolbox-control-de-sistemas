function [vk] = delKo(Aek,poldk,polck) 
lm=length(Aek);
vk='[';
for f=lm+1:-1:2
  vk=strcat(vk,num2str(poldk(f)),'-',num2str(polck(f)),';');
end
vk=strcat(vk,']');
vk=eval(vk);
end