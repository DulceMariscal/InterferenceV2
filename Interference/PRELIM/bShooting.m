%% Basketball shooting
clc
close all
clear all

m=0.625;
masses=[0.8*m m 1.2*m]; nm=length(masses);
YT=3.048;
XT=6.71;
h=2.03;
armspan=1.06*h;
arm=(armspan-0.69)/2;
% throwingHeight=arm+h;
throwingHeight=2.4384;
yt=YT-throwingHeight;
xt=XT;
tt=0.54;       %tbar [sec] Throwing time. Time during which the force is applied
T=0.5;        %T Time I want to wait before the ball enters the hoop
g=9.81;
t=0:0.01:T;
nt=length(t);

%Baseline parameters
Fx = m*xt/(tt*T);
Fy = (m/tt)*(yt/T + 0.5*g*T);


X=zeros(nm,nt);
Y=zeros(nm,nt);

for i=1:nm
    [X(i,:),Y(i,:)]=ballTrajectory(Fx,Fy,masses(i),tt,g,t);
end

%Translate back to real height
Y=Y+throwingHeight;

%Plot results
figure
for i=1:nm
    hold on
    plot(X(i,:),Y(i,:),'o')
end
grid on

