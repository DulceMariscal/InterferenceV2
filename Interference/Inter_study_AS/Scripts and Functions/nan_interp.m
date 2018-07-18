function     y_int=nan_interp(y,method)
if isempty(method)
    method='linear';
end

nan_y  = isnan(y);
not_nan_y = ~nan_y;
t     = 1:numel(y);

%Set eventual nan in first position to first non-nan
if not_nan_y(1)==1
    %Do nothing
else
    %Find the first non nan
    ind_first_non_nan=find(not_nan_y,1);
    y(1) = y(ind_first_non_nan);  
    nan_y(1)=0; not_nan_y(1)=1;
end

%Set eventual nan in last position to first non-nan from end
if not_nan_y(end)==1
    %Do nothing
else
    %Find the first non nan from left
    ind_first_non_nan_from_end=find(not_nan_y,1,'last');
    y(end) = y(ind_first_non_nan_from_end);  
    nan_y(end)=0; not_nan_y(end)=1;
end

y_int = y;
%Interpolate nan in central positions
y_int(nan_y) = interp1(t(not_nan_y), y(not_nan_y), t(nan_y), method);



end