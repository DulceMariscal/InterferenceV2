clc
close all
clear all

ppath='C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\';
load([ppath 'ALL_DATA' ])
GROUPS={'INT','SAV'};
CONDS={'A1','A2'};
MERGED_DATA=cat(3,INTERFERENCE_DATA,SAVINGS_DATA);
MERGED_DATA_FIT=cat(3,INTERFERENCE_FIT_DATA(:,:,1),SAVINGS_FIT_DATA(:,:,1)); %In sec dim there is dfit/dt

myColors2=[0.8500    0.3250    0.0980; 0    0.4470    0.7410]; %Interference, Savings
myColors=[0 0 0; 0 0 0]; %Interference, Savings
myStylesFit={'-','--'}; % A1 solid, A2 dashed
myStylesData={'o','*'};  % A1 circles, A2 squares
% INTERFERENCE=1;
% SAAVINGS=2;
SS=15;
margins=[0.05 0.03];
names={'I','S'};
%%
f=figure;
subplot_offset=0;
ca_offset=0;

for group=1:2
    if group==2
        subplot_offset=8;
    end
    
    for sub=1:nos(group)
        ind_subplot=subplot_offset + sub;
        
        %EXTRACT AND STORE SINGLE CONDITION RESULTS------------------------
        for cond=1:2
            cdata=MERGED_DATA{cond,sub,group};
            cdata_fit=MERGED_DATA_FIT{cond,sub,group};
            
            indSS=1:SS:length(cdata); %indices subsampling
            
            subplot_tight(2,8,ind_subplot,margins)
            hold on
            plot(indSS,cdata(indSS),[myStylesData{cond}],'Color',myColors(group,:))
            hold on
            %Find limits fot line plot
            if cond==1
                Y_MIN=min(cdata(1:10));
            elseif cond==2
                Y_MAX=max(cdata(end-10-1:end));
            end
            
            
            fitH=plot(cdata_fit,'Color',myColors(group,:),'LineStyle',myStylesFit{cond},'LineWidth',3);
            uistack(fitH, 'top')
        end
        
        %Plot lines
         min1= min(MERGED_DATA{1,sub,group});
         min2= min(MERGED_DATA{2,sub,group});
         max1= max(MERGED_DATA{1,sub,group});
         max2= max(MERGED_DATA{2,sub,group});
         Y_MIN=min(min1,min2); Y_MAX=max(max1,max2);
         
        for cond=1:2
            nstr=PARAMETERS_ALL{group}(cond,STRIDES_TO_HALVE,sub);
            h3=line([nstr nstr],[Y_MIN Y_MAX],'LineWidth',2,'Color',myColors2(group,:),'LineStyle',myStylesFit{cond});
        end
        ylim([Y_MIN Y_MAX])
        
        title(['SUBJ = ' names{group} num2str(sub)])
        if subplot_offset==8
            xl(sub)=xlabel('Strides');
        end
        if sub==1
            yl(group)=ylabel('Step Length Asymmetry');
        end
    end
    
    legend('Data A1','Fit A1','Data A2','Fit A2','#strides A1','#strides A2');
end

% l=legend([h1 h2 h4 h3],{'Data','Exp fit','Mid-Pert','#strides to Mid-Pert'});

% %%
% isub=6;
% nstr=PARAMETERS_ALL{SAVINGS}(1,STRIDES_TO_HALVE,isub);
% YLIM=[-0.2 0.1];
% XLIM=[0 600];
%
%
% a1data=SAVINGS_DATA{1,isub};
% a2data=SAVINGS_DATA{2,isub};
% a1fit=SAVINGS_FIT_DATA{1,isub};
% a2fit=SAVINGS_FIT_DATA{2,isub};
%
%
% a1vec=1:length(a1data);
% a1vecf=1:length(a1fit);
%
% indData=1:5:length(a1data);
%
% figure
% h1=plot(a1vec(indData),a1data(indData),'o');
% hold on
% h2=plot(a1fit,'LineWidth',2,'Color',[         0    0.4470    0.7410]);
% hold on
% h3=line([nstr nstr],YLIM,'LineWidth',2,'LineStyle','--');
%
% hold on
% line(XLIM,[a1fit(1) a1fit(1)],'Color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle','--')
% hold on
% line(XLIM,[a1fit(end) a1fit(end)],'Color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle','--')
% hold on
% avgp=(a1fit(1)+a1fit(end))/2;
% h4=line(XLIM,[avgp avgp],'Color',[0 0 0],'LineWidth',2,'LineStyle','--')
%
%
% ylim(YLIM); grid on;
% l=legend([h1 h2 h4 h3],{'Data','Exp fit','Mid-Pert','#strides to Mid-Pert'});
% yl=ylabel('Step Length Asymmetry');
% xl=xlabel('Strides');
% set(l,'FontSize',16);

mySetFontSize(xl,14);
mySetFontSize(yl,16);


