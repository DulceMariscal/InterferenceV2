%least_square  
function SSresid=two_state_lsq(k,t,x_data,x0,e)
% global a;
% global b;
% global c;
% y0(1) = 0; 
% modelfun=@(t,x)nmodel(t,x,a,b,c);
% [t ycalc]=ode45(two_state_fc,t,x0,);
ntrials=length(t);

x=zeros(1,ntrials);
x1=zeros(1,ntrials); 
x2=zeros(1,ntrials);

x1(1)=x0(1);
x2(1)=x0(2);

% [T,x_current_pars]=ode45(@(t,x)two_state_fc(t,x,k,e),t,x0);

for trial=1:ntrials-1
    xvec = two_state_fc([],[x1(trial); x2(trial)],k,e(trial));
    x1(trial+1)=xvec(1);
    x2(trial+1)=xvec(2);
    x(trial+1)=sum(xvec);
end



% figure,plot(t,x_mo);

% x_mo=sum(x_current_pars,2);
SSresid = sum((x-x_data).^2);

% plot(mytime,mydata,'k');
% hold on
% plot(t,ycalc,'ro');
% hold off
% val = sum(sum(resid));

end