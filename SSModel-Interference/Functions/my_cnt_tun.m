function outp = my_cnt_tun(inps, maxv, minv)

ni = length(inps);
outp = zeros(ni,1);
for i=1:ni %For each modules
    inp = inps(i);
    switch inp
        case 0
            outp(i)=maxv;
        case 180
            outp(i)=minv;
        case -180
            outp(i)=minv;
    end
end
end