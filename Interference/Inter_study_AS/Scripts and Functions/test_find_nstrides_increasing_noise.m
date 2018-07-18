%% Test function to compute number of strides and running_average function
clc
close all
clear all

tc=[200];
nc=length(tc);
t=0:.1:5000;
INCREASING=1; %Set to -1 for decreasing
NCONS=1;
ssperc=1-1/exp(1);

%% PARAMETERS--------------------------------------------------------------
sigmas=[0:0.1:0.8];
nnoise=length(sigmas);
FIRST_SAMPLES=20; %Number of strides to average to compute first value for trend signal
LAST_STRIDES=30; %Number of strides to average to compute steady state
RANDOM_NOISE=1;
nsim=100; %nsimulations
PLOT=0;
ssval=4;

%% INITIALIZATIONS---------------------------------------------------------
tauNoisy=zeros(1,nnoise);
tauNoisyDev=zeros(1,nnoise);
tauNoisyDevStderr=zeros(1,nnoise);

tauTrend=zeros(1,nnoise);
tauTrendDev=zeros(1,nnoise);
tauTrendDevStderr=zeros(1,nnoise);


nsamples=length(t);
TAU_N=zeros(nc,nsim);
TAU_TREND=zeros(nc,nsim);
nstrides=zeros(1,nc);
nstrides_n=zeros(1,nc);
nstrides_trend=zeros(1,nc);
Y=zeros(nsamples,nc);
Yn=zeros(nsamples,nc);
Yt=zeros(nsamples,nc);

%% PLOTS INITIALIZATIONS--------------------------------------------------
if PLOT==1
    figure
    legends={};
    mycolors={'r','g','b'};
    mycolors2={'k','m','c'};
end
for nn=1:nnoise
    %Current noise
    sigma=sigmas(nn);
    for ns = 1: nsim % For each simulation
        for i=1:nc %For each time constant
            
            %Build signals
            y = ssval-exp(-t./tc(i));
            if RANDOM_NOISE
                yn = y + randn(1,nsamples)*sigma;
            end
            
            yn_int=nan_interp(yn,'linear');
            ytrend = compute_trend(yn_int,FIRST_SAMPLES);
            
            %Compute steady state values
            ssvaln=nanmean(yn(1,end-LAST_STRIDES+1:end));
%             ssvalt=nanmean(ytrend(1,end-LAST_STRIDES+1:end));
            ssvalt=nanmean(ytrend(end));
            
            
%             %Compute nstrides
%             nstrides(i)=find_nstrides_to_perc_ss(y,ssval,ssperc,INCREASING,NCONS);
%             nstrides_n(i)=find_nstrides_to_perc_ss(yn,ssvaln,ssperc,INCREASING,NCONS);
%             nstrides_trend(i)=find_nstrides_to_perc_ss(ytrend,ssvalt,ssperc,INCREASING,NCONS);
            
            %Plot signals on individual panels
            if PLOT==1
                subplot(1,4,i)
                title([' tc = ' num2str(tc(i))]);
                hold on
                h1=plot(t,y,mycolors{1},t,yn,mycolors{2},t,ytrend,mycolors{3});
                set( h1 , { 'LineWidth' } , {2,1,2}' )
                xlim([0 5*tc(i)])
                
                
                %Plot y trend on same panel
                subplot(1,4,4)
                hold on
                plot(t,ytrend,mycolors2{i},'LineWidth',2);
            end
            
            % Store data
            Y(:,i) = y;
            Yn(:,i) = yn;
            Yt(:,i) = ytrend;
            
            % Store time constants
%             TAU_N(i,ns)=t(nstrides_n(i));
%             TAU_TREND(i,ns)=t(nstrides_trend(i));
            
        end
        %Compute nstrides
            nstrides(ns)=find_nstrides_to_perc_ss(y,ssval,ssperc,INCREASING,NCONS);
            nstrides_n(ns)=find_nstrides_to_perc_ss(yn,ssvaln,ssperc,INCREASING,NCONS);
            nstrides_trend(ns)=find_nstrides_to_perc_ss(ytrend,ssvalt,ssperc,INCREASING,NCONS);
        
    end
    
    tauNoisy(nn)=mean(t(nstrides_n));
    tauNoisyDev(nn)=mean(t(nstrides_n)-tc(i));
    tauNoisyDevStderr(nn)=std(t(nstrides_n)-tc(i))/sqrt(nsim);

    tauTrend(nn)=mean(t(nstrides_trend));
    tauTrendDev(nn)=mean(t(nstrides_trend)-tc(i));
    tauTrendDevStderr(nn)=std(t(nstrides_trend)-tc(i))/sqrt(nsim);

    
end
%%
figure
% vecn=1:nnoise;
% plot(sigmas,tauNoisy,'*-',sigmas,tauTrend,'*-')
errorbar(sigmas,tauNoisy-tc,tauNoisyDevStderr,'Color','g','LineWidth',3)
hold on
errorbar(sigmas,tauTrend-tc,tauTrendDevStderr,'Color','b','LineWidth',3);

legend('tauNoisy','tauTrend')
xlabel('Noise Standard Deviation')
ylabel('Estimated - True')
title([ 'Tc = ' num2str(tc(i)) '[sec].  Nsim = ' num2str(nsim) ' simulations. First strides = ' num2str(FIRST_SAMPLES)])
grid on
%% PLOT TIME CONSTANTS ON THE LAST PANEL-----------------------------------
if PLOT==1
    legends={'y','y_{noisy}','y_{trend}'};
    legends=[legends,'tau_y','tau_{y_{noisy}}','tau_{y_{trend}}'];
    
    for i=1:nc
        subplot(1,4,i)
        YLIM=ylim();
        hold on
        line([t(nstrides(i)) t(nstrides(i))], [YLIM],'Color',mycolors{1},'LineWidth',2,'LineStyle','--');
        hold on
        line([t(nstrides_n(i)) t(nstrides_n(i))], [YLIM],'Color',mycolors{2},'LineWidth',2,'LineStyle','--');
        hold on
        line([t(nstrides_trend(i)) t(nstrides_trend(i))], [YLIM], 'Color', mycolors{3},'LineWidth',2,'LineStyle','--');
        legend(legends);
        topPlot = findobj(gca, 'Color', mycolors{1});
        uistack(topPlot, 'top')
        grid on
        
        subplot(1,4,4)
        YLIM=ylim();
        hold on
        line([t(nstrides_trend(i)) t(nstrides_trend(i))], [YLIM],'Color', mycolors2{i},'LineWidth',2,'LineStyle','--');
        grid on
        
    end
    subplot(1,4,4)
    legend(['y_{trend} tau = ' num2str(tc(1))], ['y_{trend} tau = ' num2str(tc(2))], ['y_{trend} tau = ' num2str(tc(3))],...
        ['tau_{trend} = ' num2str(t(nstrides_trend(1)))], ['tau_{trend} = ' num2str(t(nstrides_trend(2)))], ['tau_{trend} = ' num2str(t(nstrides_trend(3)))]   );
    %% Display time constants estimates
    for i=1:nc
        disp(['Real tau = ' num2str(tc(i)) ' | Noisy tau = ' num2str(t(nstrides_n(i))) ' | Trend tau = ' num2str(t(nstrides_trend(i))) ])
    end
end

%% Compute statistics
TAU_TREND_MEANS=mean(TAU_TREND,2);
TAU_TREND_STDERR=std(TAU_TREND,0,2)/sqrt(nsim);
TAU_NOISY_MEANS=mean(TAU_N,2);
TAU_NOISY_STDERR=std(TAU_N,0,2)/sqrt(nsim);

%% PLOT RESULTS SIMULATION
figure
seq=1:nsim;
Ones=ones(1,nsim);
for i=1:nc
    subplot(nc,1,i)
    h=plot(seq,tc(i)*Ones,seq,TAU_N(i,:),seq,TAU_TREND(i,:));
    set( h , { 'LineWidth' } , {3,2,2}' )
    legend(['Real tau = ' num2str(tc(i)) ' [s]'], ['Noisy tau = ' num2str(TAU_NOISY_MEANS(i)) ' ± ' num2str(TAU_NOISY_STDERR(i)) ' [s] '], ['Trend tau = ' num2str(TAU_TREND_MEANS(i)) ' ± ' num2str(TAU_TREND_STDERR(i)) ' [s]'])
    title(['#sim = ' num2str(nsim) '    Noise ~N(0,' num2str(sigma) '^2)' '    Real tau = ' num2str(tc(i)) ' [s] '])
end

