function [Aee,Bee] = empesc(A,B,C)  
m2=[0];
Aee=[A,zeros(length(A),1);
    -C, m2];
Bee=[B;0];
end