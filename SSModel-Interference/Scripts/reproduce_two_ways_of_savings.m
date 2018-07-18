%% Reproduce Two ways of savings usign the parameters fitted from the interference data

clc
% close all
clear all

path = 'C:\Users\salat\OneDrive\Research\Code\SSModel - Interference\Matrices\' ;
model = 7; 

load([path 'FittedParameters_v3.mat'])
kmin =  modParams(model).kmin;

load([path 'defaultColors.mat'])
pathToData = 'C:\Users\salat\OneDrive\Research\Code\!!! Data Prep For Fitting !!!';
load([pathToData '\Data\DataForFitting.mat'])

%% Define the perturbations
grnames = {'Abrupt','Gradual','Gradual Washout','Extended Gradual','Short Abrupt'};
colors = [255 144 51; 0 0 0; 98 160 83; 101 172 230; 200 0 141]/255 ;

%Trials def
bas = zeros(1,120);
rampup = linspace(0,1,600);
rampdown = linspace(1,0,600);
p1 = ones(1,600);
p1short = ones(1,120);
wo = zeros(1,600);

%Groups def
abrupt = [bas p1 wo p1];
gradual = [bas rampup wo p1];
grWo = [bas p1 rampdown p1];
extGr = [bas rampup p1 wo p1];
shAb = [bas p1short wo p1];
perts = {abrupt; gradual; grWo; extGr; shAb};
ng=size(perts,1);
maxl = 2520;

%Plot groups
f1 = figure;
for gr=1:ng
    subplot(ng,1,gr)
    plot(perts{gr},'o','Color',colors(gr,:));
    legend(grnames{gr})
    axis tight
end

%% Initializations
zs = cell(1,ng);
es = cell(1,ng);
Xs = cell(1,ng);

%% Simulate evolution

nstates = 4;
x0 = zeros(1,4);
for gr=1:ng
    [zs{gr}, es{gr}, Xs{gr}]= my_model_evolution(model, kmin, perts{gr}, x0, basStd);
end

%% Plot states evolutions
f2 = figure('Name','States Evolution','NumberTitle','off');
stNames = modParams(model).stNames; %{'x^{f}','x^{s}','x^{pe}','x^{ne}'};
gray = [.5 .5 .5];
stLs = {':','--','-','-'};
stCols = [gray; gray; defaultColors(2,:); defaultColors(1,:)];
for gr=1:ng
    subplot(ng,1,gr)
    
    % Perturbation
    plot(perts{gr},'o','Color',colors(gr,:)); hold on
    
    % Motor output
    plot(zs{gr},'Color',gray); hold on;
    
    % States
    for state=1:nstates
        p = plot(Xs{gr}(state,:),stLs{state});
        p.Color = stCols(state,:);
    end
    ylim([-0.6 1.1])
    xlim([0 maxl])
    if gr==1
        legend(['Pert','z',stNames])
    end
    
    if gr ~=ng
        ax = gca();
        ax.XTickLabel = [];
    else
        xlabel('Strides')
    end
end

%% Compare behaviour during the second adaptation
f3 = figure('Name','Readaptation behavior','NumberTitle','off');

for gr=1:ng
    plot(zs{gr}(end-600+1:end),'-','Color',colors(gr,:)); hold on;
end
plot(zs{1}(121:121+600),'Color','r') %Naive adaptation    
legend([grnames 'Naive'])
ylim([0.8 1])
xlim([0 600])

