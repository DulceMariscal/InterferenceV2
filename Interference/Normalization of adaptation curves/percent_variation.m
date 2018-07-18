function PV = percent_variation(tau)
    PV = (tau(:,2)-tau(:,1))./tau(:,1);
end