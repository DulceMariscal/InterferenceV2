function y = GaussianValue(mu,sd,x)
% Returns the value of the specified Gaussian at x
%   y = GaussianValue(mu,sd,x)
    y = (1 / (sd*sqrt(2*pi))) * exp(-((x - mu).^2) / (2*(sd^2)));
end
