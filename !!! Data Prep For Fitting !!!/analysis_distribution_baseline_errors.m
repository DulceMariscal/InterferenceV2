clc
close all
clear all

%Load data
load('C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\!!! Data Prep For Fitting !!!\Data\DataForFitting.mat')

%Define parameters
intBas = 1:150;

%Plot params
map = brewermap(3,'Set1');

%Compute errors
err = perturbations  - adaptations;
be = adaptations(:,intBas);

%Compute stds
basStds = nanstd(be,[],2);    %One for each group
basStd  = nanstd(be(:),[],1); %Overall
ns = 5;
%% Plots
% figure
% histogram(be,-1.3:.01:1.3,'facecolor',map(1,:),'facealpha',.5,'edgecolor','none')
% % hold on
% % histf(H2,-1.3:.01:1.3,'facecolor',map(2,:),'facealpha',.5,'edgecolor','none')
% % histf(H3,-1.3:.01:1.3,'facecolor',map(3,:),'facealpha',.5,'edgecolor','none')
% % box off
% % axis tight
% % legalpha('H1','H2','H3','location','northwest')
% % legend boxoff


grCols={'r','b'};
figure
M = [1 2 3; 4 5 6];
maxErr = max(max(abs(err)))*1.1;

for gr=1:2
    %Erros during experiment - Individual
    subplot(2,3,M(1,gr))
    plot(err(gr,:),grCols{gr}); hold on;
    plot(perturbations(gr,:)*maxErr,'k'); hold on;
    ylim([-maxErr maxErr])
    
    % Errors distributions - Individual
    subplot(2,3,M(2,gr))
    histogram(err(gr,:),'facecolor',map(gr,:),'facealpha',.5,'edgecolor','none'); hold on
    tops = histogram(be(gr,:),'facecolor',[0 0 0],'facealpha',1,'edgecolor','none'); hold on
    legend('All', 'Baseline')
    box off
    axis tight
    legend boxoff
    xlim([-maxErr maxErr])
    YL = ylim();
    area(ns*[-basStds(gr) +basStds(gr)],YL(2)*[1 1],'facecolor',map(3,:),'facealpha',.5);
%     line([-basStds(gr) +basStds(gr)])

    
    %Erros during experiment - Overlapped
    subplot(2,3,M(1,3))
    plot(err(gr,:),grCols{gr}); hold on;
    ylim([-maxErr maxErr])
    
    %Erros distributions - Overlapped
    subplot(2,3,M(2,3),grCols{gr})
    histogram(err(gr,:),'facecolor',map(gr,:),'facealpha',.5,'edgecolor','none')
    hold on
    xlim([-maxErr maxErr])
    
    uistack(tops,'top')
end

legend('Interference', 'Savings')

