function [z, e, X, Xadd] = SSIM_evolve_lisu_6s_ISE(k, input , x0, sigmaNE) 
%% Model with facilitation and interference not proportional to the error in the slow state
% Possible future edits:
%   1. Add the possibility of interference also in the fast state.
%       Hopefully the coefficients for the fast state will be very low
%   2. Fix the problems with the aftereffects. They are bigger for the
%   savings groups compared to the interference group
ntrials = length(input);

% Parameters extraction
kcell = num2cell(k);
[af,bf,bfet,as,bs,bset,bsint,aet,bet,nSTD] = kcell{:};


%Initializations
z = zeros(1,ntrials);
xf = zeros(1,ntrials);
xs = zeros(1,ntrials);
xpe = zeros(1,ntrials);
xne = zeros(1,ntrials); 
e = zeros(1,ntrials);
xfa = zeros(1,ntrials);
xsa = zeros(1,ntrials);
em = 0;
Pw = zeros(1,ntrials); % %Probability environmental errors


xf(1)  = x0(1);
xs(1)  = x0(2);
xpe(1) = x0(3);
xne(1) = x0(4);

%Evoulution
for n=1:ntrials-1
    
    %% Motor output determination    
        z(n) = xf(n) + xs(n) + xfa(n) + xsa(n);
    
    %% Error computation
        e(n) = input(n) - z(n);        % Kinematic error previous step
        em   = abs(e(n));
    %% Update probability
    Pb = normpdf(em,0,nSTD*sigmaNE)/normpdf(0,0,nSTD*sigmaNE);
    Pw(n) = (1 - Pb);
    
    %% States update
        %% Reactive components decay
        xf(n+1) = af*xf(n) + bf*e(n); % Error driven fast adaptation
        xs(n+1) = as*xs(n) + bs*e(n); % Error driven slow adaptation
        
    %% Activation of motor primitives for the next step
        if e(n)>0
            xfa(n+1) = af*xfa(n)  +  Pw(n)*bfet*xpe(n)*em;
            xsa(n+1) = as*xsa(n)  +  Pw(n)*bset*xpe(n)     +    Pw(n)*bsint*xne(n) ;
        else
            xfa(n+1) = af*xfa(n)  +  Pw(n)*bfet*xne(n)*em;
            xsa(n+1) = as*xsa(n)  +  Pw(n)*bset*xne(n)     +    Pw(n)*bsint*xpe(n) ;
        end

    %% Primitives update 
        % 1. Decay
        xpe(n+1) = aet*xpe(n);
        xne(n+1) = aet*xne(n);

     % 2. Learning
        if e(n)>0
            xpe(n+1) = min([xpe(n+1) + Pw(n)*bet*e(n), 1]);
        elseif e(n)<0
            xne(n+1) = max([xne(n+1) + Pw(n)*bet*e(n), -1]);
        else
        end
end
z(end) = xs(end)   +   xf(end)  +  xfa(end)  +  xsa(end)  ;
e(end) = input(end) -   z(end);

X = [xf; xs; xpe; xne; xfa; xsa];
Xadd=[Pw];
end