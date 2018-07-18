function [ TrialErrorMagnitude,TrialOutputMagnitude,x_state ] = ETM_Model(X,F)
% function [ TrialErrorMagnitude,TrialOutputMagnitude,x_state ] = ETM_Model(X,F)
% Implement Error-Tuned Model (ETM) from Ingram et al (2017) PLoS Comp Biol

    TrialCount = size(X,2);

    % Extract trial variables for paradigm (X).
    TrialType           = X(1,:);
    TrialObjectAngle    = X(2,:);
    TrialPerturbation   = X(3,:);
    TrialErrorClamp     = X(4,:);
    TrialProbeAngle     = X(5,:);
    TrialProbeFlag      = X(6,:);
    TrialAmbiguous      = X(7,:);
    TrialBlockCount     = X(8,:);
    
    % Is this a visually ambiguous experiment?
    VisuallyAmbiguousFlag = any(TrialAmbiguous);
    
    % Model pamameters for retention-factor (decay) tuning function.
    A0    = F.A0;
    A180  = F.A180;
    Awid  = F.Awid;
    
    % Model pamameters for learning-rate tuning function.
    B0    = F.B0;
    B180  = F.B180;
    Bwid  = F.Bwid;

    % Model pamameters for output tuning function.
    X0    = F.X0;
    X180  = F.X180;
    Xwid  = F.Xwid;
    
    % Initial adaptation state on first trial (usually zero).
    InitialAdaptation = F.InitialAdaptation;

    % Module count and angle list (for module output).
    ModuleCount = F.ModuleCount;
    ModuleAngleList = F.ModuleAngleList;
    
    % Get model parameters for visually ambiguous object (if required).
    if( VisuallyAmbiguousFlag )
        Aamb = F.Aamb;
        Bamb = F.Bamb;
        Xamb = F.Xamb;
    end

    % These vectors determine the output for each module.
    ModuleVector(1,:) = sin(D2R(ModuleAngleList));
    ModuleVector(2,:) = cos(D2R(ModuleAngleList));
  
    % Module adaptive state across trials.
    x_state = zeros(ModuleCount,TrialCount);
    x_state(:,1) = InitialAdaptation; % Initial adaptation in first trial.
        
    % The output of the module (2D vector and magnitude) across trials.
    TrialOutputVector = zeros(2,TrialCount);
    TrialOutputMagnitude = zeros(1,TrialCount);
        
    % The error (magnitude and angle) across trials.
    TrialErrorMagnitude = zeros(1,TrialCount);
    TrialErrorAngle = zeros(1,TrialCount);
    
    % Loop across trials, simulating model.
    for n=1:TrialCount
        % Object angle on current trial (n);
        ObjectAngle = TrialObjectAngle(n);
        
        % Calculate the 3 tuning vectors.
        if( ~TrialAmbiguous(n) )
            % Gaussian tuning is a function of current object angle.
            AlphaTuningVector  = GaussianTuningFunction(ModuleAngleList,Awid,A0,A180,ObjectAngle);
            BetaTuningVector   = GaussianTuningFunction(ModuleAngleList,Bwid,B0,B180,ObjectAngle);
            OutputTuningVector = GaussianTuningFunction(ModuleAngleList,Xwid,X0,X180,ObjectAngle);
        else
            % Fixed value across all modules if visually ambiguous.
            AlphaTuningVector  = Aamb * ones(1,ModuleCount);
            BetaTuningVector   = Bamb * ones(1,ModuleCount);
            OutputTuningVector = Xamb * ones(1,ModuleCount);
        end
        
        % Output vector for each module.
        ModuleOutputVector = zeros(2,ModuleCount);
        for i=1:ModuleCount
            % Module vector output weighted by current adaptive state.
            ModuleOutputVector(:,i) = x_state(i,n) * ModuleVector(:,i);
        end
        
        % Output on current trial is the vector sum of module output 
        % weighted by the tuning function.
        for i=1:2
            OutputVector(i) = OutputTuningVector * ModuleOutputVector(i,:)';
        end
        
        % Magnitude of the output on the current trial.
        OutputMagnitude = sqrt((OutputVector(1)^2)+(OutputVector(2)^2));
        
        % Initialise the following to zero.
        PerturbationVector = zeros(2,1); % Vector for current perturbation.
        ErrorVector = zeros(2,1);        % Vector for current error.
        ErrorMagnitude = 0;              % Magnitude of current error.
        ErrorAngle = 0;                  % Angle of current error.
        
        % If current trial is not an error-clamp, calculate the following.
        if( ~TrialErrorClamp(n) )
            % The pertrubation vector is given by the value of the 
            % perturbation on the current trial and the object angle.
            PerturbationVector = TrialPerturbation(n) * [ sin(D2R(ObjectAngle)) cos(D2R(ObjectAngle)) ];
            
            % The error vector is the different between the perturbation
            % vector and the output vector.
            ErrorVector = PerturbationVector - OutputVector;
            
            % Calculate magnitude and angle for current error.
            ErrorMagnitude = sqrt((ErrorVector(1)^2)+(ErrorVector(2)^2));
            ErrorAngle = rad2deg(atan2(ErrorVector(1),ErrorVector(2)));
        end
        
        % Put current values into trial series matrices.
        TrialOutputVector(:,n) = OutputVector;
        TrialOutputMagnitude(:,n) = OutputMagnitude;
        TrialErrorMagnitude(n) = ErrorMagnitude;
        TrialErrorAngle(n) = ErrorAngle;
     
        % If we're on the last trial, we're done.
        if( n == TrialCount )
            break;
        end
        
        % Calculate the state update for each module based on the cosine 
        % of the angle of the current error.
        ErrorUpdateVector = zeros(1,ModuleCount);
        for i=1:ModuleCount
            ErrorUpdateVector(i) = ErrorMagnitude * cos(D2R(ModuleAngleList(i)-ErrorAngle));
        end
        
        % The state on the next trial (n+1) is the decayed states from the
        % the current trial (based on the retention factor Alpha) plus the 
        % cosine error term (weighted by the learning-rate Beta).
        x_state(:,n+1) = (AlphaTuningVector' .* x_state(:,n)) + (BetaTuningVector .* ErrorUpdateVector)';
        
        % Don't let any states go below zero.
        i = find(x_state(:,n+1) < 0);
        x_state(i,n+1) = 0;
    end 
end

