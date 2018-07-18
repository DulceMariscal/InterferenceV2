function [z, e, X, Xadd] = SSIM_evolve_lisu(k, input , x0) 
%% Model with facilitation and interference not proportional to the error in the slow state
% Possible future edits:
%   1. Add the possibility of interference also in the fast state.
%       Hopefully the coefficients for the fast state will be very low
%   2. Fix the problems with the aftereffects. They are bigger for the
%   savings groups compared to the interference group
ntrials = length(input);

% Parameters extraction
kcell = num2cell(k);
[af,bf,bfet,as,bs,bset,bsint,aet,bet] = kcell{:};

%Initializations
z = zeros(1,ntrials);
xf = zeros(1,ntrials);
xs = zeros(1,ntrials);
xpe = zeros(1,ntrials);
xne = zeros(1,ntrials); 
e = zeros(1,ntrials);
xfastActivation = zeros(1,ntrials);
xslowActivation = zeros(1,ntrials);
em = 0;

xf(1)  = x0(1);
xs(1)  = x0(2);
xpe(1) = x0(3);
xne(1) = x0(4);

%Evoulution
for n=1:ntrials-1
    
    %% Motor output determination    
        z(n) = xf(n) + xs(n) + xfastActivation(n) + xslowActivation(n);
    
    %% Error computation
        e(n) = input(n) - z(n);        % Kinematic error previous step
        em   = abs(e(n));
    
    %% States update
        %% Reactive components update
        xf(n+1) = af*xf(n) + bf*e(n); % Error driven fast adaptation
        xs(n+1) = as*xs(n) + bs*e(n); % Error driven slow adaptation
        
    %% Activation of motor primitives for the next step
        if e(n)>0
            xfastActivation(n+1) = bfet*xpe(n);
            xslowActivation(n+1) = bset*xpe(n)     +    bsint*xne(n) ;
        else
            xfastActivation(n+1) = bfet*xne(n);
            xslowActivation(n+1) = bset*xne(n)     +    bsint*xpe(n) ;
        end

    %% Primitives update 
        % 1. Decay
        xpe(n+1) = aet*xpe(n);
        xne(n+1) = aet*xne(n);

     % 2. Learning
        if e(n)>0
            xpe(n+1) = min([xpe(n+1) + bet*e(n), 1]);
        elseif e(n)<0
            xne(n+1) = max([xne(n+1) + bet*e(n), -1]);
        else
        end
end
z(end) = xs(end)   +   xf(end);
e(end) = input(end) -   z(end);

X = [xf; xs; xpe; xne];
Xadd = [xfastActivation; xslowActivation]; %These are not really states

end