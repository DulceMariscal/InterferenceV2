function             norm_ccurve = normalize_curve(ccurve, PLOT, varargin)

%% 1.Assume that min and max are not provided
externalMin=0;
externalMax=0;

%% 2.If provided, check that they are valid
if ~isempty(varargin)
    tent_min=varargin{1};
    tent_max=varargin{2};
    
    if ~isnan(tent_min)
        MIN = tent_min;
        externalMin=1;
    end
    
    if ~isnan(tent_max)
        MAX = tent_max;
        externalMax=1;
    end
end

%% 3.If externally provided values are not ok or not present, compute min and
   %max
if externalMin==0
    MIN=min(ccurve);
end
if externalMax==0
    MAX=max(ccurve);
end

%% 4. Normalize the curve
norm_ccurve = (ccurve - MIN ) / (MAX - MIN);

%% 5. Plot if requested
if PLOT==1
    figure, subplot(1,2,1), plot(ccurve), subplot(1,2,2), plot(norm_ccurve)

    figure
    yyaxis left
    plot(ccurve,'*-')
    ylabel('Original Curve')
    ylim([MIN MAX]);
    hold on
    
    yyaxis right
    plot(norm_ccurve)
    ylabel('Cross-Normalized Curve')
    ylim([0 1])
    xlabel('Strides');
end

end