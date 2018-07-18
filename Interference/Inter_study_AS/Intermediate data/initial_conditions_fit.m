SINGLE_EXP=1;
DOUBLE_EXP=2;
INCR_EXP=1;
my_exp =  @(c,t)(c(1)+c(2)*exp(-t/c(3)));
my_double_exp =  @(c,t)( c(1) + c(2)*exp(-t/c(3)) + c(4)*exp(-t/c(5))  );
my_line = @(c,t)(c(1)+c(2)*t);
x0=zeros(1,3);
if FIT_MODEL==SINGLE_EXP
    x0 = [1 -0.5 20]; %Initial parameters exponential fitting
    if (INCR_EXP) %1-exp(-a*t)
        lb = [-10^10,  -10^10,     1  ]; %Imposing that the time constant cannot be bigger than 200, we have estimates with smaller confidence intervals and significant differences between groups
        ub = [+10^10,     1,       10^10];
    else          %exp(-a*t)
        lb = [-10^10,         0,         1  ];
        ub = [+10^10,     10^10,       10^10];
    end
elseif FIT_MODEL==DOUBLE_EXP
%     x0 = [1 -0.5 20 -0.5 20]; same initial conditions as my_exp_fit2
    x0 = [-.5 -0.5 20 -0.5 20]; %Initial parameters exponential fitting
    if (INCR_EXP) %1-exp(-a*t)
        lb = [-10^10,  -10^10,           1,    -10^10,         1  ];
        ub = [+10^10,       0,       10^10,         0,       10^10];
    else          %exp(-a*t)
        lb = [-10^10,         0,         1,        0,         1  ];
        ub = [+10^10,     10^10,       10^10,  10^10,       10^10];
    end
    
end