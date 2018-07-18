function     yt = compute_trend(y,FIRST_SAMPLES)
% This function assumes that there are no nan (call nan_interp to interpolate nans)
% 
yt=y;
l=length(y);

for i=2:l
    %     yt(i) = nanmean(y(1:i));
    yt(i) = ((i-1)*yt(i-1) + y(i)) / i;
end

if FIRST_SAMPLES ~=0
   yt(1:FIRST_SAMPLES)=mean(y(1:FIRST_SAMPLES)); 
end

end