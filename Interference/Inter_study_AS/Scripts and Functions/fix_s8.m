clc
close all
clear all

load 'I008_adapt_data.mat'
dataA1=INTERFERENCE_DATA{1};
dataA2=INTERFERENCE_DATA{2};
fitA1=INTERFERENCE_FIT_DATA{1};
fitA2=INTERFERENCE_FIT_DATA{2};

n1=length(dataA1);
n2=length(dataA2);
v1=1:n1;
v2=1:n2;

figure
subplot(1,2,1)
plot(v1,dataA1,'o');
hold on
plot(v1,fitA1,'LineWidth',2)

subplot(1,2,2)
plot(v2,dataA2,'o')
hold on
plot(v2,fitA2,'LineWidth',2)

dataA1(1)=(-0.3433);
my_exp =  @(c,t)(c(1)+c(2)*exp(-t/c(3)));
    x0 = [1 -0.5 20]; %Initial parameters exponential fitting
lb = [-10^10,  -10^10,     1  ]; 
ub = [+10^10,     0,       10^10];
indnan=isnan(dataA1);
[coeffs,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,v1(~indnan),dataA1(~indnan),lb,ub);
fit1=my_exp(coeffs,v1);

figure, plot(v1,dataA1,'ro',v1,fit1)




