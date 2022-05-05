syms s
syms a1 a2 a3 a4
syms b1 b2
syms c1 c2
A=[a1, a2; 
   a3, a4]
B=[b1;b2]
C=[c1,c2]
D=[0]
%asignacion de polos
syms k1 k2 ki1 ki2 ki3
[Ax,Bx,Cx]=matXp(A,B,C,[k1,k2],[ki3,ki2,ki3])
pretty(collect(Cx*((s*eye(length(Ax))-Ax)^(-1))*Bx,s))