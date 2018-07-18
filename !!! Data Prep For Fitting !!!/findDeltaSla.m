function [delta] = findDeltaSla(adaptations)

a1int = adaptations(1,:);
a1sav = adaptations(2,:);
k0=0;
residFcn =  @(delta)eq_perturbation_lsq2(delta,a1int,a1sav);
[delta] = - fminunc(residFcn, k0);

figure
plot(a1sav); hold on;
plot(a1int); hold on;
plot(a1int + delta); 

legend('sav','int','int+delta')

end