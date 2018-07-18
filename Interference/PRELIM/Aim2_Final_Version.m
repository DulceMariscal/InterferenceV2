%% AIM 2 Final version
clc
close all
clear all

nsamples=300;
delta=0.7;
d2=delta/2;
sp=1;
m=[0.07 0.07];

% mcol=[0    0.4470    0.7410;    0.8500    0.3250    0.0980;    0.9290    0.6940    0.1250];
mcol=[0    0.4470    0.7410; [51, 153, 51]/256;  0.9290    0.6940    0.1250];
belt_colors=[[218,165,32]/256;   0.8500    0.3250    0.0980];
a = [1.05 1.05];
b=  [1.05 0.85];
z150=zeros(1,150);
a300=ones(1,300);
DAY2_PERT=[z150, a300]; n4=length(DAY2_PERT);
transl=0.01;
Break=1000;
taus=[67, 67*0.6
      67, 67*0.2]; %Study 2
names={'Naive_{AGNA}','Naive_{AGBNA}','AGNA','AGBNA'};
styles={'--','--','-','-'};

np=length(a);
figure
offs=[0 1];
PARADIGMS=cell(1,2);
DS=cell(1,2);
NDS=cell(1,2);
for i=1:np
    %% Single belts
    [D,ND] = get_profiles(a(i),b(i),d2,transl);
    DAY2_D=[a(i)*ones(1,150),  (a(i)+d2)*ones(1,300)]+0.01;
    DAY2_ND=[a(i)*ones(1,150), (a(i)-d2)*ones(1,300)]-0.01;
    
    %Plot perturbation---------------------------------------------------------
    subplot_tight(2,2,i + offs(i),m)
    PARADIGMS{i}=(D - 2*transl - ND)/delta;
    DS{i}=D;
    NDS{i}=ND;
    plot(PARADIGMS{i},'ks');
    ylPert(i)=ylabel('Perturbation');
    hold on
    nend=length(D);
    startDay2=nend+Break+1;
    v1=startDay2+1:startDay2+n4;
    hday2(i)=plot(v1,DAY2_PERT,'ks');
    
    grid on
    if i==2
        xl(1)=xlabel('Strides');
    end
    %Plot Adaptation curves
    pars=[0, 1, taus(i,1)];
    [tfit, dataFit]=get_exp3(pars,[150 150+nsamples],nsamples,sp);
    hold on
    plot(tfit,dataFit,'LineStyle',styles{i},'LineWidth',2,'Color',mcol(i,:));
    
    %Plot re-adaptation curves
    pars=[0, 1, taus(i,2)];
    [tfit, dataFit]=get_exp3(pars,[6550 6550+nsamples],nsamples,sp);
    hold on
    plot(tfit,dataFit,'LineStyle',styles{i+2},'LineWidth',2,'Color',mcol(i,:));
    
    %Plot speeds---------------------------------------------------------------
    subplot_tight(2,2,i + offs(i)+1,m)
    plot(D,'s','Color',belt_colors(1,:));
    hold on
    plot(ND,'s','Color',belt_colors(2,:));
    hold on
    plot(v1,DAY2_D,'s','Color', belt_colors(1,:));
    hold on
    plot(v1,DAY2_ND,'s','Color',belt_colors(2,:));
    
    ylSpeeds(i)=ylabel('Belt Speed [m/s]');
    grid on
    if i==1
        l(1)=legend('Dominant','Non-dominant');
    end
    if i==2
        xl(2)=xlabel('Strides');
    end
    
    ylim([0.4 1.6])
    %
    % DAY2=[z150, a300]; n4=length(DAY2);
    % Break=1000;
    % hold on
end


%% CHANGE COLORS

%GROUP 1
subplot_tight(2,2,1,m);
G1=PARADIGMS{1};
ind1=find(G1>=1-eps);
n1=length(G1);
vec=1:n1;
pl1=plot(vec(ind1),G1(ind1),'s','Color',mcol(1,:));
ll(1)=legend('Perturbation','Perturbation', 'Day-1 Adaptation', 'Day-2 Adaptation','Errors @ Normal Speed');


%GROUP 2
subplot_tight(2,2,3,m);
%Find slow spees
G2=PARADIGMS{2};
D=DS{2};
ND=NDS{2};
ind1=find(ND==0.49 & D==1.21 );
n1=length(G2);
vec=1:n1;

% %Find normal speed
ind2=setdiff(find(G2>1-eps),ind1);
% ind2=find(ND<=0.69 & D>=1.41 );
n1=length(G2);
vec=1:n1;
plot(vec(ind2),G2(ind2),'s','Color',mcol(1,:));
plot(vec(ind1),G2(ind1),'s','Color',mcol(2,:));

ll(2)=legend('Perturbation','Perturbation', 'Day-1 Adaptation', 'Day-2 Adaptation','Errors @ Normal Speed','Errors @ Slow Speed');

% l(5)=legend(pl2,'Perturbation', 'Day-1 Adaptation', 'Day-2 Adaptation','Env-Ind Errors','Self-Ind Errors');

mySetFontSize([xl, l, ll, ylPert ylSpeeds], 18);

