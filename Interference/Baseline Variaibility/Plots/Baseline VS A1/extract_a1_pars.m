function [adaptPars, expFit, expFitPars]=extract_a1_pars(abrupt,incrORdecr)
%ystrings={'SLA_A1_1','SLA_A1_1to5','SLA_A1_6to30','SLA_A1_L30','stridesToAVGpert'};

adaptPars(1)=abrupt(1);
adaptPars(2)=nanmean(abrupt(1:5));
adaptPars(3)=nanmean(abrupt(6:30));
adaptPars(4)=nanmean(abrupt(end-30+1:end));
[adaptPars(5), expFit, expFitPars]=find_nstrides_to_mid_pert(abrupt,incrORdecr);

end
