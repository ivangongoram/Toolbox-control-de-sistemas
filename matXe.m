function [Ax,Bx,Cx] = matXe(A,B,C,k,ki)  
m2=[0];
Ax=[A-B*k,zeros(length(A),1)+B*ki;
    -C, m2];
Bx=[zeros(length(B),1);1];
Cx=[C,0];
end