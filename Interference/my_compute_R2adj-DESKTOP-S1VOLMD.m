function R2adj = my_compute_R2adj(yfit,ydata,npars,varargin)

%% To have the "standard" R2 value, choose ADJ=0 and UNCENTERED=0

if length(varargin) < 2
    ADJ = 1;
    UNCENTERED = 1;
else
    ADJ = varargin{1};
    UNCENTERED = varargin{2};
end

%Definition of inputs to the funtion
y = ydata;

dy=size(y);
ds=size(yfit);

if dy(1)==ds(1)
    %Do nothing
else
    yfit=yfit';
end
    
resid = y - yfit;


R2adj = rsquared(y,resid,npars,ADJ, UNCENTERED);


end
