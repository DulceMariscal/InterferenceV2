function [x, e, xf, xs]= two_state_evolve(params, pert , x0)

ntrials = length(pert);

% Parameters extraction
kcell = num2cell(params);
[af,bf,as,bs] = kcell{:};

%Initializations
x = zeros(1,ntrials);
xf = zeros(1,ntrials); 
xs = zeros(1,ntrials);
e = zeros(1,ntrials);

xf(1) = x0(1);
xs(1) = x0(2);

%Evoulution
for n=1:ntrials-1    
    x(n) = xf(n) + xs(n);
    e(n) = pert(n) - x(n);        % Kinematic error previous step
    xf(n+1) = af*xf(n) + bf*e(n); % Error driven fast adaptation
    xs(n+1) = as*xs(n) + bs*e(n); % Error driven slow adaptation
end
x(end) = xs(end)   + xf(end);
e(end) = pert(end) - x(end); 

end 