function [z, e, X]= SM2006_evolve(params, pert , x0)

ntrials = length(pert);

% Parameters extraction
kcell = num2cell(params);
[af,bf,as,bs] = kcell{:};

%Initializations
z = zeros(1,ntrials);
xf = zeros(1,ntrials); 
xs = zeros(1,ntrials);
e = zeros(1,ntrials);

xf(1) = x0(1);
xs(1) = x0(2);

%Evoulution
for n=1:ntrials-1    
    z(n) = xf(n) + xs(n);
    e(n) = pert(n) - z(n);        % Kinematic error previous step
    xf(n+1) = af*xf(n) + bf*e(n); % Error driven fast adaptation
    xs(n+1) = as*xs(n) + bs*e(n); % Error driven slow adaptation
end
z(end) = xs(end)   + xf(end);
e(end) = pert(end) - z(end); 

X = [xf; xs];
end 