function SS = eq_perturbation_lsq2(delta,a1int,a1sav)
indok = intersect(~isnan(a1int), ~isnan(a1sav));

SS = sum(a1sav(indok) - (a1int(indok) + delta) ).^2;

end