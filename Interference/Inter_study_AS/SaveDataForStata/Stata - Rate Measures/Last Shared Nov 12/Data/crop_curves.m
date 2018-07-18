function cacropped = crop_curves(ca)
[ng,ns,nc] = size(ca);
aa = ca(:); 
min_len = min(cellfun(@length,aa)); %Minumum length
cacropped = zeros(ng, ns, nc, min_len);

for g=1:ng
    for s=1:ns
        for c=1:nc
           cacropped(g,s,c,:) =  ca{g,s,c}(1:min_len); 
        end
    end
end

end
