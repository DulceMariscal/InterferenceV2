clc
close all
clear all

my_set_default(20,3,20)

t=0:.01:600;

t1 = 1/60;
t2 = 1/(60*2);

s01= -0.4; i01= -0.4;

s02 = -.2

sa1 = 1-exp(-t1*t) + s01;
sa2 = 1-exp(-t1*t) + s02;

ia1 = 1-exp(-t1*t) + s01;
ia2 = 1-exp(-t2*t) + s02;

figure
subplot(1,2,1)
plot(t,sa1,'b--',t,sa2,'b-')
legend('A1','A2')
title('Savings')

subplot(1,2,2)
plot(t,ia1,'r--',t,ia2,'r-')
legend('A1','A2')
title('Interference')