clc
close all
clear all

nbas=150;
nA1=600;
nwashout=1350;
nA2=600;
nB=600;
ngrwo=600;
ntot=2*150+2*600+1350;
vec=1:ntot;
oddInd=1:80:ntot-1;
evenInd=41:80:ntot;
TF=0.03;

savingsProtocol=[zeros(1,nbas) ones(1,nA1) zeros(1,nwashout) ones(1,nA1) zeros(1,nbas) ];
interferenceProtocol=[zeros(1,nbas) ones(1,nA1) -1*ones(1,nA1) linspace(-1,0,nB) zeros(1,nbas) ones(1,nA1) zeros(1,nbas) ];

figure
plot(vec(oddInd),savingsProtocol(oddInd),'bo','MarkerFaceColor','b')
hold on
plot(vec(evenInd),interferenceProtocol(evenInd),'ro','MarkerFaceColor','r');
legend('Savings','Interference')
xlabel('Strides')
ylabel('Perturbation')
title('Protocols')
ylim([-1.1,1.1]);


figure
plot(vec,savingsProtocol+TF,'bo','MarkerFaceColor','b')
hold on
plot(vec,interferenceProtocol-TF,'ro','MarkerFaceColor','r');
legend('Savings','Interference')
xlabel('Strides')
ylabel('Perturbation')
title('Protocols')
ylim([-1.1,1.1]);


%%
load S007params.mat
adaptData=adaptData.removeBias('TM Base');
adaptData=adaptData.medianFilter(5);
vec=adaptData.data.Data(:,68);
% vec(66)=[];
% vec(606)=[];
% vec(602)=[];
% vec(602)=[];
% vec(260)=[];

figure, plot(vec(1:end,:),'o', 'MarkerFaceColor','b');

ylim([-0.3 0.3]); grid on, 
l=legend('Typical Savings subject');
yl=ylabel('Step Length Asymmetry');
xl=xlabel('Strides');
set(l,'FontSize',16); 
set(xl,'FontSize',16); 
set(yl,'FontSize',16); 
