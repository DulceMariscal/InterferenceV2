
plot_with_se(fh,subplot_indices,x,y)
figure(fh)
subplot(subplot_indices(1),subplot_indices(1),subplot_indices(1))
x = linspace(0,1,20)';
y = sin(x);
dy = .1*(1+rand(size(y))).*y;  % made-up error values
fill([x;flipud(x)],[y-dy;flipud(y+dy)],[.9 .9 .9],'linestyle','none');
line(x,y)