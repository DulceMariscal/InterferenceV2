%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Implement Error-Tuned Model (ETM) from Ingram et al (2017) PLoS Comp Biol


k = 0;

k = k + 1;
% ETM values for experiments 1,2,3
ETM_ModelParameters{k}.A0   = 0.9783; 
ETM_ModelParameters{k}.A180 = 0.9960;
ETM_ModelParameters{k}.Awid = 38.9;
ETM_ModelParameters{k}.B0   = 0.1095;
ETM_ModelParameters{k}.B180 = 0.0225;
ETM_ModelParameters{k}.Bwid = 14.5;
ETM_ModelParameters{k}.X0   = 1.0000;
ETM_ModelParameters{k}.X180 = 0.0323;
ETM_ModelParameters{k}.Xwid = ETM_ModelParameters{1}.Bwid;
ETM_ModelParameters{k}.ModuleCount = 16;
ETM_ModelParameters{k}.InitialAdaptation = 0.0;

k = k + 1;
ETM_ModelParameters{k}.A0   = 0.9783;
ETM_ModelParameters{k}.A180 = 0.9960;
ETM_ModelParameters{k}.Awid = 38.9;
ETM_ModelParameters{k}.B0   = 0.1095;
ETM_ModelParameters{k}.B180 = 0.0225;
ETM_ModelParameters{k}.Bwid = 14.5;
ETM_ModelParameters{k}.X0   = 1.0000;
ETM_ModelParameters{k}.X180 = 0.0323;
ETM_ModelParameters{k}.Xwid = ETM_ModelParameters{1}.Bwid;
ETM_ModelParameters{k}.Bamb = 0.0131;
ETM_ModelParameters{k}.Aamb = 0.9895;
ETM_ModelParameters{k}.Xamb = 0.4285;
ETM_ModelParameters{k}.ModuleCount = 16;
ETM_ModelParameters{k}.InitialAdaptation = 0.0;

k = k + 1;
ETM_ModelParameters{k}.A0   = 0.92;
ETM_ModelParameters{k}.A180 = 1.00;
ETM_ModelParameters{k}.Awid = 0.00;
ETM_ModelParameters{k}.B0   = 0.79;
ETM_ModelParameters{k}.B180 = 0.20; %0.00;
ETM_ModelParameters{k}.Bwid = 0.00;
ETM_ModelParameters{k}.X0   = 1.00;         %C0
ETM_ModelParameters{k}.X180 = 0.30; %0.49;  %C180
ETM_ModelParameters{k}.Xwid = 0.00;
ETM_ModelParameters{k}.ModuleCount = 2;
ETM_ModelParameters{k}.InitialAdaptation = 0.8;

ModelParameterCount = k;

for k=1:ModelParameterCount
    ETM_ModelParameters{k}.ModuleAngleStep = 360/ETM_ModelParameters{k}.ModuleCount;
    ETM_ModelParameters{k}.ModuleAngleList = -180:ETM_ModelParameters{k}.ModuleAngleStep:179;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TRIAL_TYPE_ZERO_FORCE  = 1; % Zero-force trial.
TRIAL_TYPE_EXPOSURE    = 2; % Exposure trial.
TRIAL_TYPE_ERROR_CLAMP = 3; % Error-clamp trial.

TrialTypeList = [ TRIAL_TYPE_ZERO_FORCE TRIAL_TYPE_EXPOSURE TRIAL_TYPE_ERROR_CLAMP ];
TrialTypeText = { 'Z' 'E' 'C' };

TrialTypePertubation = [ 0 1 0 ];
TrialTypeErrorClamp = [ 0 0 1 ];

EXPERIMENT_TYPE_PROBE       = 1; % Single exposure with probes.
EXPERIMENT_TYPE_ALTERNATING = 2; % Alternating exposure.

ExperimentTypeText = { 'Probe' 'Alternating' };

k = 0;

k = k + 1;
Exp{k}.ExperimentText = 'Context-Dependent Decay';
Exp{k}.ExperimentAbvr = 'CDD';
Exp{k}.ExperimentType = EXPERIMENT_TYPE_PROBE;
Exp{k}.VisualAmbiguousFlag = false;
Exp{k}.ExposureTrialCount = 46;
Exp{k}.ProbeTrialCount = 20;
Exp{k}.ProbeTrialType = TRIAL_TYPE_ERROR_CLAMP;
Exp{k}.ReExposureTrialCount = 18;
Exp{k}.ProbeAngleList = [ 0 22.5 45 90 180 ]; % Relative to Exposure
Exp{k}.ProbeAngleCount = length(Exp{k}.ProbeAngleList);
Exp{k}.ConditionCount = 2;
Exp{k}.ConditionText = { 'E0' 'E180' };
Exp{k}.ConditionExposureAngle = [ 0 180 ];
Exp{k}.ConditionProbeSign = [ -1 +1 ];
Exp{k}.ModelParameters = ETM_ModelParameters{1};

k = k + 1;
Exp{k}.ExperimentText = 'Context-Dependent Adaptation';
Exp{k}.ExperimentAbvr = 'CDA';
Exp{k}.ExperimentType = EXPERIMENT_TYPE_PROBE;
Exp{k}.VisualAmbiguousFlag = false;
Exp{k}.ExposureTrialCount = 46;
Exp{k}.ProbeTrialCount = 8;
Exp{k}.ProbeTrialType = TRIAL_TYPE_ZERO_FORCE;
Exp{k}.ReExposureTrialCount = 18;
Exp{k}.ProbeAngleList = [ 0 22.5 45 90 180 ]; % Relative to Exposure
Exp{k}.ProbeAngleCount = length(Exp{k}.ProbeAngleList);
Exp{k}.ConditionCount = 2;
Exp{k}.ConditionText = { 'E0' 'E180' };
Exp{k}.ConditionExposureAngle = [ 0 180 ];
Exp{k}.ConditionProbeSign = [ -1 +1 ];
Exp{k}.ModelParameters = ETM_ModelParameters{1};

k = k + 1;
Exp{k}.ExperimentText = 'Alternating Dynamics';
Exp{k}.ExperimentAbvr = 'AltDyn';
Exp{k}.ExperimentType = EXPERIMENT_TYPE_ALTERNATING;
Exp{k}.ConditionCount = 1;
Exp{k}.ConditionText = { 'E180/0E' };
Exp{k}.ConditionExposureAngle = [ 180 0 ];
Exp{k}.ConditionExposureBlockCount = 18;
Exp{k}.PostExposureBlockCount = 2;
Exp{k}.BlockTrialCount = 24;
Exp{k}.ModelParameters = ETM_ModelParameters{1};

k = k + 1;
Exp{k}.ExperimentText = 'Opposing vs Orthogonal Dynamics';
Exp{k}.ExperimentAbvr = 'OppVsOrth';
Exp{k}.ExperimentType = EXPERIMENT_TYPE_ALTERNATING;
Exp{k}.ConditionCount = 4;
Exp{k}.ConditionText = { 'Opp/E6' 'Opp/Z6' 'Orth/E6' 'Orth/Z6' };
Exp{k}.ConditionExposureAngle = [ 180 0; 180 0; 180 270; 180 270 ];
Exp{k}.ConditionExposureBlockCount = [ 6 5 6 5 ];
Exp{k}.PostExposureBlockCount = 2;
Exp{k}.BlockTrialCount = 24;
Exp{k}.ModelParameters = ETM_ModelParameters{2};

k = k + 1;
Exp{k}.ExperimentText = 'Vusually Ambiguous Object';
Exp{k}.ExperimentAbvr = 'VisAmb';
Exp{k}.ExperimentType = EXPERIMENT_TYPE_PROBE;
Exp{k}.VisualAmbiguousFlag = true;
Exp{k}.ExposureTrialCount = 46;
Exp{k}.ProbeTrialCount = 20;
Exp{k}.ProbeTrialType = TRIAL_TYPE_ERROR_CLAMP;
Exp{k}.ReExposureTrialCount = 18;
Exp{k}.ProbeAngleList = [ 0 180 ]; % Relative to Exposure
Exp{k}.ProbeAngleCount = length(Exp{k}.ProbeAngleList);
Exp{k}.ConditionCount = 2;
Exp{k}.ConditionText = { 'E0' 'E180' };
Exp{k}.ConditionExposureAngle = [ 0 180 ];
Exp{k}.ConditionProbeSign = [ -1 +1 ];
Exp{k}.ModelParameters = ETM_ModelParameters{2};

k = k + 1;
Exp{k}.ExperimentText = 'Object Lifting';
Exp{k}.ExperimentAbvr = 'ObjLift';
Exp{k}.ExperimentType = EXPERIMENT_TYPE_ALTERNATING;
Exp{k}.ConditionCount = 1;
Exp{k}.ConditionText = { 'CoM-CW/Com-CCW' };
Exp{k}.ConditionExposureAngle = [ 0 180 ];
Exp{k}.ConditionExposureBlockCount = 4;
Exp{k}.PostExposureBlockCount = 0;
Exp{k}.BlockTrialCount = 8;
Exp{k}.ModelParameters = ETM_ModelParameters{3};

ExperimentCount = k;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create paradigm for single-exposure / probe experiments...
for Eindex=1:ExperimentCount
    if( Exp{Eindex}.ExperimentType ~= EXPERIMENT_TYPE_PROBE )
        continue;
    end
    
    for Cindex=1:Exp{Eindex}.ConditionCount
        n = Exp{Eindex}.ExposureTrialCount + Exp{Eindex}.ProbeAngleCount * (Exp{Eindex}.ProbeTrialCount + Exp{Eindex}.ReExposureTrialCount);
        Exp{Eindex}.TrialCount(Cindex) = n;
    
        X = zeros(8,n);
        k = 0;
        
        k0 = k+1;
        k = k + Exp{Eindex}.ExposureTrialCount;
        k1 = k;
        
        TrialType = TRIAL_TYPE_EXPOSURE;
        TrialObjectAngle = Exp{Eindex}.ConditionExposureAngle(Cindex);
        TrialProbeAngle = 0;
        TrialProbeFlag = 0;
        TrialAmbiguous = Exp{Eindex}.VisualAmbiguousFlag;
        TrialBlockCount = 1;
        
        X(1,k0:k1) = TrialType;
        X(2,k0:k1) = degcentre(TrialObjectAngle);
        X(3,k0:k1) = TrialTypePertubation(TrialType);
        X(4,k0:k1) = TrialTypeErrorClamp(TrialType);
        X(5,k0:k1) = TrialProbeAngle;
        X(6,k0:k1) = TrialProbeFlag;
        X(7,k0:k1) = TrialAmbiguous;
        X(8,k0:k1) = TrialBlockCount;
        
        for Pindex=1:Exp{Eindex}.ProbeAngleCount
            k0 = k+1;
            k = k + Exp{Eindex}.ProbeTrialCount;
            k1 = k;
            
            TrialType = Exp{Eindex}.ProbeTrialType;
            TrialObjectAngle = Exp{Eindex}.ConditionExposureAngle(Cindex) + (Exp{Eindex}.ConditionProbeSign(Cindex) * Exp{Eindex}.ProbeAngleList(Pindex));
            TrialProbeAngle = Exp{Eindex}.ProbeAngleList(Pindex);
            TrialProbeFlag = 1;
            TrialAmbiguous = 0;
            TrialBlockCount = TrialBlockCount + 1;
    
            X(1,k0:k1) = TrialType;
            X(2,k0:k1) = degcentre(TrialObjectAngle);
            X(3,k0:k1) = TrialTypePertubation(TrialType);
            X(4,k0:k1) = TrialTypeErrorClamp(TrialType);
            X(5,k0:k1) = TrialProbeAngle;
            X(6,k0:k1) = TrialProbeFlag;
            X(7,k0:k1) = TrialAmbiguous;
            X(8,k0:k1) = TrialBlockCount;
            
            k0 = k+1;
            k = k + Exp{Eindex}.ReExposureTrialCount;
            k1 = k;
            
            TrialType = TRIAL_TYPE_EXPOSURE;
            TrialObjectAngle = Exp{Eindex}.ConditionExposureAngle(Cindex);
            TrialAmbiguous = Exp{Eindex}.VisualAmbiguousFlag;
            TrialBlockCount = TrialBlockCount + 1;

            X(1,k0:k1) = TrialType;
            X(2,k0:k1) = degcentre(TrialObjectAngle);
            X(3,k0:k1) = TrialTypePertubation(TrialType);
            X(4,k0:k1) = TrialTypeErrorClamp(TrialType);
            X(5,k0:k1) = TrialProbeAngle;
            X(6,k0:k1) = TrialProbeFlag;
            X(7,k0:k1) = TrialAmbiguous;
            X(8,k0:k1) = TrialBlockCount;
        end
        
        Exp{Eindex}.ConditionParadigm{Cindex} = X;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create paradigm for alternating exposure experiments...

for Eindex=1:ExperimentCount
    if( Exp{Eindex}.ExperimentType ~= EXPERIMENT_TYPE_ALTERNATING )
        continue;
    end
    
    for Cindex=1:Exp{Eindex}.ConditionCount
        n = (Exp{Eindex}.ConditionExposureBlockCount(Cindex) + Exp{Eindex}.PostExposureBlockCount) * Exp{Eindex}.BlockTrialCount;
        Exp{Eindex}.TrialCount(Cindex) = n;

        X = zeros(8,n);
        k = 0;
        
        TrialBlockCount = 0;
        
        for Bindex=1:Exp{Eindex}.ConditionExposureBlockCount(Cindex)
            TrialBlockCount = TrialBlockCount + 1;
            
            k0 = k+1;
            k = k + Exp{Eindex}.BlockTrialCount;
            k1 = k;
        
            TrialType = TRIAL_TYPE_EXPOSURE;
            TrialObjectAngle = Exp{Eindex}.ConditionExposureAngle(Cindex,1+mod(TrialBlockCount-1,2));
            TrialProbeAngle = 0;
            TrialProbeFlag = 0;
            TrialAmbiguous = 0;

            X(1,k0:k1) = TrialType;
            X(2,k0:k1) = degcentre(TrialObjectAngle);
            X(3,k0:k1) = TrialTypePertubation(TrialType);
            X(4,k0:k1) = TrialTypeErrorClamp(TrialType);
            X(5,k0:k1) = TrialProbeAngle;
            X(6,k0:k1) = TrialProbeFlag;
            X(7,k0:k1) = TrialAmbiguous;
            X(8,k0:k1) = TrialBlockCount;
        end
        
        for Bindex=1:Exp{Eindex}.PostExposureBlockCount
            TrialBlockCount = TrialBlockCount + 1;
            
            k0 = k+1;
            k = k + Exp{Eindex}.BlockTrialCount;
            k1 = k;
        
            TrialType = TRIAL_TYPE_ZERO_FORCE;
            TrialObjectAngle = Exp{Eindex}.ConditionExposureAngle(Cindex,1+mod(TrialBlockCount-1,2));
            TrialProbeAngle = 0;
            TrialProbeFlag = 0;
            TrialAmbiguous = 0;

            X(1,k0:k1) = TrialType;
            X(2,k0:k1) = degcentre(TrialObjectAngle);
            X(3,k0:k1) = TrialTypePertubation(TrialType);
            X(4,k0:k1) = TrialTypeErrorClamp(TrialType);
            X(5,k0:k1) = TrialProbeAngle;
            X(6,k0:k1) = TrialProbeFlag;
            X(7,k0:k1) = TrialAmbiguous;
            X(8,k0:k1) = TrialBlockCount;
        end
        
        Exp{Eindex}.ConditionParadigm{Cindex} = X;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ConditionCount = 0;

for Eindex=1:ExperimentCount
    for Cindex=1:Exp{Eindex}.ConditionCount
        ConditionCount = ConditionCount + 1;
        figure(ConditionCount);
        clf;
        
        n = Exp{Eindex}.TrialCount(Cindex);
        X = Exp{Eindex}.ConditionParadigm{Cindex};
        TrialType           = X(1,1:n);
        TrialObjectAngle    = X(2,1:n);
        TrialPerturbation   = X(3,1:n);
        TrialErrorClamp     = X(4,1:n);
        TrialProbeAngle     = X(5,1:n);
        TrialProbeFlag      = X(6,1:n);
        TrialAmbiguous      = X(7,1:n);
        TrialBlockCount     = X(8,1:n);
        
        x = 1:n;

        pc = 5; % subplots
        pm = pc;
        pn = ceil(pc/pm);
        pp = 0;

        pp = pp + 1;
        subplot(pm,pn,pp);
        y = TrialType;
        plot(x,y,'k.');
        xlabel('Trial');
        ylabel('Trial Type');
        axis([ (min(x)-5) (max(x)+5) (min(TrialTypeList)-0.2) (max(TrialTypeList)+0.2) ]);
        ETM_MarkBlocks(pm,pn,pp,TrialBlockCount); % Mark blocks on plot.
        title(sprintf('Exp=%d,%s Cond=%d,%s',Eindex,Exp{Eindex}.ExperimentAbvr,Cindex,Exp{Eindex}.ConditionText{Cindex}));

        pp = pp + 1;
        H = subplot(pm,pn,pp);
        hold on;
        y = TrialObjectAngle;
        plot(x,y,'k.');
        i = find(TrialAmbiguous == 1);
        plot(x(i),y(i),'ro'); % Mark ambiguous trials
        xlabel('Trial');
        ylabel('Object Angle (deg)');
        axis([ (min(x)-5) (max(x)+5) -200 200 ]);
        set(H,'YTick',-180:90:180);
        ETM_MarkBlocks(pm,pn,pp,TrialBlockCount); % Mark blocks on plot.

        pp = pp + 1;
        subplot(pm,pn,pp);
        y = TrialPerturbation;
        plot(x,y,'k.');
        xlabel('Trial');
        ylabel('Perturbation');
        axis([ (min(x)-5) (max(x)+5) -0.2 1.2 ]);
        ETM_MarkBlocks(pm,pn,pp,TrialBlockCount); % Mark blocks on plot.

        pp = pp + 1;
        subplot(pm,pn,pp);
        y = TrialErrorClamp;
        plot(x,y,'k.');
        xlabel('Trial');
        ylabel('Error-Clamp');
        axis([ (min(x)-5) (max(x)+5) -0.2 1.2 ]);
        ETM_MarkBlocks(pm,pn,pp,TrialBlockCount); % Mark blocks on plot.

        pp = pp + 1;
        H = subplot(pm,pn,pp);
        i = find(TrialProbeFlag == 1); % Only show probes angles
        y = TrialProbeAngle;
        plot(x(i),y(i),'k.');
        xlabel('Trial');
        ylabel('Probe Angle (deg)');
        axis([ (min(x)-5) (max(x)+5) -200 200 ]);
        set(H,'YTick',-180:90:180);
        ETM_MarkBlocks(pm,pn,pp,TrialBlockCount); % Mark blocks on plot.
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pause;
% close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for Eindex=1:ExperimentCount
    for Cindex=1:Exp{Eindex}.ConditionCount
        X = Exp{Eindex}.ConditionParadigm{Cindex};
        F = Exp{Eindex}.ModelParameters;

        [ ErrorMagnitude,TrialOutputMagnitude,x_state ] = ETM_Model(X,F);
        
        Exp{Eindex}.ModelErrorMagnitude{Cindex} = ErrorMagnitude;
        Exp{Eindex}.ModelOutputMagnitude{Cindex} = TrialOutputMagnitude;
        Exp{Eindex}.x_state{Cindex} = x_state;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;

k = 0;

k = k + 1;
Fig{k}.ExperimentList = [ 1 2 ];
Fig{k}.ExperimentCount = length(Fig{k}.ExperimentList);
Fig{k}.SubPlotCount = 4;
Fig{k}.SubPlotRows = 2;
Fig{k}.SubPlotColumns = 2;

k = k + 1;
Fig{k}.ExperimentList = [ 3 ];
Fig{k}.ExperimentCount = length(Fig{k}.ExperimentList);
Fig{k}.SubPlotCount = 2;
Fig{k}.SubPlotRows = 2;
Fig{k}.SubPlotColumns = 1;

k = k + 1;
Fig{k}.ExperimentList = [ 4 ];
Fig{k}.ExperimentCount = length(Fig{k}.ExperimentList);
Fig{k}.SubPlotCount = 4;
Fig{k}.SubPlotRows = 2;
Fig{k}.SubPlotColumns = 2;

k = k + 1;
Fig{k}.ExperimentList = [ 5 ];
Fig{k}.ExperimentCount = length(Fig{k}.ExperimentList);
Fig{k}.SubPlotCount = 4;
Fig{k}.SubPlotRows = 2;
Fig{k}.SubPlotColumns = 2;

k = k + 1;
Fig{k}.ExperimentList = [ 6 ];
Fig{k}.ExperimentCount = length(Fig{k}.ExperimentList);
Fig{k}.SubPlotCount = 2;
Fig{k}.SubPlotRows = 2;
Fig{k}.SubPlotColumns = 1;


FigureCount = k;

% Simply for plotting adaptation on same plots with error.
AdaptOffset = 0.6;
AdaptGain = 0.4;

Fcount = 0;

for Findex=1:FigureCount
    pc = Fig{Findex}.SubPlotCount;
    pm = Fig{Findex}.SubPlotRows;
    pn = Fig{Findex}.SubPlotColumns;
    pp = 0;
    
    for i=1:Fig{Findex}.ExperimentCount
        Eindex = Fig{Findex}.ExperimentList(i);
        
        for Cindex=1:Exp{Eindex}.ConditionCount
            if( (pp == 0) || (pp == pc) )
                Fcount = Fcount + 1;
                figure(Fcount);
                clf;
                
                pp = 0;
            end
    
            n = Exp{Eindex}.TrialCount(Cindex);
            X = Exp{Eindex}.ConditionParadigm{Cindex};
            
            TrialType           = X(1,1:n);
            TrialObjectAngle    = X(2,1:n);
            TrialPerturbation   = X(3,1:n);
            TrialErrorClamp     = X(4,1:n);
            TrialProbeAngle     = X(5,1:n);
            TrialProbeFlag      = X(6,1:n);
            TrialAmbiguous      = X(7,1:n);
            TrialBlockCount     = X(8,1:n);
            
            ProbeAdaptationFlag = any((TrialErrorClamp == 1) & (TrialProbeFlag == 1));
            
            pp = pp + 1;
            H = subplot(pm,pn,pp);
            hold on;
            
            x = 1:n;
            y1 = Exp{Eindex}.ModelErrorMagnitude{Cindex};
            y2 = Exp{Eindex}.ModelOutputMagnitude{Cindex};
            plot(x,y1,'r.-');
            xlabel('Trial');
            if( ProbeAdaptationFlag )
                ylabel('Error (red) / Adaptation (blue)');
            else
                ylabel('Error (red)');
            end
            axis([ (min(x)-5) (max(x)+5) -0.1 1.2 ]);
            ETM_MarkBlocks(pm,pn,pp,TrialBlockCount,TrialType,TrialObjectAngle); % Mark blocks on plot.
            title(sprintf('Exp=%d;%s Cond=%d;%s',Eindex,Exp{Eindex}.ExperimentAbvr,Cindex,Exp{Eindex}.ConditionText{Cindex}));
            
            if( ProbeAdaptationFlag )
                ProbeAngleList = unique(TrialProbeAngle);
                ProbeAngleCount = length(ProbeAngleList);
                
                for ProbeAngleIndex=1:ProbeAngleCount
                    k = find((TrialErrorClamp == 1) & (TrialProbeFlag == 1) & (TrialProbeAngle == ProbeAngleList(ProbeAngleIndex)));
                    plot(x(k),AdaptOffset+(AdaptGain*y2(k)),'b.-');
                end
            end
            
            pp = pp + 1;
            H = subplot(pm,pn,pp);
            hold on;
            
            x_state = Exp{Eindex}.x_state{Cindex};
            ModuleCount = Exp{Eindex}.ModelParameters.ModuleCount;
            ModuleAngleList = Exp{Eindex}.ModelParameters.ModuleAngleList;
            
            if( ModuleCount == 2 )
                xy = x_state;
                ytick = 1:ModuleCount;
                yticklabel = ModuleAngleList;
            else
                xy = zeros(ModuleCount+1,n);
                xy(1:ModuleCount,:) = x_state;
                xy(ModuleCount+1,:) = x_state(1,:);
                ytick = linspace(1,ModuleCount+1,5);
                yticklabel = linspace(-180,180,5);
            end
            
            imagesc(xy);
            axis([ (min(x)-5) (max(x)+5) (min(ytick)-0.5) (max(ytick)+0.5) ]);
            ETM_MarkBlocks(pm,pn,pp,TrialBlockCount); % Mark blocks on plot.
            set(H,'YTick',ytick);
            set(H,'YTickLabel',yticklabel);
            xlabel('Trial');
            ylabel('Module Angle (deg)');
            title(sprintf('Exp%d/Cond%d Adaptive States',Eindex,Cindex));
        end        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
