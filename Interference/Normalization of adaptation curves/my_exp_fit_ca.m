function [coeffs_ca, taus, fitCurves] = my_exp_fit_ca(ca, incrORdecr, modelToFit)


dims=size(ca);
coeffs_ca = cell(dims(1),dims(2));
taus = zeros(dims(1),dims(2));
fitCurves = cell(dims(1),dims(2));

for i=1:dims(1)
    for j=1:dims(2)
        [coeffs_ca{i,j}, dataFit ] = my_exp_fit(ca{i,j},incrORdecr,modelToFit);
        taus(i,j)    = coeffs_ca{i,j}(3);
        fitCurves{i,j} = dataFit;
    end
end

end

