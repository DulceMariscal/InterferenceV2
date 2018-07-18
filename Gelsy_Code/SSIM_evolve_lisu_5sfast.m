function [z, e, X, Xadd] = SSIM_evolve_lisu_5sfast(k, input , x0) 
%% Model with facilitation and interference not proportional to the error in the slow state
% Possible future edits:
%   1. Add the possibility of interference also in the fast state.
%       Hopefully the coefficients for the fast state will be very low
%   2. Fix the problems with the aftereffects. They are bigger for the
%   savings groups compared to the interference group
ntrials = length(input);

% Parameters extraction
kcell = num2cell(k);
[af,bfet,as,bset,bsint,aet,bet,ab,bb] = kcell{:};

%too much overshoot upon perturbation removal
af=0.7442;
bfet=0.7758;
as=0.975;
bset=0.0401;
bsint=0.5; %0.45
aet=0.99999;
bet=0.003415;
ab=0.85; 
bb=0.15;

% %too much overshoot upon perturbation removal, but good in A2 and wash
% af=0.7442;
% bfet=0.7758;
% as=0.975;
% bset=0.0401;
% bsint=0.5; %0.45
% aet=0.99999;
% bet=0.003415;
% ab=0.9747; 
% bb=0.02884;

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
        %xf(n+1) = af*xf(n) + bf*e(n); % Error driven fast adaptation
        xs(n+1) = ab*xs(n) + bb*e(n); % Error driven slow adaptation
        
    %% Activation of motor primitives for the next step
        if e(n)>0
            xfa(n+1) = af*xfa(n)  +  bfet*xpe(n)*em +    bsint*xne(n)*em ;
            xsa(n+1) = as*xsa(n)  +  bset*xpe(n)     ;
            
        elseif e(n)<0
            xfa(n+1) = af*xfa(n)  +  bfet*xne(n)*em +    bsint*xpe(n)*em ;
            xsa(n+1) = as*xsa(n)  +  bset*xne(n)      ;
        else
            xfa(n+1) = af*xfa(n) ;
            xsa(n+1) = as*xsa(n) ; 
        end

    %% Primitives update 
        % 1. Decay
        xpe(n+1) = aet*xpe(n);
        xne(n+1) = aet*xne(n);

     % 2. Learning %max adapted state is constrained
        if e(n)>0
            xpe(n+1) = min([xpe(n+1) + bet*e(n), 1]);
        elseif e(n)<0
            xne(n+1) = max([xne(n+1) + bet*e(n), -1]);
        end
end
z(end) = xs(end)   +   xfa(end)  +  xsa(end)  ;
e(end) = input(end) -   z(end);

X = [xfa; xsa; xpe; xne; xs];
 %scatter(1:length(e),e,'r');
  %   hold on
     
    % scatter(1:length(e),xpe,'c');
     %scatter(1:length(e),xne,'k');
   %  scatter(1:length(e),xsa,'g');
    % scatter(1:length(e),xfa,'m');
     %scatter(1:length(e),xs,'y');
     %scatter(1:length(e),z,'b');
Xadd=[];
end