clc
close all
clear all

%% Upload stuff
load('defaultColors.mat');
col=defaultColors;

%% Plot parameters
my_set_default(20,3,20);
gnames = {'Savings','Interference'};
offs = 0.05;

%% Time parameters
st = .01;
tstart=1;
tstop=10;
t=tstart:st:tstop;

%% Protocols
pertS = [ zeros(1,150) ones(1,600) zeros(1,1350) ones(1,600) zeros(1,150)];
pertI = [ zeros(1,150) ones(1,600) (-1)*ones(1,600) linspace(-1,0,600) zeros(1,150) ones(1,600) zeros(1,150)];
nsamples = length(pertS);

%% Plot protocols
figure
plot(pertS + offs,'.');
hold on
plot(pertI - offs,'.');
legend(gnames)


%% Model parameters
af = 0.2011;
as = 0.9965;
bf = 0.0739;
bs = 0.0134;
ape = .9999;
ane = .9999;
bpe = .001;
bne = .001;
bint = 0.001; % !Not used anymore!
bfastFac = 2;
bslowFac = 0.03;
bslowInt = 0.01;

%% Model initializations
xf = zeros(1,nsamples);  % Fast state
xs = zeros(1,nsamples);  % Slow state
xpe = zeros(1,nsamples); %
xne = zeros(1,nsamples); %
x = xf + xs;             % Motor output
e = zeros(1,nsamples);   % Error (Input)

%% Simulations
paradigms = [pertS; pertI];
ngroups = size(paradigms,1);
groupNames = {'Savings Group','Interference Group'};

%% Figures initializations
fc = figure('NumberTitle', 'off', 'Name', ['Comparison - Slow contextual tuning']);
AAs = zeros(4,nsamples,ngroups);
for group = 1:ngroups
    
    pert = paradigms(group,:);
    gn = groupNames{group};
    
    for n = 1:nsamples-1
        x(n) = xf(n) + xs(n);
        e(n) = pert(n) - x(n);        % Kinematic error previous step
        xf(n+1) = af*xf(n) + bf*e(n); % Error driven fast adaptation
        xs(n+1) = as*xs(n) + bs*e(n); % Error driven slow adaptation
        
        % Fast contextual tuning
        if e(n)>0
            xf(n+1) = xf(n+1) + bfastFac*xpe(n)*e(n);
        elseif e(n)<0
            xf(n+1) = xf(n+1) + bfastFac*xne(n)*e(n);
        else
        end
        
        % Slow contextual tuning
        if e(n)>0
            xs(n+1) = xs(n+1) + bslowFac*xpe(n)*e(n) + bslowInt*xne(n)*e(n);
        elseif e(n)<0
            xs(n+1) = xs(n+1) + bslowFac*xne(n)*e(n) + bslowInt*xpe(n)*e(n);
        else
        end
%         xs(n+1) = xs(n+1) + bint*xpe(n)*xne(n)*e(n);
        
        % Primitives update (effect of practice)
        % 1. Decay
        xpe(n+1) = ape*xpe(n);
        xne(n+1) = ane*xne(n);
        
        % 2. Increase
        if e(n)>0
            xpe(n+1) = xpe(n+1) + bpe*e(n);
        elseif e(n)<0
            xne(n+1) = xne(n+1) + bne*e(n);
        else
        end
        
    end
    
    %% Stuff to plot
    transitions = [151 750 2101 2700];
    
    strides = 1:nsamples;
    iep = find(e>0);  ep = zeros(1,nsamples); ep(iep) = e(iep);
    ien = find(e<0);  en = zeros(1,nsamples); en(ien) = e(ien);
    
    slowCompetition = (xpe.*xne).*e;
    fastIncreseP = ep.*xpe;
    fastIncreseN = en.*xne;
    
    %% Plots
    %% Figure 1------------------------------------------------------------
%     XLIMS=[0 2701];
    XLIMS=[0 nsamples];
    figure('NumberTitle', 'off', 'Name', [gn ' - Evolution']);
    
    
    %All toghether
    subplot(2,3,1:3)
    plot(strides, pert, strides, x, strides, xf, strides, xs, strides, e)
    legend('Pert','x','x_f','x_s','e')
    addTransitions(transitions,-1,1);
    xlim(XLIMS);
    
    %% How does error change the primitives?
    subplot(2,3,4)
    plot(strides, xpe, strides, xne, strides, ep, strides, en)
    legend('x_{pe}','x_{ne}','ep','en')
    addTransitions(transitions,-1,1);
    xlim(XLIMS);

    %% How much is the additional contribution changing xf?
    subplot(2,3,5)
    plot(strides, xf, strides, fastIncreseP,strides, fastIncreseN);
    legend('x_{f}','ep*x_{pe}','en*x_{ne}')
    addTransitions(transitions,-1,1);
    xlim(XLIMS);
    %% How much is the additional contribution changing xs?
    subplot(2,3,6)
    plot(strides, xs, strides, slowCompetition);
    legend('x_{s}', 'x_{pe}*x_{ne}*e')
    addTransitions(transitions,-1,1);
    xlim(XLIMS);
 
    %% A1 vs A2
    ia1 = transitions(1):transitions(2);
    ia2 = transitions(3):transitions(4);
    
    if group==1
        fff=figure('NumberTitle', 'off', 'Name', [gn ' - A1 vs A2']);
    else
        figure (fff)
    end
    
    sred  = 1:600;
    
    %A1
    subplot(1,2,group)
    hold on
    plot(sred, x(ia1),  '-.', 'Color', col(1,:));
    hold on
    plot(sred, xf(ia1),  '-.', 'Color', col(2,:));
    hold on
    plot(sred, xs(ia1), '-.', 'Color', col(3,:));
    hold on
    plot(sred, xpe(ia1), '-.', 'Color', col(4,:));
    hold on
    p1=plot(2, x(ia1(2)),'o','Color', col(1,:),...
        'MarkerSize',10);
    
    %A2
    plot(sred, x(ia2), 'Color', col(1,:));
    hold on
    plot(sred, xf(ia2),'Color', col(2,:));
    hold on
    plot(sred, xs(ia2), 'Color', col(3,:));
    hold on
    plot(sred, xpe(ia2), 'Color', col(4,:));
    hold on
    p2 = plot(2, x(ia2(2)),'o','Color', col(1,:),...
        'MarkerFaceColor',col(1,:),...
        'MarkerSize',10);
    if group==1
    legend('x^{A1}','x_f^{A1}','x_s^{A1}','x_{+}^{A1}','x^{A1}(1)',...
        'x^{A2}','x_f^{A2}','x_s^{A2}','x_{+}^{A2}','x^{A2}(1)')
        uistack(p1, 'top')
            ylabel('Adaptation')
    end
    xlim([-2 602])
    ylim([0 0.9])
    title({groupNames{group}});
    xlabel('Strides')

    %%
    AA = [xpe; xne; e; xpe.*xne.*e];
    figure('NumberTitle', 'off', 'Name', [gn ' - Slow contextual tuning']);
    plot(AA'), legend('xpe', 'xne', 'e', 'xpe.*xne.*e')
    
    figure(fc)
    subplot(2,1,1)
    hold on
    plot(bint*AA(4,:))
    
    subplot(2,1,2)
    hold on
    plot(AA(1:3,:)')
    AAs(:,:,group) = AA ; 
end

figure(fc)
subplot(2,1,1)
title('bint*xpe.*xne.*e')
legend('Savings','Interference')
addTransitions(transitions,-.1,.1);


subplot(2,1,2)
legend('xpeS', 'xneS', 'eS','xpeI', 'xneI', 'eI')
title('Components')
addTransitions(transitions,-1,1);

% hold on
% plot(sred, x(ia2), 'Color', col(1,:),   sred, xf(ia2),  'Color', col(2,:), ...
%      sred, xs(ia2), 'Color', col(3,:),   sred, xpe(ia2), 'Color', col(4,:))

% figure
% plot()
% xlim([1 160])
% hold on
% plot(x)
% hold on
% plot(xf)
% hold on
% plot(xs)
% hold on
% p