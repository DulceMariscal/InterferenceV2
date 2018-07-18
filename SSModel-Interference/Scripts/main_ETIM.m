%% Error-tuned model (Ingram 2017) - Uncomplete. Please see test_ETM
% 
% clc
% close all
% clear all
% 
% %% Load paradigms
% load('Experiment_paradigms.mat');
% groupNames = {'Savings','Interference'};
% 
% %% Model's parameters definitions
% thetas = [0 180]'; % 0<->+1, 180<->-1
% 
% %Slow state
% cs0 = 1;
% cs180 = .1;        %This models interference
% alphas0   = 0.97;  %Engaged primitives (both f and s) decays faster than the others
% alphas180 = 0.99;
% betas0   = 0.01;
% betas180 = 0.001;
% 
% %Fast state
% cf0   = 1;
% cf180 = .001;  %No interference
% alphaf0   = 0.2;
% alphaf180 = 0.25;
% betaf0   = 0.1;
% betaf180 = 0.01;
% 
% out = my_cnt_tun(0, cs0, cs180); %Takes in input Delta %In theory this shold be a gaussian. It is not necessary for locomotion. 
% 
% %% Model Initializations
% [ngroups, nsamples] = size(paradigms);
% npr = length(thetas); %Number of primitives
% xf = zeros(npr,nsamples); %Fast primitives
% xs = zeros(npr,nsamples);
% zf = zeros(1,nsamples);   %Fast motor output
% zs = zeros(1,nsamples);
% z = zf + zs;
% e = zeros(1,nsamples);
% delta=zeros(npr,nsamples);
% 
% %What happens when subjects walk tied??
% for group = 1:ngroups
%     pert = paradigms(group,:); 
%     thetaVis = pert; thetaVis((pert>=0)) = 0; thetaVis((pert<0)) = 180; %Direction of perturbation
%     pert = abs(pert); %Module of perturbation
%     
%     gn = groupNames{group};
%     
%     for n = 1:nsamples-1
%         
%         z(n) = zf(n) + zs(n);
%         e(n) = pert(n) - z(n);
%         delta(:,n) = thetas - thetaVis(n)*ones(npr,1); %Should always be 0, -180, +180
%         
%         xf(:,n+1) = my_cnt_tun(delta(:,n), alphaf0, alphaf180).*xf(:,n) + my_cnt_tun(delta(:,n), betaf0, betaf180).*cos().* ;
%         xf(n+1,:) = af*xf(n) + bf*e(n); % Error driven fast adaptation
%         xs(n+1) = as*xs(n) + bs*e(n); % Error driven slow adaptation 
%         
%     end
% end