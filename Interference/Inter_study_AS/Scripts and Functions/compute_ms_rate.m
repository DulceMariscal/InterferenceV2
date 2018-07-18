function msrate = compute_ms_rate(ccurve, thr, del)

i1 = find(ccurve >= thr - del,1 );
i2 = find(ccurve >= thr + del,1 );

msrate = min([i1, i2]);

end