x = [-1 0 1];
y = [0.5 0 0.5];
xx = -1:.1:1;
yy = spline(x,y,xx);
figure
plot(x,y,'o',xx,yy)

x = [-1  0   1];
y = [0 0 0.5];
xx = -1:.1:1;
yy = spline(x,y,xx);
figure
plot(x,y,'o',xx,yy)


x = [-1  0   1];
y = [0.2 0 0.5];
xx = -1:.1:1;
yy = spline(x,y,xx);
figure
plot(x,y,'o',xx,yy)