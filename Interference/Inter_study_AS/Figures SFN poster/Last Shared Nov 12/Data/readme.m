
all_curves_crossnorm = cell(ng,nos(1),nc); % Group (int, sav) X subjects X condition (A1, A2)
all_curves_after_smoothing = cell(ng,nos(1),nc,nsm); % Group (int, sav) X subjects X condition (A1, A2) X smoothing ({'1_EXP','MONOTONIC_FIT','1_EXP_CONSTR','2_EXP_CONSTR','2_EXP'})