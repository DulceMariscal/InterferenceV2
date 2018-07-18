function my_plot_dots(cdata)

[nsubs,nkinds] = size(cdata);
v = ones(nsubs, nkinds);
for kind=1:nkinds
    v(:,kind) = kind * v(:,kind) ;
end

plot(v,cdata,'o')
legend('Original', 'Simple-Norm', 'Cross-Norm')

end