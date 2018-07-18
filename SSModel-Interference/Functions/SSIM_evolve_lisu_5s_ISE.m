function [z, e, X, Xadd] = SSIM_evolve_lisu_5s_ISE(k, input , x0, sigmaNE, maxPA)
%% Model with facilitation and interference not proportional to the error in the slow state
% Possible future edits:
%   1. Add the possibility of interference also in the fast state.
%       Hopefully the coefficients for the fast state will be very low
%   2. Fix the problems with the aftereffects. They are bigger for the
%   savings groups compared to the interference group
ntrials = length(input);

% Parameters extraction
kcell = num2cell(k);
[ab,bb,af,bfet,as,bset,bsint,aet,bet,nSTD] = kcell{:};

%Initializations
z = zeros(1,ntrials);
xb = zeros(1,ntrials);
xpe = zeros(1,ntrials);
xne = zeros(1,ntrials);
e = zeros(1,ntrials);
xfa = zeros(1,ntrials);
xsa = zeros(1,ntrials);
Pw = zeros(1,ntrials);
em = 0;

xb(1)  = x0(1);
xpe(1) = x0(3);
xne(1) = x0(4);

%Evoulution
for n=1:ntrials-1
    
    %% Motor output determination
    z(n) = xb(n) + xfa(n) + xsa(n);
    
    %% Error computation
    e(n) = input(n) - z(n);        % Kinematic error previous step
    em   = abs(e(n));
    %% Computation of probability
%     Pb = normpdf(em,0,nSTD*sigmaNE)/normpdf(0,0,nSTD*sigmaNE); %Probability that cee are due to the body
    Pb = 2*normcdf(em,0,nSTD*sigmaNE,'upper'); %Under the assumption (H0) that errors belong to the body, what is the probability of observing this or a higher value?
    Pw(n) = 1-Pb; %Probability that currenttly experienced errors are due to the environment
    
    %% States update
    %% Reactive components update
    %         xf(n+1) = af*xf(n) + bf*e(n); % Error driven fast adaptation
    %         xs(n+1) = as*xs(n) + bs*e(n); % Error driven slow adaptation
    xb(n+1) = ab*xb(n) + bb*e(n); % Error driven fast adaptation [BODY]
    
    %% Activation of motor primitives for the next step
    % 1. Decay
    xfa(n+1) = af*xfa(n);
    xsa(n+1) = as*xsa(n);
    
    % 2. Update
    if e(n)>0
        xfa(n+1) = xfa(n+1)     +   bfet*xpe(n)*em*Pw(n);
        xsa(n+1) = xsa(n+1)     +  (bset*xpe(n)     +    bsint*xne(n))*em*Pw(n);
    else
        xfa(n+1) = xfa(n+1)  +   bfet*xne(n)*em*Pw(n);
        xsa(n+1) = xsa(n+1)  +  (bset*xne(n)     +    bsint*xpe(n))*em*Pw(n);
    end
    %% Primitives update
    % 1. Decay
    xpe(n+1) = aet*xpe(n);
    xne(n+1) = aet*xne(n);
    
    % 2. Update
    if e(n)>0
        xpe(n+1) = min([xpe(n+1) + bet*e(n)*Pw(n), maxPA]);
    elseif e(n)<0
        xne(n+1) = max([xne(n+1) + bet*e(n)*Pw(n), -maxPA]);
    else
    end
end
z(end) = xb(end)  +  xfa(end)  +  xsa(end)  ;
e(end) = input(end) -   z(end);
em   = abs(e(end));
Pb = normpdf(em,0,nSTD*sigmaNE)/normpdf(0,0,nSTD*sigmaNE); %Probability that cee are due to the body
Pw(end) = 1-Pb; %Probability that currently experienced errors are due to the environment
X = [xb; xpe; xne; xfa; xsa];
Xadd=Pw;
end