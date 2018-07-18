function             [smoothedCurve, originalCurve, R2adj, R2, RMSE] = my_smoothing(originalCurve, SEL_SM)

Y0= originalCurve(1);

if strcmpi(SEL_SM,'1_EXP')
    [~, smoothedCurve] = my_exp_fit(originalCurve,'Increasing','Single');
    npars = 3;
    
elseif strcmpi(SEL_SM,'MONOTONIC_FIT')
    smoothedCurve = my_monoLS(originalCurve,2,2);
    npars = length(originalCurve)-1;
    
elseif strcmpi(SEL_SM,'C_AVG')
    interpData = nan_interp(originalCurve,[]);
    smoothedCurve = compute_trend(interpData,[]);
    npars = length(originalCurve)-1;
    
elseif strcmpi(SEL_SM,'1_EXP_CONSTR')
    [~, smoothedCurve] = my_exp_fit_constr(originalCurve,'Increasing','Single',Y0);
    npars = 2;

elseif strcmpi(SEL_SM,'2_EXP')
    [~, smoothedCurve] = my_exp_fit(originalCurve,'Increasing','Double');
    npars = 5;

elseif strcmpi(SEL_SM,'2_EXP_CONSTR')
    [~, smoothedCurve] = my_exp_fit_constr(originalCurve,'Increasing','Double',Y0);
    npars = 4;
else
    smoothedCurve = originalCurve;
    warning('***No smoothing has been performed***')
end

R2adj = my_compute_R2adj(smoothedCurve,originalCurve, npars);
[R2, RMSE] = rsquare(originalCurve,smoothedCurve);


end