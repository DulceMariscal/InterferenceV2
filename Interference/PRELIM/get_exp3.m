function [tfit, dataFit]=get_exp2(inpars,T,nsamples,sp)
t0=T(1);
tend=T(end);

my_exp =  @(c,t)(c(1)+c(2)*exp(-t/c(3)));

a=inpars(2); %f(inf)
b=inpars(1)-a;
tau=inpars(3);
parameters=[a,b,tau];

dataFit=my_exp(parameters,[0:sp:nsamples]);
tfit=[t0:sp:tend];


end