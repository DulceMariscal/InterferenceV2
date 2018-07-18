function outvec = mynanPad(invec, ntarg)

cl = length(invec);
temp = nan(ntarg,1);

if cl == ntarg
    temp = invec;           %Do nothing
elseif cl < ntarg
    temp(1:cl) = invec;     %Nan pad
elseif cl > ntarg
    temp = invec(cl-ntarg+1:end);  %Discard first strides
end
outvec = temp;

end