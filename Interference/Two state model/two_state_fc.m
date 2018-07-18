function [dx]=two_state_fc(t,x,k,e)
if length(e)~=1
    e=e(round(t));
end

%Assign parameters
kcell = num2cell(k);
[Af,Bf,As,Bs]=kcell{:};

x1=x(1);
x2=x(2);

% %Reconstruct motor output
% x_mo = x1 + x2;
% %Reconstruct error
% e = f - x_mo;

dx1 = Af*x1 + Bf*e; %Fast
dx2 = As*x2 + Bs*e; %Slow
dx=[dx1 dx2]';

end