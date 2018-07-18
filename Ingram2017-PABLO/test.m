%Test:

%% Define model

%% From Ingram 2017 figure 1
a0=.97; a180=.99; sigmaA=40;
b0=.1; b180=.05; sigmaB=15;
c0=1; c180=.1; sigmaC=15;
prefDirs=[];

%% From Ingram 2017, ETM model for exps 1,2,3:
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
%% Something:
E0=[ones(20,1) zeros(20,1)]';
E180=[-ones(20,1) zeros(20,1)]';
targets=[E0 E180 E0];
trialTypes=[ones(1,size(targets,2))]; %1 is exposure, 0 is zero-force, 2 is error clamp
X0=.8*ones(16,1);
%% Experiment 1:
Init=[ones(46,1) zeros(46,1)]';
C0=[ones(20,1) zeros(20,1)]';
C22=[cos(2*pi*22.5/360) sin(2*pi*22.5/360)]';
C45=[cos(2*pi*45/360) sin(2*pi*45/360)]';
C90=[cos(2*pi*90/360) sin(2*pi*90/360)]';
C180=[cos(2*pi*180/360) sin(2*pi*180/360)]';
E180=[-ones(18,1) zeros(18,1)]';
targets=[Init C0 E180 C22 E180 C45 E180 C90 E180 C180 E180];
trialTypes=[ones(46,1); 2*ones(20,1); ones(18,1); 2*ones(20,1); ones(18,1); 2*ones(20,1); ones(18,1); 2*ones(20,1); ones(18,1); 2*ones(20,1); ones(18,1)];
X0=.1*ones(16,1); %Tuned to reproduce figure in paper
%% Sim
[Y,X,E]=forwardSim(targets,trialTypes,X0,a0,a180,sigmaA,b0,b180,sigmaB,c0,c180,sigmaC);

%% Plot
X1=[X;X(1,:)];
figure
subplot(3,1,1) %Evolution of error
plot(sqrt(sum(E.^2)))
hold on
plot(sqrt(sum(Y.^2)).*(trialTypes'==2))
legend('Error','Output as % of ideal')

subplot(3,1,2) %Evolution of states
plot(X([1,2,3,5,6,9],:)')
legend({'0','22.5','45','90','112.5','180'})

subplot(3,1,3) %Polar evolution of states
polarplot([X1(:,1:5:end)])
