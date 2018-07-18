function  ns = compute_nstmp(f)

m=min(f);
M=max(f);
th = (m+M)/2;
ns = find(f>=th,1);

end