function a=alpha(D,a0,a180,sigmaA)
    a=a180+(a0-a180)*(exp(-.5*D.^2/sigmaA^2)-exp(-.5*180^2/sigmaA^2))/(1-exp(-.5*180^2/sigmaA^2));
end