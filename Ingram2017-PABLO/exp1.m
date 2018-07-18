%% Exp 1 simulation

%% Define model
%%From Ingram 2017, ETM model for exps 1,2,3:
a0=.9783; a180=.996; sigmaA=38.9;
b0=.1095; b180=.0225; sigmaB=14.5;
c0=1; c180=.0323; sigmaC=14.5;
prefDirs=[];

%% Polar plots of model (comparable to middle panels in Fig 1)
figure
D=[-90:1:180,-179:1:-91];
subplot(3,1,1)
polarplot(alpha(D,a0,a180,sigmaA))
rlim([.95 1])
subplot(3,1,2)
polarplot(alpha(D,b0,b180,sigmaB))
subplot(3,1,3)
polarplot(alpha(D,c0,c180,sigmaC))

%% Simulate
Init=[-ones(46,1) zeros(46,1)]';
C0=[ones(20,1) zeros(20,1)]';
C22=[cos(pi-2*pi*22.5/360) sin(pi-2*pi*22.5/360)]' *ones(1,20);
C45=[cos(pi-2*pi*45/360) sin(pi-2*pi*45/360)]'*ones(1,20);
C90=[cos(pi-2*pi*90/360) sin(pi-2*pi*90/360)]'*ones(1,20);
C180=[cos(pi-2*pi*180/360) sin(pi-2*pi*180/360)]'*ones(1,20);
E180=[-ones(18,1) zeros(18,1)]';
targets=[Init C0 E180 C22 E180 C45 E180 C90 E180 C180 E180];
trialTypes=[ones(46,1); 2*ones(20,1); ones(18,1); 2*ones(20,1); ones(18,1); 2*ones(20,1); ones(18,1); 2*ones(20,1); ones(18,1); 2*ones(20,1); ones(18,1)];
X0=.1*ones(16,1); %Tuned to reproduce figure in paper
%% Sim
[Y,X,E]=forwardSim(targets,trialTypes,X0,a0,a180,sigmaA,b0,b180,sigmaB,c0,c180,sigmaC,prefDirs);

%% Plot
X1=[X;X(1,:)];
figure
subplot(3,1,1) %Evolution of error
plot(sqrt(sum(E.^2)),'LineWidth',3)
hold on
plot(sqrt(sum(Y.^2)).*(trialTypes'==2),'LineWidth',3)
legend('Error','Output as % of ideal')
title('Error and Adaptation indexes (Fig 2 panel B)')
subplot(3,1,2) %Evolution of states
plot(X([1,2,3,5,6,9],:)')
legend({'0','22.5','45','90','112.5','180'})
title('State evolution (for some modules)')
%subplot(3,1,3) %Polar evolution of states
%polarplot([X1(:,1:5:end)])
