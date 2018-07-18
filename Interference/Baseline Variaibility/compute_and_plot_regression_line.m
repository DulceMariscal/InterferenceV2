function    compute_and_plot_regression_line(x,y,varargin)
xstr =varargin{1};
ystr =varargin{2};

%TODO GENERALIZE TO THE CASE OF MULTIPLE REGRESSORS

% y has to be n-by-1 
dimy=size(y); 
if dimy(2)>dimy(1)
   y=y'; 
end

% X has to be n-by-p
dimx=size(x); 
if dimx(2)>dimy(1)
   x=x'; 
end 

% Main
hold on
scatter(x,y)
X=[ones(size(x)) x];

b1=regress(y,X);
ypred = b1(1) + b1(2)*(x); 
hold on
plot(x, ypred )

[rs,ps] = corrcoef(x,y);

resid = y-ypred;
npars = 2;
R2 = rsquared(y,resid,npars,0, 0); %Unadjusted, Uncentered.

r=rs(1,2);
p=ps(1,2);

if p>0.05
    legend(['\rho = ' num2str(r,'%.3f') ' p = ' num2str(p,'%.3f') ' R^2 = ' num2str(R2,'%.3f')])
else
    legend(['\rho = ' num2str(r,'%.3f') ' *p = ' num2str(p,'%.3f') ' R^2 = ' num2str(R2,'%.3f')])
end

xlabel(xstr);
ylabel(ystr);

end