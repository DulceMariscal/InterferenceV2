%% RUNNING AVERAGE OF STD DURING BASELINE (HP: it increases in those who will be less perturbed)


load('ExtAdaptNorm2BaselineData.mat')

% Remove abnormal subjects
bad_subs=7; % Corresponds to I008 (Baseline before training was not recorded,
% an additional washout was performed to estimate baseline asymmetry)
indOK=setdiff(1:16,bad_subs);

% Parameters analysis
firstBad=5;
lastBad=5;
w=10; %Window runnign std
data=BASELINE_DATA;
ns=length(data);


figure
stdevs_in=[]; %Standard deviation over initial
stdevs_fin=[]; %Standard deviation over initial

% Plot parameters
margins=[0.05 0.05];

for csub=1:ns
    % 0 Extract data
    cdata=data{csub};
    
    % 1. Remove first and last strides
    cdata=cdata(firstBad+1:end-lastBad);
    n=length(cdata);
    v=1:n;
    
    % 2. Filter out noise (Due to cameras, wrong interpolations, ..)
    
    % 3. Compute running standard deviation
    runningStd=compute_running_std(cdata,w);
    
    % 4. Plot baseline + overlapped standardDev
    subplot_tight(4,4,csub,margins);
    plot(cdata)
    hold on
    plot(w:n,runningStd,'*')
    
    % 5. Store initial and final stdev
    if any(csub==indOK) %Exclude bad subject
        stdevs_in  = [stdevs_in  runningStd(1)];
        stdevs_fin = [stdevs_fin runningStd(end)];
    end
    legend('Baseline','runningStd');
    
    %     % 5. Insert legend (value of parameter of interest)
    %     for fp=1:nfp
    %         cpar=focusPars(fp);
    %         fp_str = [table_variables{cpar}];
    %         allVals=[outcome_table{indA1,cpar}];
    %         fp_val = allVals(csub);
    %         legends{fp}=[fp_str ' = ' num2str(fp_val)];
    %     end
    %
    %     l(csub) = legend(legends);
    %     legends={};
    
end

STDBASE=[stdevs_in' stdevs_fin'];
