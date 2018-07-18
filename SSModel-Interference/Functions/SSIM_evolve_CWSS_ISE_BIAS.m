function [z, e, X, Xadd] = SSIM_evolve_CWSS_ISE_BIAS(k, input , x0, sigmaNE)

% Possible future edits:
%   1. Add the possibility of interference also in the fast state.
%       Hopefully the coefficients for the fast state will be very low
%   2. Fix the problems with the aftereffects. They are bigger for the
%   savings groups compared to the interference group
ntrials = length(input);

% Parameters extraction
kcell = num2cell(k);
[af,bf,bfet,as,bs,bset,aet,bet,nSTD] = kcell{:};
% nSTD = 5;

%Initializations
z = zeros(1,ntrials);
xf = zeros(1,ntrials);
xs = zeros(1,ntrials);
xpe = zeros(1,ntrials); %
xne = zeros(1,ntrials); %
Pee = zeros(1,ntrials); % %Probability environmental errors
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
    Pee(n) = 1 - normpdf(em,0,nSTD*sigmaNE)/normpdf(0,0,nSTD*sigmaNE);
    
    %% Reactive components update
    %     if n==2701
    %        disp('2701')
    %     end
    xf(n+1) = af*xf(n) + bf*e(n); % Error driven fast adaptation
    xs(n+1) = as*xs(n) + bs*e(n); % Error driven slow adaptation
    
    %% Primitives contribution
%     if em > nSTD*sigmaNE;
        %On the fast state
        if e(n)>0
            xf(n+1) = xf(n+1) + Pee(n)*bfet*xpe(n)*em;
        elseif e(n)<0
            xf(n+1) = xf(n+1) + Pee(n)*bfet*xne(n)*em;
        else
        end
        
        %On the slow state
        xs(n+1) = xs(n+1) + bset*(xpe(n) + xne(n)); %Constant activation. Bias terms that do not depend on the error at all

%         if e(n)>0
%             xs(n+1) = xs(n+1) + (bset*xpe(n) + bsint*xne(n));
%         elseif e(n)<0
%             xs(n+1) = xs(n+1) + (bset*xne(n) + bsint*xpe(n));
%         else
%         end
%     end
    
    %% Primitives update (effect of practice)
    % 1. Decay
    xpe(n+1) = aet*xpe(n);
    xne(n+1) = aet*xne(n);
    
    % 2. Update
    %     if em > nSTD*sigmaNE;
    if e(n)>0
        xpe(n+1) = xpe(n+1) + Pee(n)*bet*e(n);
    elseif e(n)<0
        xne(n+1) = xne(n+1) + Pee(n)*bet*e(n);
    end
    %     end
    
    
end
z(end) = xs(end)   +   xf(end);
e(end) = input(end) -   z(end);

X = [xf; xs; xpe; xne];
Xadd = Pee;
end