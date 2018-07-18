%% STATISTICAL ANALYSIS
clc
close all
clear all

genFold='C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Interf_study_AS\';
compFold=[genFold 'Intermediate data\REGRESSORS'];

load(compFold);
ns=size(REGRESSORS,1);

recall_pv=REGRESSORS(:,end);
X=REGRESSORS(:,1:end-1);

X(:,end) = X(:,end)==2; %In this way savings group is the baseline group
y=recall_pv;

% X=[ones(ns,1) X];%Add the constant term
%[b,bint,r,rint,stats] = regress(y,X);
[b,dev,st] = glmfit(X,y); %No need to add a column of ones
%[b] are the regression coefficients

%[dev] is the deviance, a generalized version of sum of squares, normalized
%by number of parameters. You can compare the deviance of different models
%with different number of parameters

%[st.p] contains the p values of each coefficient