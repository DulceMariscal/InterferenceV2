function                plot_norm_curves(ccurve,norm_ccurve,crossnorm_ccurve)

figure

%% 1ST COMPARISON
subplot(1,2,1)% , plot(ccurve), subplot(1,2,2), plot(norm_ccurve)
MIN=min(ccurve);
MAX=max(ccurve);

yyaxis left
plot(ccurve,'*-')
ylabel('Original Curve')
ylim([MIN MAX]);
hold on

yyaxis right
plot(norm_ccurve)
ylabel('Normalized Curve')
ylim([0 1])
xlabel('Strides');

%% 2ND COMPARISON
subplot(1,2,2)% , plot(ccurve), subplot(1,2,2), plot(norm_ccurve)

yyaxis left
plot(ccurve,'*-')
ylabel('Original Curve')
ylim([MIN MAX]);
hold on

yyaxis right
plot(crossnorm_ccurve)
ylabel('Normalized Curve')
ylim([0 1])
xlabel('Strides');


end


