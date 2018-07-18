%% TEST STEPWISE
clc
close all
clear all

load hospital 
mdl = stepwiselm(hospital,'Weight~1+Smoker',...
'ResponseVar','Weight','PredictorVars',{'Sex','Age','Smoker'},...
'CategoricalVar',{'Sex','Smoker'});
