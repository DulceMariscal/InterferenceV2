function [z, e, X, Xadd] = SSIM_evolve_lisu_5s_gtuningOff(k, input , x0) 
%% Model with facilitation and interference not proportional to the error in the slow state
% Possible future edits:
%   1. Add the possibility of interference also in the fast state.
%       Hopefully the coefficients for the fast state will be very low
%   2. Fix the problems with the aftereffects. They are bigger for the
%   savings groups compared to the interference group
ntrials = length(input);

% Parameters extraction
kcell = num2cell(k);
%[af,bfet,as,bset,bsint,aet,bet,ab,bb] = kcell{:};
%[af,fpeak,as,speak,sstd,aet,bet,ab,bb,ofset] = kcell{:};
[af,fpeak,as,speak,aet,bet,ab,bb,ofset] = kcell{:};
sstd=0.9;
fstd=1/3;

%Initializations
z = zeros(1,ntrials);
%xf = zeros(1,ntrials);
xs = zeros(1,ntrials);
xpe = zeros(1,ntrials);
xne = zeros(1,ntrials); 
e = zeros(1,ntrials);
xfa = zeros(1,ntrials);
xsa = zeros(1,ntrials);
em = 0;

%xf(1)  = x0(1);
xs(1)  = x0(1);
xpe(1) = x0(2);
xne(1) = x0(3);

%Evoulution
for n=1:ntrials-1
    
    %% Motor output determination    
        z(n) = xs(n) + xfa(n) + xsa(n);
    
    %% Error computation
        e(n) = input(n) - z(n);        % Kinematic error previous step
        em   = abs(e(n));
    
    %% States update
        %% Reactive components update
if n==151
    disp('2701')
end
        %xf(n+1) = af*xf(n) + bf*e(n); % Error driven fast adaptation
        xs(n+1) = ab*xs(n) + bb*e(n); % Error driven slow adaptation
        
    %% Activation of motor primitives for the next step
   
        %fast contextual tuning
        cfp=fpeak*normpdf(e(n),1,fstd);
        cfn=fpeak*normpdf(e(n),-1,fstd);
        
        xfa(n+1) = af*xfa(n) + cfp*xpe(n) + cfn*xne(n);
        
        %slow contextual tuning
        csp=ofset+speak*normpdf(e(n),1,sstd);
        csn=ofset+speak*normpdf(e(n),-1,sstd);
        
        xsa(n+1) = as*xsa(n) + csp*xpe(n) + csn*xne(n);
       
    %% Primitives update 
        % 1. Decay
        xpe(n+1) = aet*xpe(n);
        xne(n+1) = aet*xne(n);

     % 2. Learning %max adapted state is constrained
        if e(n)>0
            xpe(n+1) = min([xpe(n+1) + bet*e(n), 1]);
        elseif e(n)<0
            xne(n+1) = max([xne(n+1) + bet*e(n), -1]);
        else
        end
end
z(end) = xs(end)   +   xfa(end)  +  xsa(end)  ;
e(end) = input(end) -   z(end);

X = [xfa; xsa; xpe; xne; xs];
Xadd=[];
end