function [vk] = delK(Aek,poldk,polck) %%se puede eliminar aek y pedir long de los poly
lm=length(Aek);
vk='[';
for f=lm+1:-1:2
  vk=strcat(vk,num2str(poldk(f)),'-',num2str(polck(f)),',');
end
vk=strcat(vk,']');
vk=eval(vk);
end