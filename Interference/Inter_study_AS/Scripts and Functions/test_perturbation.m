clc
close all
clear all

load('I001params.mat')
slowSpeed=7*100;
fastSpeed=2*slowSpeed;
baselineSpeed=(slowSpeed+fastSpeed)/2;
deltaSpeed=fastSpeed-baselineSpeed;
m=1/(deltaSpeed);
adaptData = adaptData.addNewParameter('Perturbation',@(x)(m*(x-baselineSpeed)),{'singleStanceSpeedFastAbs'},'Perturbation');
adaptData = adaptData.addNewParameter('SLAadaptation',@(x,y)(x+y),{'Perturbation','stepLengthAsym'},'Perturbation + stepLengthAsym');

%Plots
adaptData.plotParamTimeCourse('SLAadaptation');
adaptData.plotParamTimeCourse('stepLengthAsym')
