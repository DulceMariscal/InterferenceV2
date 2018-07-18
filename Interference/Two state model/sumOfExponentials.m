%% Sum of exponentials
t=0:0.01:10;
tauFast=1;
tauSlow=10; %In the two rate-model tauSlow is actually greater than tauFast. 
            %In the gain model instead the two time constants are equal and therefore the rebound effect is not present
y0fast = -2;
y0slow = +2;
yfast = y0fast*exp(-t/tauFast);
yslow = y0slow*exp(-t/tauSlow);
ysum=yfast+yslow;

figure
plot(t,yfast,t,yslow,t,ysum,'LineWidth',3);
grid on
legend('yfast','yslow','ysum')
