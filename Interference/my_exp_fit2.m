function [coeffs, dataFit, resid, J]=my_exp_fit2(dataToFit,incrORdecr,modelToFit) %Alt choices: Decreasing, Double
%% Make column vector
dims=size(dataToFit);
if dims(2)<dims(1)
    dataToFit=dataToFit';
end

%% DEFINE POSSIBLE FUNCTIONS TO FIT
my_exp =  @(c,t)(c(1)+c(2)*exp(-t/c(3)));
my_double_exp =  @(c,t)( c(1) + c(2)*exp(-t/c(3)) + c(4)*exp(-t/c(5))  );
my_line = @(c,t)(c(1)+c(2)*t);
x0=zeros(1,3);
indnan=isnan(dataToFit);
vec=1:length(dataToFit);

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
    x0 = [1 -0.5 20]; %Initial parameters exponential fitting
%     if (INCR_EXP) %1-exp(-a*t)
%         lb = [-10^10,  -10^10,     1  ]; %Imposing that the time constant cannot be bigger than 200, we have estimates with smaller confidence intervals and significant differences between groups
%         ub = [+10^10,     0,       10^10];
%     else          %exp(-a*t)
%         lb = [-10^10,         0,         1  ];
%         ub = [+10^10,     10^10,       10^10];
%     end
    %% FIT
    [coeffs,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,vec(~indnan),dataToFit(~indnan));
    dataFit=my_exp(coeffs,vec);
    
elseif strcmpi(modelToFit,'Double')
    x0 = [-0.5 -0.5 20 -0.5 20]; %Initial parameters exponential fitting
%     if (INCR_EXP) %1-exp(-a*t)
%         lb = [-10^10,  -10^10,           0,    -10^10,         0  ];
%         ub = [+10^10,  +10^10,       10^10,    +10^10,       10^10];
%     else          %exp(-a*t)
%         lb = [-10^10,         0,         1,        0,         1  ];
%         ub = [+10^10,     10^10,       10^10,  10^10,       10^10];
%     end
    %% FIT
    [coeffs,~,resid,~,~,~,J] = lsqcurvefit(my_double_exp,x0,vec(~indnan),dataToFit(~indnan));
    dataFit=my_double_exp(coeffs,vec);
elseif  strcmpi(modelToFit,'Line')
    [coeffs,~,resid,~,~,~,J] = lsqcurvefit(my_line,[0 0],vec(~indnan),dataToFit(~indnan));
    dataFit=my_line(coeffs,vec);
end




end