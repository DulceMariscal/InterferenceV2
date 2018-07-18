function two_axes_plot(fh, p, c1, c2, ylab1, ylab2, xlab, ylim1, ylim2, tt)

% MIN=min(c1);
% MAX=max(c2);
figure(fh)
subplot(p(1),p(2),p(3))
title(tt);

yyaxis left
plot(c1,'*')
ylabel(ylab1)
ylim(ylim1);
hold on

yyaxis right
plot(c2,'-')
ylabel(ylab2)
ylim(ylim2)
xlabel(xlab);

end