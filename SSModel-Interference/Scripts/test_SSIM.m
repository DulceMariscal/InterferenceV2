clc
close all
clear all

af = 0.2011;
as = 0.9965;
bf = 0.0739;
bs = 0.0134;

aet = .9999; %ape, ane
bet = .001;  %bpe, bne


bfet = 2;    %bfastFac
bset = 0.03; %bslowFac
bsint= 0.01; %bslowInt

% Removal of facilitation in the slow state. 
% The model does not seem to be able to show savings if we remove the
% facilitation in the slow state

% % bset = 0; %bslowFac
% % bsint = .001

params = [af, bf, bfet, as, bs, bset, bsint, aet, bet];
x0 = [0 0 0 0];
pertS = [ zeros(1,150) ones(1,600) zeros(1,1350) ones(1,600) zeros(1,150)];
pertI = [ zeros(1,150) ones(1,600) (-1)*ones(1,600) linspace(-1,0,600) zeros(1,150) ones(1,600) zeros(1,150)];
perts = [pertI; pertS];
t = 1:2850;
a1ind = [151:750];
a2ind = [2101:2700];
ainds = [a1ind; a2ind];
aeind = [2701:2850];

lstyles = {'o', '--'; 'o', '-'};  DATA=1; FIT=2; %Data, Fit
cols2   = [.5 .5 .5; 0 0 0]; %A1, A2

f1 = figure('NumberTitle', 'off', 'Name', 'Whole Adaptation');
f2 = figure('NumberTitle', 'off', 'Name', 'A1 vs A2');
f3 = figure('NumberTitle', 'off', 'Name', 'After-effects');
tred=1:600;
gnames = {'Interference','Savings'};

condStyles = {':','-'};


for gr=1:2
    
    %Plot whole evolution
    [x, e, xf, xs, xpe, xne] = two_state_int_evolve1(params, perts(gr,:) , x0);
    figure(f1);
    subplot(2,1,gr)
    plot(t,x),      hold on
    plot(t,e),      hold on
    plot(t,xf),     hold on
    plot(t,xs),     hold on
    plot(t,xpe),    hold on
    plot(t,xne),    hold on
    legend('x', 'e', 'xf', 'xs', 'xpe', 'xne')
    ylim([-2 2])
    
    
    %Plot A1 vs A2
    figure(f2)
    subplot(1,2,gr)
    for cond = 1:2
        ci = ainds(cond,:); %Current indices
        plot(tred, x(ci), condStyles{cond}, 'Color',[0 0 0]),  hold on
        plot(tred, xf(ci),condStyles{cond},'Color','b'), hold on
        plot(tred, xs(ci),condStyles{cond},'Color','g'), hold on
    end
    if gr==1
        legend('x^{A1}','x_f^{A1}','x_s^{A1}',...
            'x^{A2}','x_f^{A2}','x_s^{A2}')
        ylabel('Adaptation')
    end
    ylim([0 1])
    title(gnames{gr});
    
    %Plot aftereffects
    figure(f3);
    subplot(1,2,gr)
    plot(x(aeind)), hold on
    plot(xf(aeind)), hold on
    plot(xs(aeind)), hold on
    plot(e(aeind)), hold on


    if gr==1
        legend('x','x_f','x_s','e');...
        ylabel('Adaptation')
    end
    
    title(gnames{gr});
    xlim([-2 152])
    ylim([-2 2])
        
end