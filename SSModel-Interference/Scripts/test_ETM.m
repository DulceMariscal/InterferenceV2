%% Test of ETM
%% Here I will reproduce the results from experiment 6 (Object lifting study)
%% And test the model's behaviors


my_set_default(20,3,5)

clc
clear all
close all

%% Choose what to do with this script, by selecting one of these three options
SIMULATE_EXP6 = 1;
NO_SAVINGS = 2;
FULL_INTERFERENCE = 3;

SEL_SIM = FULL_INTERFERENCE;
% SEL_SIM = NO_SAVINGS;
% SEL_SIM=SIMULATE_EXP6;

%% Load stuff
load('testMatrix'); INT=1; SAV=2;

%% Parameters papers
% alpha0=.87; alpha180=1; beta0=.74; beta180=.17; c0=1; c180=.17;

%% Parameters Ingram's code
alpha0=.92; alpha180=1; beta0=.79; beta180=.2; c0=1; c180=.3; AA = .9895; BA = .0131; CA = .4285;

%% Ideal output (cartesian coordinates)
po = [zeros(1,8); ones(1,8)];
no = [zeros(1,8); -1*ones(1,8)];

switch SEL_SIM
    case SIMULATE_EXP6
        x0=[.8 .8]';
        zideal = [po no po no];       % Ingram experiment
    case NO_SAVINGS
        x0=[0 0]';
        zideal = [po zeros(2,16) po];
    case FULL_INTERFERENCE
        x0=[0 0]';
        zideal = [po no no no no no no po];
end


% % Parameters definition
% alpha0 = .87;
% % alpha180 = .88; %My assumption
% alpha180 = 1; %Ingram
% 
% beta0 = .74;
% beta180 = .17;
% % sigmaAl = 38.9; %Fitted from another experiment
% % sigma = 14.5;   %Fitted from another experiment
% c0 = 1;   %This is fixed
% c180 = 0; %This is specified in the paper
% % alphaA = .9895;
% % betaA = .0131;
% % cA = .4285;
k = 15.68;
paramsE6 = [.87 .88 .74 .17 0];
params = [alpha0 alpha180 beta0 beta180 c180 AA BA CA];

% zideal = squeeze(aaa(INT,:,:)); % Interference Exp. INT

%% Simulation
[z, e, X] = ETM_evolve(params, zideal , x0);

%% Plot
figure
subplot(2,1,1)
plot(z(2,:),'-*'); hold on;
plot(e(2,:)); hold on;
plot(X'); hold on
% plot(cosd(thetav),'o'); hold on
legend('z_y','e_y','X^{90}','X^{-90}')
subplot(2,1,2)
plot(z(2,:),'-*'); hold on;
plot(abs(e(2,:))); hold on;
plot(X'); hold on
legend('z_y','abs(e_y)','X^{90}','X^{-90}')
ylim([-1.2 1.2])

%Add transitions
transitions = [0:8:32];
YL=ylim();
addTransitions(transitions,YL(1),YL(2));
