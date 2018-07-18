function index_first_point=find_strides_to_ignore(data,NUM_CONS,INCREASING,START_FROM_MINIMUM)

%% NUM_COND
%Minimum number of consecutive strides with increasing (decreasing)
%sla (COP_adapt,..)

%% INCREASING
% Specifies whether or not the function that we are dealing with is
% increasing or not

%% START_FROM_MINIMUM
% Specifies whether we want to start considering the curve from the
% minimum or not

NUM_CONS = NUM_CONS-1;
% trendData = compute_trend(data,1);
d=diff(data);
if INCREASING %if we expect an increasing fucntion
    indicesOk=d>=0;
else
    indicesOk=d<=0;
end
y=find_consecutive_ones(indicesOk);

if START_FROM_MINIMUM
    indices_first_points = find(y>=NUM_CONS) - NUM_CONS + 1;
    [min_val] = min(data(indices_first_points));
    index_first_point = find(data==min_val,1);
else
    index_first_point = find(y>=NUM_CONS,1) - NUM_CONS + 1;
end
end
