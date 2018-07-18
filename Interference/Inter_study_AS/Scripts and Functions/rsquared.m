function     R2=rsquared(y,resid,npars,ADJ, varargin)
indNan = isnan(y) | isnan(resid);
y = y(~indNan);
resid = resid(~indNan);
if isempty(varargin)
    UNCENTERED=1;
else
    UNCENTERED=varargin{1};
end

ybar=nanmean(y);
ndata=length(y);
SSresid=sum(resid.^2);

if UNCENTERED % This should be used whenever the model we are fitting does not fit any specific parameter for the mean of the data
    SStot=sum((y).^2);        %Un-Centered version
else
    SStot=sum((y-ybar).^2);   %Centered version
end
R2=1-SSresid/SStot;

if ADJ
    R2adj = R2-(1-R2)*npars/(ndata-npars-1) ;
    R2= R2adj;
end

end