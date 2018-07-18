clc
close all
clear all

%% Definition of experiment
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

%% Parameters multi-rate model (As in Materials and Methods section of Smith 2006)
Af=0.92;
As=0.996; %As must be several times closet to 1 than Af
Bf=0.03;  %Bf must be sever times greater than Bs
Bs=0.004;

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
k_true=[Af,Bf,As,Bs];
for trial=1:ntrials-1
    if trial<=ind_start_clamp || trial >= ind_start_relearning  %"Normal" trials: the error has to be computed"
%         e(trial) = f(trial)-x(trial);
    else
        f(trial)=x(trial);
%         e(trial)=0;                                             %Error clamp trials: the error is forced to be 0
    end
    e(trial) = f(trial) - x(trial);
    xvec = two_state_fc([],[x1(trial); x2(trial)],k_true,e(trial));
    x1(trial+1)=xvec(1);
    x2(trial+1)=xvec(2);
    x(trial+1)=sum(xvec);
    
%     x1(trial + 1) = Af*x1(trial) + Bf*e(trial); %Fast
%     x2(trial + 1) = As*x2(trial) + Bs*e(trial); %Slow
%     x(trial+1) = x1(trial+1) + x2(trial+1);
end

% x1(end)=[]; x2(end)=[]; x(end)=[];
e = f-x;

%2. Plots
figure
subplot_tight(2,2,1,pst)
% plot(t,f,t,e,t,x,'LineWidth',3)
% legend('f(n)','e(n)','x(n)')
%

plot(t,f,t,e,t,x,t,x1,'--',t,x2,'--','LineWidth',3)
legend('f(n)','e(n)','x(n)','x1(n) [fast pr]','x2(n) [slow pr]')
grid on
axis tight

subplot_tight(2,2,2,pst)
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

%% STATE ESTIMATION
%Initial state
x0=[0 0];
%Initial parameters guess
k0=[1 0 1 0]; 

% myFunc1 = @(x) myFunc(x, a1, b1, c1, d1);
% format long e
% options = optimset('TolFun',1e-3,'TolX',1e-2,'MaxFunEvals',500,'MaxIter',1000,'Display','Iter');
%options=optimset('MaxFunEvals',1000,'MaxIter',1000,'Display','Iter');
x_data=x; %Motor output (I can measure it because I know the perturbation f(t) and the error e(t) )

%1st version. x0 known
[k_min]=fminsearch(@two_state_lsq,k0,[],t,x_data,x0,e);

%%
%2nd version. x0 not known
k0_ext=[x0 k0];
[k_ext_min]=fminsearch(@two_state_lsq_noIC,k0_ext,[],t,x_data,e);


