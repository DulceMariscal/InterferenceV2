%% INTERACTING ADAPTIVE PROCESSES WITH DIFFERENT TIMESCALE UNDERLIE SHORT-TERM MOTOR LEARNING
% clc
% close all
clear all

%Definition of experiment
RELEARNING=1;
ERROR_CLAMP=2;
ERROR_CLAMP_RELEARNING=3;

%Select the experiment
experiment=RELEARNING;

%Parameters depending on the experiment
switch experiment
    case RELEARNING
        n_clamp=0;
        nt_a2=300-n_clamp;
        my_legend={'x(n)- Initial learning','x(n) - Relearning'};
    case ERROR_CLAMP
        n_clamp=300;
        nt_a2=300-n_clamp;
        my_legend={'x(n) - Initial learning','x(n) - Error clamp'};
    case ERROR_CLAMP_RELEARNING
        n_clamp=50;
        nt_a2=300-n_clamp;
        my_legend={'x(n) - Initial learning','x(n) - Error clamp'};
end
nt_comp=250; %Number of trials to compare


%Percentage subplot tight
pst=0.05;

%Parameters single-state and gain-specific models
A=0.99;
B=0.013;

%Parameters multi-rate model
Af=0.92;
As=0.996; %As must be several times closet to 1 than Af
Bf=0.03;  %Bf must be sever times greater than Bs
Bs=0.004;

figure;
%% Single-state model******************************************************
%0. Parameters experiment
%Parameters common to the 3 experiments
nt_baseline=50;
nt_a1=350;
nt_b=31;
ind_start_clamp=nt_baseline + nt_a1 + nt_b ;
ind_start_relearning=ind_start_clamp + n_clamp;
ntrials=nt_baseline + nt_a1 + nt_b + n_clamp + nt_a2 ;

% Perturbation f(n) (or disturbance)
f=[zeros(1,nt_baseline) ones(1,nt_a1) -1*ones(1,nt_b) zeros(1,n_clamp) ones(1,nt_a2)];


%1. Simulation
t=1:ntrials;
x=zeros(1,ntrials);
e=zeros(1,ntrials);

for trial=1:ntrials
    if trial<=ind_start_clamp || trial >= ind_start_relearning  %"Normal" trials: the error has to be computed"
        e(trial) = f(trial)-x(trial);
    else
        f(trial)=x(trial);
        e(trial)=0;                                             %Error clamp trials: the error is imposed to be 0
    end
    x(trial + 1) = A*x(trial) + B*e(trial);
end
x(end)=[];

%2. Plots
subplot_tight(2,3,1,pst)
plot(t,f,t,e,t,x,'LineWidth',3)
legend('f(n)','e(n)','x(n)')
grid on
axis tight

subplot_tight(2,3,4,pst)
tl=1:nt_comp;
if experiment==ERROR_CLAMP
    ind_comp=ind_start_clamp;
else
    ind_comp=ind_start_relearning;
end

plot(tl,x(1,nt_baseline + 1 : nt_baseline + nt_comp ),tl,x(1,ind_comp + 1: ind_comp + nt_comp),'LineWidth',3)
grid on
axis tight
legend(my_legend);

%% Gain-specific***********************************************************
%0. Parameters experiment
nt_baseline=50;
nt_a1=350;
nt_b=16;
ind_start_clamp=nt_baseline + nt_a1 + nt_b ;
ind_start_relearning=ind_start_clamp + n_clamp;
ntrials=nt_baseline + nt_a1 + nt_b + n_clamp + nt_a2 ;

%Perturbation f(n) (or disturbance)
f=[zeros(1,nt_baseline) ones(1,nt_a1) -1*ones(1,nt_b) zeros(1,n_clamp) ones(1,nt_a2)];

%1. Simulation
t=1:ntrials;
x=zeros(1,ntrials);
x1=zeros(1,ntrials);
x2=zeros(1,ntrials);
e=zeros(1,ntrials);

for trial=1:ntrials
    if trial<=ind_start_clamp || trial >= ind_start_relearning  %"Normal" trials: the error has to be computed"
        e(trial) = f(trial)-x(trial);
    else
        f(trial)=x(trial);
        e(trial)=0;                                             %Error clamp trials: the error is imposed to be 0
    end
    x1(trial + 1) = min(0,A*x1(trial) + B*e(trial)); %Always <=0
    x2(trial + 1) = max(0,A*x2(trial) + B*e(trial)); %Always >=0
    x(trial+1) = x1(trial+1)+x2(trial+1);
end
x1(end)=[]; x2(end)=[]; x(end)=[];

%2. Plots
subplot_tight(2,3,2,pst)
ind_relearn=nt_baseline + nt_a1 + nt_b;
% plot(t,f,t,e,t,x,'LineWidth',3)
% legend('f(n)','e(n)','x(n)')
%
plot(t,f,t,e,t,x,t,x1,'--',t,x2,'--','LineWidth',3)
legend('f(n)','e(n)','x(n)','x1(n) [neg]','x2(n) [pos]')
grid on
axis tight

subplot_tight(2,3,5,pst)
if experiment==ERROR_CLAMP
    ind_comp=ind_start_clamp;
else
    ind_comp=ind_start_relearning;
end
tl=1:nt_comp;
plot(tl,x(1,nt_baseline + 1 : nt_baseline + nt_comp ),tl,x(1,ind_comp + 1: ind_comp + nt_comp),'LineWidth',3)
grid on
axis tight
legend(my_legend);

%% Multi-rate model********************************************************
%0. Parameters experiment
nt_baseline=50;
nt_a1=350;
nt_b=16;
ind_start_clamp=nt_baseline + nt_a1 + nt_b ;
ind_start_relearning=ind_start_clamp + n_clamp;
ntrials=nt_baseline + nt_a1 + nt_b + n_clamp + nt_a2 ;

%Perturbation f(n) (or disturbance)
f=[zeros(1,nt_baseline) ones(1,nt_a1) -1*ones(1,nt_b) zeros(1,n_clamp) ones(1,nt_a2)];

%1. Simulation
t=1:ntrials;
x=zeros(1,ntrials);
x1=zeros(1,ntrials);
x2=zeros(1,ntrials);
e=zeros(1,ntrials);

for trial=1:ntrials
    if trial<=ind_start_clamp || trial >= ind_start_relearning  %"Normal" trials: the error has to be computed"
        e(trial) = f(trial)-x(trial);
    else
        f(trial)=x(trial);
        e(trial)=0;                                             %Error clamp trials: the error is imposed to be 0
    end
    x1(trial + 1) = Af*x1(trial) + Bf*e(trial); %Fast
    x2(trial + 1) = As*x2(trial) + Bs*e(trial); %Slow
    x(trial+1) = x1(trial+1)+x2(trial+1);
end
x1(end)=[]; x2(end)=[]; x(end)=[];

%2. Plots
subplot_tight(2,3,3,pst)
% plot(t,f,t,e,t,x,'LineWidth',3)
% legend('f(n)','e(n)','x(n)')
%
plot(t,f,t,e,t,x,t,x1,'--',t,x2,'--','LineWidth',3)
legend('f(n)','e(n)','x(n)','x1(n) [fast pr]','x2(n) [slow pr]')
grid on
axis tight

subplot_tight(2,3,6,pst)
tl=1:nt_comp;
if experiment==ERROR_CLAMP
    ind_comp=ind_start_clamp;
else
    ind_comp=ind_start_relearning;
end
plot(tl,x(1,nt_baseline + 1 : nt_baseline + nt_comp ),tl,x(1,ind_comp + 1: ind_comp + nt_comp),'LineWidth',3)
grid on
axis tight
legend(my_legend);
