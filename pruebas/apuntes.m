syms2poly(s)

x= [-10:0.1:10] ;
y= [-10:0.1:10] ;
[X,Y]=meshgrid(x,y) ;
Z= 1./(X.*Y);
mesh(X,Y,Z), figure(gcf);


plot(t,r)

[r,t]=step(tf([1],[1 2 5 8]));

lsiminfo(r,t,'SettlingTimeThreshold',0.02)

S = stepinfo(tf([1],[1 2 5 8])) %%tiempo de estabilizacion de la planta

lsiminfo(r,t,'SettlingTimeThreshold',0.021)

S = stepinfo(sys)
S = stepinfo(sys,'SettlingTimeThreshold',0.02)

jacobian(f,v)

%%de funcion de transferencia a espacio de estados
% aplica es mismo metodo de halalr las matrices de observabilidad
% recordar que cuando dan una matriz en forma observable hay que trabajar
[A,B,C,D] = tf2ss(b,a)
% =================
% para observador
% ==============
pold=vecPD(A,zd,wnd)
V=matV(A,C)
phiA=phiA(A,pold)
a=[zeros(length(A)-1,1);1]
Kacker=phiA*inv(V)*[zeros(length(A)-1,1);1]

polc=vecPC(A) 
vk=delKo(A,pold,polc) 
Q=inv(matM(A)*V)
ksm=Q*vk 
% =================
% para retro
% ==============
pold=vecPD(Aep,zd,wnd) 
%%%%%
S=matS(Aep,Bep)
phiA=phiA(Aep,pold)
Kacker=[zeros(1,length(Aep)-1),1]*inv(S)*phiA
%%%%%%%
polc=vecPC(Aep) 
vk=delK(Aep,pold,polc) 
T=S*matM(Aep)
ksm=vk*inv(T)

%========================
%%plotear
h = stepplot(...); % Use this command to return plot handle to programmatically customize the plot. 
p = getoptions(h);
p.XLim = {[0, 1.8]};
p.YLim = {[0, 0.07]};
setoptions(h,p);
%=========================
ax = gca;
chart = ax.Children.Children(1);
datatip(chart,5.075,-27.06,'Location','northeast');

info = Simulink.MDLInfo ( 'mymodel' )
%================
poldes=vpa(coeffs((s^2+2*z*wn*s+wn^2)*(s+d*z*wn)^(le-3),s,'all'))
poldrs=vpa(coeffs((s^2+2*z*wn*s+wn^2)*(s+d*z*wn)^(lr-3),s,'all'))
poldps=vpa(coeffs((s^2+2*z*wn*s+wn^2)*(s+d*z*wn)^(lp-3),s,'all'))
%===============
%% detrminar cuantos ceros y polos en cero tiene la planta
n=length(nump)-1; %grado del numerador
d=length(denp)-1; %grado del denominador
%%ceros en el origen
co=0; %ceros en el origen
po=0; %polos en el origen
for f = n+1:-1:1
        if nump(f) ~=0
            break;
        end
        if nump(f)==0
        co=co+1;
        end
end
%%polos en el origen
    for f = d+1:-1:1
        if denp(f) ~=0
            break;
        end
        if denp(f)==0
         po=po+1;  
        end
    end