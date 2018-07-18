function [coeffs, dataFit, resid, J] =...
    my_exp_fit_constr(dataToFit,incrORdecr,modelToFit,Y0)
%Alt choices: Decreasing, Double
%This version constraints the exponential to start from y0.
%TODO, make it work for 2 exponentials

%% Make column vector
dims=size(dataToFit);
if dims(2)<dims(1)
    dataToFit=dataToFit';
end

%% DEFINE POSSIBLE FUNCTIONS TO FIT
my_exp =  @(c,t)(Y0 + c(1)*(exp(-t/c(2))-1));
my_double_exp =  @(c,t)( Y0 + c(1)*(exp(-t/c(2))-1) + c(3)*(exp(-t/c(4))-1) );

indnan=isnan(dataToFit);
vec=0:(length(dataToFit)-1);

%% SET PARAMETERS FOR FITTING
if strcmpi(incrORdecr,'Increasing')
    INCR_EXP=1;
elseif strcmpi(incrORdecr,'Decreasing')
    INCR_EXP=0;
else
    warning('Specify whether increasing or decreasing exp. Increasing is assumed')
    INCR_EXP=1;
end

if strcmpi(modelToFit,'Single')
    x0 = [-0.5 20]; %Initial parameters exponential fitting
    if (INCR_EXP) %1-|b|*exp(-a*t)
        lb = [-10^10,     1  ]; %Imposing that the time constant cannot be bigger than 200, we have estimates with smaller confidence intervals and significant differences between groups
        ub = [ 0,       10^10];
    else          %|b|*exp(-a*t)
        lb =  [      0,         1  ];
        ub = [    10^10,       10^10];
    end
    
    %% CHANGE BOUNDS AND INITIAL CONDITIONS ACCORDING TO THE INPUT VALUES
    [coeffs,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,vec(~indnan),dataToFit(~indnan),lb,ub);
    dataFit = my_exp(coeffs,vec);
    
elseif strcmpi(modelToFit,'Double')
    x0 = [-0.5 20 -0.5 20]; %Initial parameters exponential fitting
    if (INCR_EXP) %1-exp(-a*t)
        lb = [ -10^10,           1,        -10^10,         1];
        ub = [ 10^10,       10^10,         10^10,       10^10];
    else          %exp(-a*t)
        lb = [-10^10,         1,   -10^10,         1  ];
        ub = [10^10,       10^10,  10^10,       10^10];
    end
    %% FIT
    [coeffs,~,resid,~,~,~,J] = lsqcurvefit(my_double_exp,x0,vec(~indnan),dataToFit(~indnan),lb,ub);
    dataFit=my_double_exp(coeffs,vec);
elseif  strcmpi(modelToFit,'Line')
    [coeffs,~,resid,~,~,~,J] = lsqcurvefit(my_line,[0 0],vec(~indnan),dataToFit(~indnan));
    dataFit=my_line(coeffs,vec);
end




end




