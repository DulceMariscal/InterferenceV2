function [nos_to_mid_pert, dataFit, expFitPars] = find_nstrides_to_mid_pert(abrupt,incrORdecr)

%Fit single exp
[expFitPars, dataFit] = my_exp_fit(abrupt,incrORdecr,'Single'); %Alt choices: Decreasing, Double

%Compute par
thr_val=(nanmean(dataFit(1:5)) + nanmean(dataFit(end-45:end-5)))/2;
% thr_val=(dataFit(1) + dataFit(end))/2;

if strcmpi(incrORdecr,'Increasing')
     nos_to_mid_pert = find(dataFit >= thr_val, 1);
else
     nos_to_mid_pert = find(dataFit <= thr_val, 1);
     warning('SPecify incr or decr. Decr ihas been assumed')
end

end