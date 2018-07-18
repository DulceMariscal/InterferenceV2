function [dataFit, bestCoeff, bestR2adj, bestCi, nameBestModel, r2adj] = my_best_fit(x,y,indnan)

nmodels=3;
my_exp =  @(c,t)(c(1)+c(2)*exp(-t/c(3)));
my_double_exp =  @(c,t)( c(1) + c(2)*exp(-t/c(3)) + c(4)*exp(-t/c(5))  );
my_line = @(c,t)(c(1)+c(2)*t);
models={my_line,my_exp,my_double_exp};
model_names={'Line','Single Exp','Double Exp'};
X0={[0 0],[1 -0.5 20], [1 -0.5 20 -0.5 20] };
ADJ=1;
r2adj=zeros(1,nmodels);
coefficients=cell(1,nmodels);
residuals=cell(1,nmodels);
Js=cell(1,nmodels);

for i=1:nmodels
    %Fit
    cmodel=models{i};
    x0=X0{i};
    npars=length(x0);

    [coefficients{i},~,residuals{i},~,~,~,Js{i}] = lsqcurvefit(cmodel,x0,x(~indnan),y(~indnan));
    r2adj(i)=rsquared(y(~indnan),residuals{i},npars,ADJ);
    
% figure, plot(x,y,'o',x,cmodel(coeffs,x),'LineWidth',2)
end



%Return best fit data
bestR2adj=max(r2adj);
indBest=find(r2adj==bestR2adj);
nameBestModel=model_names{indBest};
bestModel=models{indBest};
bestCoeff=coefficients{indBest};
dataFit=bestModel(bestCoeff,x);
bestCi = nlparci(bestCoeff,residuals{indBest},'jacobian',Js{indBest}); %Confidence intervals of the parameters of the best model

end