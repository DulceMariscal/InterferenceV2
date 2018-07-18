%% Here I am showing tha the method to compute number of strides to reach midpert is inveriant to scaling.
%% In fact ns1=ns2
clc
close all
clear all

t = 0:.01:10;
f = 1-3*exp(-3*t);
figure, subplot(1,2,1), plot(t,f)

%% No scaling
m=min(f);
M=max(f);
th = (m+M)/2;
ns1 = find(f>=th,1);

%% Scaling
fscaled = (f - m)/(M-m);
subplot(1,2,2), plot(t,fscaled);
ns2 = find(fscaled>=0.5,1);

