function     R2 = computeR2(data, fit)
dd=size(data); df=size(fit);
if length(df)==3
    fit = fit(:,:,2); %Only consider y coordinate (Drop x Coordinate)
end
if dd(1) ~= df(1)
    fit=fit';
end

datav = data(:); fitv=fit(:);
SSE = sum((datav - fitv).^2);
SSR = sum(fitv - mean(datav).^2);
SST = SSE + SSR;
R2 = SSR/SST;

end