function [Aep,Bep]= emppar(A,B,C)
m1=[0,1,0;
   0,0,1];
   
m2=[0,0,0];

Aep=[A,zeros(length(A),3);
    zeros(2,length(C)),m1;
    -C, m2];
Bep=[B;0;0;0];

end