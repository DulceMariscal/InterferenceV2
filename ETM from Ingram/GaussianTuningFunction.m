function y = GaussianTuningFunction(TuningAngleList,TuningWidth,ValueAt0,ValueAt180,CurrentAngle)
    if( nargin == 4 )
        CurrentAngle = 0;
    end
    
    TuningAngleCount = length(TuningAngleList);
    y = zeros(1,TuningAngleCount);
    
    % A tuning width of zero is special non-Gaussian case handled here.
    if( TuningWidth == 0 )
        y = ValueAt180 * ones(size(y));
        i = find(degcentre(TuningAngleList) == degcentre(CurrentAngle));
        y(i) = ValueAt0;
        return;
    end
    
    for i=1:TuningAngleCount
        y(i) = GaussianValue(0,TuningWidth,degcentre(TuningAngleList(i)-CurrentAngle));
    end
    
    y = y - min(y);
    y = y / max(y);
    y = y * (ValueAt0-ValueAt180);
    y = y + ValueAt180;
end
