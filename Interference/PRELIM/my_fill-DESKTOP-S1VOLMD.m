function my_fill(x,y1,y2,col,mspace,stopFill)
%% Everything has to be horizontal

x=x(1:end-stopFill);
y1=y1(1:end-stopFill);
y2=y2(1:end-stopFill);
% x=0:0.01:2*pi;                  %#initialize x array
% y1=sin(x);                      %#create first curve
% y2=sin(x)+.5;                   %#create second curve
X=[x,fliplr(x)];                %#create continuous x value array for plotting
Y=[y1-mspace,fliplr(y2)+mspace];              %#create y values for out and then back
fill(X,Y,col);                  %#plot filled area
end