%% Reproduce Malone 2011 Switch group usign the parameters fitted from the interference data

clc
close all
clear all

path = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\SSModel - Interference\Matrices\' ;
load([path 'FittedParameters.mat'])
load([path 'defaultColors.mat'])

%% Define the perturbations
grnames = {'Abrupt','Gradual','Gradual Washout','Extended Gradual','Short Abrupt'};
colors = [255 144 51; 0 0 0; 98 160 83; 101 172 230; 200 0 141]/255 ;

%Trials def
tied1m = zeros(1,60);
tied5m = zeros(1,60*5);
tied15m = zeros(1,60*15);

ab10s = ones(1,10);
ab5m = ones(1,60*5);
ab15m = ones(1,60*15);
counterab15m = -ab15m;

pertSwitch = [tied1m ab10s tied1m ab5m tied5m ab5m tied5m ab5m];


%% Simulate evolution
model=2; nstates = modParams(model).nstates; ng=1;
kmin =  modParams(model).kmin;
x0 = zeros(1,4);
for gr=1:ng
    [zs{gr}, es{gr}, Xs{gr}]= my_model_evolution(model, kmin, pertSwitch, x0);
end

%% Plot whole evolution
gray = [.5 .5 .5];
stLs = {':','--','-','-'};
stCols = [gray; gray; defaultColors(2,:); defaultColors(1,:)];

figure

%Perturbation
plot(pertSwitch,'ko'); hold on;

%Motor output
plot(zs{gr},'Color', gray)
hold on

% States
for state=1:nstates
    p = plot(Xs{gr}(state,:),stLs{state});
    p.Color = stCols(state,:);
end
axis tight

legend(['Pert', 'z', modParams(2).stNames])


%% Compare readaptations
figure
reInt = [131:131+299; 731:731+299; 1331:1331+299];
mcols = {'b','g','y'};
for int=1:3
    ci = reInt(int,:);
    plot(zs{gr}(1,ci),'Color',mcols{int}); hold on
end
legend('a1','a2','a3')
ylim([0.7 1])