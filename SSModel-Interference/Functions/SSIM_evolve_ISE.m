function [z, e, X] = SSIM_evolve_ISE(k, input , x0, sigmaNE)
% This is the FIRST version in the presentation
% Possible future edits:
%   1. Add the possibility of interference also in the fast state.
%       Hopefully the coefficients for the fast state will be very low
%   2. Fix the problems with the aftereffects. They are bigger for the
%   savings groups compared to the interference group
ntrials = length(input);

% Parameters extraction
kcell = num2cell(k);
[af,bf,bfet,as,bs,bset,bsint,aet,bet] = kcell{:};
nSTD = 5;

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
    em   = abs(e(n));
    
    %% Reactive components update
    %     if n==2701
    %        disp('2701')
    %     end
    xf(n+1) = af*xf(n) + bf*e(n); % Error driven fast adaptation
    xs(n+1) = as*xs(n) + bs*e(n); % Error driven slow adaptation
    
    % Fast contextual tuning
    if e(n)>0
        xf(n+1) = xf(n+1) + bfet*xpe(n)*em;
    elseif e(n)<0
        xf(n+1) = xf(n+1) + bfet*xne(n)*em;
    else
    end
    
    % Slow contextual tuning
    if e(n)>0
        xs(n+1) = xs(n+1) + bset*xpe(n)*em + bsint*xne(n)*em;
    elseif e(n)<0
        xs(n+1) = xs(n+1) + bset*xne(n)*em + bsint*xpe(n)*em;
    else
    end
    
    %% Primitives update (effect of practice)
    % 1. Decay
    xpe(n+1) = aet*xpe(n);
    xne(n+1) = aet*xne(n);
    
    % 2. Update
    if em > nSTD*sigmaNE;
        if e(n)>0
            xpe(n+1) = xpe(n+1) + bet*e(n);
        elseif e(n)<0
            xne(n+1) = xne(n+1) + bet*e(n);
        else
        end
    end
    
    
end
z(end) = xs(end)   +   xf(end);
e(end) = input(end) -   z(end);

X = [xf; xs; xpe; xne];
end