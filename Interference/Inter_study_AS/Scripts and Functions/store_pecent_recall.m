%% Compute percent recall and assume value for I008
clc 
close all
clear all

FIRST_STIDE=1;
INTERFERENCE=1;
SAVIGNS=2;

load('C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Interf_study_AS\Intermediate data\PARAMETERS_ALL.mat')
pertRatio=zeros(1,2);
r=zeros(1,2);
m=zeros(1,2);
b=zeros(1,2);

indSubs={[1 2 3 4 5 6 8],[1:8]};
figure
for group=1:2
    is=indSubs{group};
    pertA1=squeeze(PARAMETERS_ALL{group}(1,FIRST_STIDE,is))'; %y
    pertA2=squeeze(PARAMETERS_ALL{group}(2,FIRST_STIDE,is))'; %x
    
    [r(group),m(group),b(group)] = regression(pertA2,pertA1);

    
    pertRatio(group)=mean( pertA1./pertA2 );
    
    subplot(1,2,group)
    scatter(pertA2,pertA1);
    hold on
    plot(pertA2,b(group)+m(group)*pertA2)
    xlabel('Perturbation A2')
    ylabel('Perturbation A1')
    axis equal
    grid on
end

% save percRec %P1/P2 for INTERFECENCE and SAVINGS 

initialPertI008_A2=-0.3433;
initialPertI008_A1=pertRatio(INTERFERENCE)*initialPertI008_A2; %Estimated
initialPertI008_A1_alt=b(INTERFERENCE) + m(INTERFERENCE)*initialPertI008_A2;

save initialPertI008_A1_alt