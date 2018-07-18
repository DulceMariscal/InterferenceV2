function plot_two_state_model(f,k_ext_min,trials,error)

[~, x1, x2] = two_state_lsq_noIC(k_ext_min,trials,zeros(size(trials)),error);

figure(f);
hold on
plot(trials,x1,'--c',trials,x2,'--m',trials,x1+x2,'k','LineWidth',3);




end