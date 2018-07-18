function plot_tc_contrasts(NOS)

figure
subplot(2,1,1)
plot_dots_and_line(squeeze(NOS(1,:,:))); %Interference
ylabel('INTERFERENCE')
subplot(2,1,2)

plot_dots_and_line(squeeze(NOS(2,:,:))); %Savings
ylabel('SAVINGS')


end