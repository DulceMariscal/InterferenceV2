function     [PV, TAU, all_fits ]= compute_pv2(avgc)

[ng, nc] = size(avgc);
TAU = zeros(ng, nc);
all_fits = cell(size(avgc));

%% Compute TAUs
for gr=1:ng
    for cond=1:nc
        ccurve = avgc{gr,cond};
        [pars, fit] = my_exp_fit2(ccurve,'Increasing','Single');
        TAU(gr,cond) = pars(3);
        
        %Store fit
        all_fits{gr,cond} = fit ;
        
        %                     figure, plot(ccurve,'o'); hold on, plot(fit); legend('data','fit');
        %                     title(['Group: ' num2str(gr) ' Sub: ' num2str(sub) ' Cond: ' num2str(cond)]);
    end
end

%% COMPUTE PV

PV = (TAU(:,2) - TAU(:,1)) ./ TAU(:,1);

end