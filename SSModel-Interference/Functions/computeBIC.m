function BIC = computeBIC(data, fit, k)
    sf = size(fit);
    if length(sf)==3
        fit = fit(:,:,2); %Only consider y coordinate (Drop x Coordinate)
    end
    if size(data,1) ~= size(fit,1)
        fit=fit';
    end

    N = length(data(:));
    residuals = data-fit;
    sigma2 = nanvar(residuals(:));
    BIC = N*log(sigma2) + k*log(N);
end

% Where s2e
% is the variance in the residual errors of the fit, k is the number of free parameters and
% N is the number of data points (the number of trials). Taking the difference in BIC values for
% two competing models approximates half the log of the Bayes factor [52]. A BIC difference of
% greater than 4.6 (a Bayes factor of greater than 10) is considered to provide strong evidence in
% favour of the model with the lower BIC value [53].