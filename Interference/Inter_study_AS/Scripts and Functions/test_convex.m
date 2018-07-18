clc
clear all
close all

a1=2
a2=3;
a3=4;
t=[0:.1:10];
e=a1*t + a2/t^a3;

figure
plot(t,e)
