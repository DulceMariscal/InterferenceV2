% function [x, e, xf, xs, xpe, xne]= two_state_int_evolve2(params, pert , x0)
% % This is the FIRST version in the presentation
% % Possible future edits:
% %   1. Add the possibility of interference also in the fast state.
% %       Hopefully the coefficients for the fast state will be very low
% %   2. Fix the problems with the aftereffects. They are bigger for the
% %   savings groups compared to the interference group
% ntrials = length(pert);
% 
% % Parameters extraction
% kcell = num2cell(params);
% [af,bf,bfet,as,bs,bset,bsint,aet,bet] = kcell{:};
% 
% %Initializations
% x = zeros(1,ntrials);
% xf = zeros(1,ntrials);
% xs = zeros(1,ntrials);
% xpe = zeros(1,ntrials); %
% xne = zeros(1,ntrials); %
% e = zeros(1,ntrials);
% 
% xf(1)  = x0(1);
% xs(1)  = x0(2);
% xpe(1) = x0(3);
% xne(1) = x0(4);
% %Evoulution
% for n=1:ntrials-1
%     
%     x(n) = xf(n) + xs(n);
%     e(n) = pert(n) - x(n);        % Kinematic error previous step
%     em   = abs(e(n));
%     
%     %% Reactive components update
%     %     if n==2701
%     %        disp('2701')
%     %     end
%     xf(n+1) = af*xf(n) + bf*e(n); % Error driven fast adaptation
%     xs(n+1) = as*xs(n) + bs*e(n); % Error driven slow adaptation
%     
%     % Fast contextual tuning
%     if e(n)>0
%         xf(n+1) = xf(n+1) + bfet*xpe(n)*em;
%     elseif e(n)<0
%         xf(n+1) = xf(n+1) + bfet*xne(n)*em;
%     else
%     end
%     
%     % Slow contextual tuning
%     if e(n)>0
%         xs(n+1) = xs(n+1) + bset*xpe(n)*em + bsint*xne(n)*em;
%     elseif e(n)<0
%         xs(n+1) = xs(n+1) + bset*xne(n)*em + bsint*xpe(n)*em;
%     else
%     end
%     
%     %% Primitives update (effect of practice)
%     % 1. Decay
%     xpe(n+1) = aet*xpe(n);
%     xne(n+1) = aet*xne(n);
%     
%     % 2. Increase
%     if e(n)>0
%         xpe(n+1) = xpe(n+1) + bet*e(n);
%     elseif e(n)<0
%         xne(n+1) = xne(n+1) + bet*e(n);
%     else
%     end
% 
%     
%     
% end
% x(end) = xs(end)   +   xf(end);
% e(end) = pert(end) -   x(end);
% 
% end