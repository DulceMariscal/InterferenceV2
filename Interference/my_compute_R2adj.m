function R2adj = my_compute_R2adj(smoothedCurve,originalCurve,npars)

%Definition of inputs to the funtion
y = originalCurve;

dy=size(y);
ds=size(smoothedCurve);

if dy(1)==ds(1)
    %Do nothing
else
    smoothedCurve=smoothedCurve';
end
    
resid = y - smoothedCurve;
ADJ = 1;
UNCENTERED = 1;

R2adj = rsquared(y,resid,npars,ADJ, UNCENTERED);


end
