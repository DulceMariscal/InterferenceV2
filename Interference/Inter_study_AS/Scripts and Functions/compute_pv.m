function     [PV, TAU, all_fits ]= compute_pv(all_curves)

[ng, ns, nc] = size(all_curves);
TAU = zeros(ng, ns, nc);
all_fits = cell(size(all_curves));

%% Compute TAUs
for gr=1:ng
        for sub=1:ns
            for cond=1:nc
                    ccurve = all_curves{gr,sub,cond};
                    [pars, fit] = my_exp_fit2(ccurve,'Increasing','Single');
                    TAU(gr,sub,cond) = pars(3);
                    
                    %Store fit
                    all_fits{gr,sub,cond} = fit ;
                    
%                     figure, plot(ccurve,'o'); hold on, plot(fit); legend('data','fit'); 
%                     title(['Group: ' num2str(gr) ' Sub: ' num2str(sub) ' Cond: ' num2str(cond)]);
            end
        end
end

%% COMPUTE PV

PV = (TAU(:,:,2) - TAU(:,:,1)) ./ TAU(:,:,1);

end