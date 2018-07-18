function  nstrides=find_nstrides_to_perc(data,percentages,INCR_EXP)
npe=length(percentages);
nstrides=zeros(1,npe);
for i=1:npe
    cthr=percentages(i)*data(1);
    if INCR_EXP
        nstr=find(data >= cthr, 1);
        if isempty(nstr)
            nstrides(i)=nan;
        else
            nstrides(i)=nstr;
        end
    else
        nstr=find(data <= cthr, 1);
        if isempty(nstr)
            nstrides(i)=nan;
        else
            nstrides(i)=nstr;
        end
%         nstrides(i)=find(data >= cthr, 1); %Shouldn't it be <= ???
    end
end

end