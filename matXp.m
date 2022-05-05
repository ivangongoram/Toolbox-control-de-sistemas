function [Ax,Bx,Cx]= matXp(A,B,C,k,ki)
m1=[0,1,0;
   0,0,1];
   
m2=[0,0,0];

Ax=[A-B*k,zeros(length(A),3)+[B*ki(1),B*ki(2),B*ki(3)];
    zeros(2,length(C)),m1;
    -C, m2];
Bx=[zeros(length(B),1);0;0;1];
Cx=[C,0,0,0];
end