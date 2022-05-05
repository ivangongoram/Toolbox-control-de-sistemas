function [Aer,Ber] = empram(A,B,C)
m1=[0,1];  
m2=[0,0];

Aer=[A,zeros(length(A),2);
    zeros(1,length(C)),m1;
    -C, m2];
Ber=[B;0;0];

end