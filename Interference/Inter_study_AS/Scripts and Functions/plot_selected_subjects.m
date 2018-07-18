%% Plot subject contribution + monofit

clc
close all
clear all

contr = {'SLA', 'ST', 'SP'};
ncontr=length(contr);
sgroup = [1 2];
sind = [8 2];
SS=15;
myGroupColors=[0.8500    0.3250    0.0980; 0    0.4470    0.7410]; %Interference, Savings
myStylesFit={'-','--'}; % A1 solid, A2 dashed
myStylesData={'o','*'};  % A1 circles, A2 squares
cPath = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\Stata - Rate Measures\';
ac=cell(1,ncontr); ac_smoothed=cell(1,ncontr);
for i=1:3
    ac{i} = load([cPath contr{i} '_smoothed.mat']);
end
%%
grStr = {'I','S'};

for sub=1:2
    gr = sgroup(sub);
    s =sind(sub);
    
    figure('Name',[grStr{gr} num2str(s) ' - All contributions'],'NumberTitle','off');
    for c=1:ncontr
        subplot(1,3,c)
        for cond=1:2
            %Extract data
            data = ac{c}.all_curves{gr,s,cond};
            %Extract fit
            sdata = ac{c}.all_curves_after_smoothing{gr,s,cond};
            
            %Plot
            indSS = 1:SS:length(data);
%             subplot_tight(ng, ns, sub + (gr-1)*ns,margins)
            hold on
            plot(indSS,data(indSS),[myStylesData{cond}],'Color',myGroupColors(gr,:),'LineWidth',1);
            hold on
            fitH = plot(sdata,'Color',myGroupColors(gr,:),'LineStyle',myStylesFit{cond},'LineWidth',3);
            xlim([0 600])
            uistack(fitH, 'top')
            hold on
          
        end
          xlabel('Strides')
            
            if c==1
                legend('Data A1','Sm A1','Data A2','Sm A2')
            end
            ylabel(contr{c});
    end
end


