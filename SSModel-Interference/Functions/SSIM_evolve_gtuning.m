function [z, e, X] = SSIM_evolve_gtuning(k, input , x0)
%This version weights the error with a gaussian function
ntrials = length(input);

% Parameters extraction
kcell = num2cell(k);
[af,bf,fpeak,fstd,as,bs,speak,sstd,aet,bet] = kcell{:};

%Initializations
z = zeros(1,ntrials);
xf = zeros(1,ntrials);
xs = zeros(1,ntrials);
xpe = zeros(1,ntrials); %
xne = zeros(1,ntrials); %
e = zeros(1,ntrials);

xf(1)  = x0(1);
xs(1)  = x0(2);
xpe(1) = x0(3);
xne(1) = x0(4);

%Evoulution
for n=1:ntrials-1
    % xf(n) = 0; %You just need to uncomment this in order t
    % xs(n) = 0
    z(n) = xf(n) + xs(n);
    e(n) = input(n) - z(n);        % Kinematic error previous step
    
    %% Reactive components update
    %     if n==2701
    %        disp('2701')
    %     end
    xf(n+1) = af*xf(n) + bf*e(n); % Error driven fast adaptation
    xs(n+1) = as*xs(n) + bs*e(n); % Error driven slow adaptation
    
    % Fast contextual tuning
    cfp = fpeak*normpdf(e(n), 1,fstd);
    cfn = fpeak*normpdf(e(n),-1,fstd);
    xf(n+1) = xf(n+1) + cfp*xpe(n) + cfn*xpe(n);
    
    % Slow contextual tuning
    csp = speak*normpdf(e(n),  1, sstd);
    csn = speak*normpdf(e(n), -1, sstd);
    xs(n+1) = xs(n+1) + csp*xpe(n) + csn*xpe(n);

    %% Primitives update (effect of practice)
    % 1. Decay
    xpe(n+1) = aet*xpe(n);
    xne(n+1) = aet*xne(n);
    
    % 2. Increase
    if e(n)>0
        xpe(n+1) = xpe(n+1) + bet*e(n);
    elseif e(n)<0
        xne(n+1) = xne(n+1) + bet*e(n);
    else
    end

    
    
end
z(end) = xs(end)   +   xf(end);
e(end) = input(end) -   z(end);

X = [xf; xs; xpe; xne];
end