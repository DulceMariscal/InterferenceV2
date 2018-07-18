function                 [nstrides_trend, ytrend] = find_nstrides_trend(y,interpolation_mode,FIRST_SAMPLES,steady_state_val,ss_perc,INCR_EXP,ncons,LAST_STRIDES)

%Interpolate nan values
y_int=nan_interp(y,interpolation_mode);

%Compute trend signal
ytrend = compute_trend(y_int,FIRST_SAMPLES);

%Compute steady state value (User can either define the number of strides from which to compute the ssval, or provide it)
if isempty(steady_state_val)
    steady_state_val=mean(ytrend(end-LAST_STRIDES + 1:end));
end

%Compute nstrides
nstrides_trend=find_nstrides_to_perc_ss(ytrend,steady_state_val,ss_perc,INCR_EXP,ncons);

end