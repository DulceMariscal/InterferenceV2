function outvec = mynanPad(invec, ntarg)

cl = length(invec);
temp = nan(ntarg,1);

if cl == ntarg
    temp = invec;           %Do nothing
elseif cl < ntarg
    temp(1:cl) = invec;     %Nan pad
    %disp('padding')
elseif cl > ntarg
%     temp = invec(cl-ntarg+1:end);  %Discard first strides
%     disp('Discarding first strides')
    temp = invec(1:ntarg);  %Discard last strides, PABLO 9/13/2018
end
outvec = temp;

end