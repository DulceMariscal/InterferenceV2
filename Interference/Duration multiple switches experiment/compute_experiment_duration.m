%% Computation of experiment time

%Parameters definition-----------------------------------------------------
%1. Training phase
N=10;
A=10;
GW=15:15:100;
REP=10:10:60;

%2. Testing phase
N_te = 300;
A_te = 600;
Wo_te= 150;

%3. Other parameters
stridesToMin=60; % Assuming 1 second for each stride

%Derived parameters
ngw=length(GW);
nrep=length(REP);

legends={};
%Main
figure
for irep=1:nrep
    crep=REP(irep);
    nstrides=[];
    
    legends=[legends [num2str(crep) ' repetitions']];
    for igw=1:ngw
        cgw=GW(igw);
        nstrides(igw) = crep*(N+A+cgw) + (N_te + A_te + Wo_te) ;
    end
    
    %Plot current graph
    hold on
    plot(GW, nstrides/stridesToMin, 'o');
    grid on
end
hold on
XLIM=xlim();
maxdur=80;
line(XLIM,[h h], 'Color','r','LineWidth',2);
legends=[legends [num2str(maxdur) ' min limit']];
xlabel('Gradual washout duration [strides]')
ylabel('Whole experiment duration [min]')
legend(legends);