clc 
close all
clear all

path = ['C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\Intermediate data\'];
completeLoadPath = [path 'all_curves_cross_normalization.mat'];
load(completeLoadPath);

storePath ='C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\Intermediate data' ;
completeStorePath = [storePath '\PROCESSED_DATA_cross_normalized.mat' ];

INTERFERENCE_DATA = squeeze(all_curves_crossnorm(1,:,:))';
SAVINGS_DATA = squeeze(all_curves_crossnorm(2,:,:))';

save(completeStorePath, 'INTERFERENCE_DATA', 'SAVINGS_DATA' );

