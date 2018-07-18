%% PLOT OF PROTOCOLS FOR "GENERALIZATION OF TWO WAYS" PROJECT

clc
close all
clear all

baseline=zeros(1,150);
b=-1*ones(1,600);
b_short=-1*ones(1,120);
grad_bn=linspace(-1,0,600);
grad_nb=linspace(0,-1,600);
a=ones(1,600);
mcol=[0.5 0.5 0.5 ;0    0.4470    0.7410;    0.8500    0.3250    0.0980;    0.9290    0.6940    0.1250];


names={'Naive','Abrupt', 'Gradual + Repetition', 'Abrupt + Repetition'};
NAIVE=zeros(1,2100);
ABR=[baseline b_short grad_bn baseline zeros(1,1080)];
GREP=[baseline grad_nb b grad_bn baseline];
ABR_REP=[baseline b grad_bn baseline zeros(1,600)];
GROUP=[NAIVE; ABR; GREP; ABR_REP];
figure
for i=1:4
    
    subplot(4,1,i)
    plot(GROUP(i,:),'s','Color',mcol(i,:))
    grid on
    l(i)=legend(names{i})
    yl(i)=ylabel('Perturbation');
    if i==4
        xl=xlabel('Strides');
    end
    axis tight
    set(gca,'FontSize',18)
end


% subplot(3,1,2)
% plot(GREP,'s','Color',mcol(2,:))
% grid on
%
% subplot(3,1,3)
% plot(ABR_REP,'s','Color',mcol(3,:))
% grid on

f=figure
test=[zeros(1,150) ones(1,600), zeros(1,150)];
plot(test,'sk')
xl(2)=xlabel('Strides');
yl(4)=ylabel('Perturbation');
grid on
l(4)=legend('Test');
set(gca,'FontSize',18)

mySetFontSize([xl, l, yl], 18);

