

close all
figure 
savings=[zeros(150,1) ;nan(1,1); 0.7*ones(600,1);nan(1,1); zeros(1350,1) ;nan(1,1);0.7*ones(600,1);nan(1,1); zeros(150,1)];
interference=[zeros(150,1);nan(1,1); 0.7*ones(600,1);nan(1,1);  -0.7*ones(600,1); linspace(-.7,0,600)'; zeros(150,1);nan(1,1);0.7*ones(600,1);nan(1,1); zeros(150,1)];
plot(savings,'ob','MarkerFace','b')
hold on
plot(interference,'or','MarkerFace','r')
axis([0 2854 -.75 .75])
legend('Savings (n=11)','Interference (n=10)')
ylabel('Speed difference (m/s) ')
xlabel('Strides')

figure 
perturbation=[zeros(150,1) ;nan(1,1); ones(600,1);nan(1,1); zeros(300,1)];% ;nan(1,1);0.7*ones(600,1);nan(1,1); zeros(150,1)];
x=1:600;
xb=1:300;
a=1-exp(-x/30);
b=exp(-xb/20);
z=[zeros(150,1) ;a';b'];
plot(perturbation,'b','LineWidth',1)
hold on
plot(z,'k','LineWidth',1)