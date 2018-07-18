clc
t = 0:600;
a=1:10;
figure
legends = {};
for i=0.1:.1:1
    plot(sqrt(i*t)); hold on
    legends = [legends; num2str(i)]
end

legend(legends)

figure
legends = {};
for i = 0:10:100
    y = t./(t+i);
    plot(y); hold on
    legends = [legends; num2str(i)]
end

legend(legends)

