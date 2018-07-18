function [z, e, X] = ETM_evolve(params, zideal , x0)
%This only works for the bidirectional case
zideal= squeeze(zideal);
dims = size(zideal);
if dims(1)>dims(2)
    zideal=zideal';
end

% Parameters extraction
kcell = num2cell(params);
[alpha0, alpha180, beta0, beta180, c180, AA, BA, CA] = kcell{:};
m = length(x0); %Number of modules
ntrials = size(zideal,2);


% Initializations
z = zeros(1,ntrials);
e = zeros(2,ntrials);
em = zeros(1,ntrials);
thetae = zeros(1,ntrials); %Angle
X = zeros(m,ntrials);
thetam = [90 -90]';
deltam = zeros(m,ntrials); %Delta Modules
deltae = zeros(m,ntrials);
% xp = zeros(1,ntrials); % Positive (0) error-tuned module
% xn = zeros(1,ntrials); % Negative (180) error-tuned module
C = zeros(m,ntrials); ALPHA = zeros(m,ntrials); BETA = zeros(m,ntrials);

% Set initial condition
X(:,1) = x0;

% Visual context definition (What happens when there is no perturbation?? Ideal output magnitude would be 0)
thetav = rad2deg(atan(zideal(2,:)./zideal(1,:)));

% NOTE: In the motor output generation
% sin(theta) does not matter because in this case it would always be 0



% Evolution
for n=1:ntrials-1
    % Motor output determination
    if isnan(thetav(n)) %This happens when the visual context is unknown or if the ideal motor output is (0,0)
        C(:,n) = CA*ones(2,1);
    else
        deltam(:,n) = thetam - thetav(n);
        C(:,n)      = my_cnt_tun(deltam(:,n), 1, c180);         %C0 is fixed to 1
    end
    z(1,n)      = sum(C(:,n).*X(:,n).*cosd(thetam));
    z(2,n)      = sum(C(:,n).*X(:,n).*sind(thetam));
    e(:,n)        = zideal(:,n) - z(:,n);
    
    [thetaeRad, em(n)] = cart2pol(e(1,n),e(2,n));
    thetae(n) = rad2deg(thetaeRad);
    deltae(:,n) = thetam - thetae(:,n);
    
    % Modules update
    if isnan(thetav(n))
        ALPHA(:,n) = AA*ones(2,1);
        BETA(:,n) = BA*ones(2,1);
    else
        ALPHA(:,n) = my_cnt_tun(deltam(:,n), alpha0 , alpha180);
        BETA(:,n)  = my_cnt_tun(deltam(:,n), beta0 ,  beta180);
    end
    X(:,n+1) = max([ALPHA(:,n).*X(:,n) + BETA(:,n).*cosd(deltae(:,n)).*em(n) zeros(m,1)],[], 2);
end


% Final motor output determination
n = ntrials;
deltam(:,n) = thetam - thetav(n);
C(:,n)      = my_cnt_tun(deltam(:,n), 1, c180);         %C0 is fixed to 1
z(1,n)      = sum(C(:,n).*X(:,n).*cosd(thetam));
z(2,n)      = sum(C(:,n).*X(:,n).*sind(thetam));
e(:,n)        = zideal(:,n) - z(:,n);

% zk = k*z;
end
