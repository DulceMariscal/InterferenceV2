function [cdata,indnan,strideVec]=fixI008(cdata,initialPertI008_A1_alt,LOST_STRIDES_S8,INCR_EXP)
cdata=[nan(LOST_STRIDES_S8,1); cdata]';
cdata(1)=initialPertI008_A1_alt;
strideVec=1:length(cdata);
indnan=isnan(cdata);
my_exp =  @(c,t)(c(1)+c(2)*exp(-t/c(3)));
x0 = [1 -0.5 20]; %Initial parameters exponential fitting
if (INCR_EXP) %1-exp(-a*t)
    lb = [-10^10,  -10^10,     1  ]; %Imposing that the time constant cannot be bigger than 200, we have estimates with smaller confidence intervals and significant differences between groups
    ub = [+10^10,     0,       10^10];
else          %exp(-a*t)
    lb = [-10^10,         0,         1  ];
    ub = [+10^10,     10^10,       10^10];
end

[coeffs,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,strideVec(~indnan),cdata(~indnan),lb,ub);

completeFit=my_exp(coeffs,strideVec);
cdata(1:LOST_STRIDES_S8)=completeFit(1:LOST_STRIDES_S8);
indnan=isnan(cdata);


end


