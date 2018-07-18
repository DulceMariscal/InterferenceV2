function                 ttr  = my_time_to_rise(ccurve,percs)

ccurve = normalize_curve(ccurve, 0);

ssv  = ccurve(end);
vals = percs*ssv;
[~, t1] = min(abs(ccurve - vals(1)));
[~, t2] = min(abs(ccurve - vals(2)));
ttr = t2-t1;

end