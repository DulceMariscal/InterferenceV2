function         [xOut, yOut] = my_subsample(yIn,ss)

xOut = 1:length(yIn);
xOut = xOut(1:ss:end);
yOut = yIn(1:ss:end);

end