x = [-4:.1:4];
norm_pe = normpdf(x,1,0.1);
norm_ne = normpdf(x,-1,1);

legends = {};
figure
for i = 0.1:.1:1
    plot(x,i*norm_pe); hold on
    legends = [legends; num2str(i)];
end
legend(legends)

sigma=1/4;
norm_pe = normpdf(x,1,sigma);
figure
plot(x,norm_pe)
legend(['f(0) = ' num2str(normpdf(0,1,sigma))])


