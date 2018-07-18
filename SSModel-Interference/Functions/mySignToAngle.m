function thetav = mySignToAngle(pert)

    thetav = nan(size(pert));
    thetav(pert>0) = 0;
    thetav(pert<0) = 180;

end