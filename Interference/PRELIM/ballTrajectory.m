function [x,y]=ballTrajectory(Fx,Fy,m,tt,g,t)

vx0=Fx*tt/m;
vy0=Fy*tt/m;

x=vx0*t;
y=vy0*t - 0.5*g*t.^2;



end