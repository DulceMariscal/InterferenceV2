function dataFit=get_exp(myt,myval,st)
ssval=myval(end);

% myt=[150,300,750]; %t0    t/2    tend
% myval=[0, 0.5, 1]; %f(t0) f(t/2) f(ss)

my_exp =  @(c,t)(c(1)+c(2)*exp(-t/c(3)));
x0=[ssval 0 1];
lb = [-inf,  -10^10,     1  ]; %Imposing that the time constant cannot be bigger than 200, we have estimates with smaller confidence intervals and significant differences between groups
ub = [inf,     0,       10^10];
vec=myt(1:3);
data=myval(1:3);

[coeffs,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,vec,data,lb,ub);
fullvec=[myt(1):st:myt(end)];
dataFit=my_exp(coeffs,fullvec);


end