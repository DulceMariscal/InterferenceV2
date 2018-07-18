function     dataFit = my_monoLS(originalCurve,p1,p2)

%Find nans
indnan=isnan(originalCurve);

%Fit monotonic to non-nan data
dataFit = monoLS(originalCurve(~indnan),[],p1,p2);

%Interpolate non-nan data
dataFit_temp = originalCurve;
dataFit_temp(~indnan)=dataFit;
dataFit=nan_interp(dataFit_temp,[]);


end