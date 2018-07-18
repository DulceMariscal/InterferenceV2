function [tfit, dataFit]=get_exp2(pars,T,nsamples,sp)
t0=T(1);
tend=T(end);

my_exp =  @(c,t)(c(1)+c(2)*exp(-t/c(3)));
dataFit=my_exp(pars,[0:sp:nsamples]);
tfit=[t0:sp:tend];


end