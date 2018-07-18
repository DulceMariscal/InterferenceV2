%least_square  
function [SSresid, x1, x2] = two_state_lsq_noIC(k_ext,t,x_data,e)
% global a;
% global b;
% global c;
% y0(1) = 0; 
% modelfun=@(t,x)nmodel(t,x,a,b,c);
% [t ycalc]=ode45(two_state_fc,t,x0,);

%Initialize variables
ntrials=length(t);
x=zeros(1,ntrials);
x1=zeros(1,ntrials); 
x2=zeros(1,ntrials);

%Assign k_ext values to the proper variables
x1(1)=k_ext(1);
x2(1)=k_ext(2);
k=k_ext(3:end);

% [T,x_current_pars]=ode45(@(t,x)two_state_fc(t,x,k,e),t,x0);

for trial=1:ntrials-1
    xvec = two_state_fc([],[x1(trial); x2(trial)],k,e(trial));
    x1(trial+1)=xvec(1);
    x2(trial+1)=xvec(2);
    x(trial+1)=sum(xvec);
end



% figure,plot(t,x_mo);

% x_mo=sum(x_current_pars,2);
if any( size(x) ~=size(x_data)  )
    x=x';
end

SSresid = sum((x-x_data).^2);

% plot(mytime,mydata,'k');
% hold on
% plot(t,ycalc,'ro');
% hold off
% val = sum(sum(resid));

end