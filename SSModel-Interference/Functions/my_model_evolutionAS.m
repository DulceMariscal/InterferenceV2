function [z, e, X, varargout] = my_model_evolution(model, k, input, x0, varargin)
varargout{1} = [];
if ~isempty(varargin)
   sigmaNE = varargin{1};
   maxPA = varargin{2};
end

switch model
    case 1
        [z, e, X] = SM2006_evolve(k, input , x0);
    case 2
        [z, e, X] = SSIM_evolve1(k, input , x0);
    case 3
        [z, e, X] = ETM_evolve(k, input , x0);
    case 4
        [z, e, X] = SSIM_evolve2(k, input , x0); %No Slow Facilitation
    case 5
        [z, e, X] = SSIM_evolve3(k, input , x0); %FACILITATION ALSO IN THE FAST STATE 
    case 6
        [z, e, X] = SSIM_evolve4(k, input , x0); %MULTIPLICATIVE INTERFERENCE
    case 7
        [z, e, X] = SSIM_evolve5(k, input , x0); %ADDITIVE INTERFERENCE - NOT PROPORTIONAL TO THE ERROR in the slow state                                            %In the slow state
    case 8
        [z, e, X] = SSIM_evolve6(k, input , x0); %TIME VARIANT STUFF
    case 9
        [z, e, X] = ETM_evolve2(k, input , x0); %Alpha 180 fixed to 1 - DO NOT USE THIS!
    case 10
        [z, e, X] = SSIM_evolve_gtuning(k, input , x0);
    case 11
        [z, e, X] = SSIM_evolve_gtuning_sigmaf_fixed(k, input , x0);
    case 12
        [z, e, X] = SSIM_evolve_ISE(k, input , x0, sigmaNE);
    case 13
        [z, e, X] = SSIM_evolve_ISE2(k, input , x0, sigmaNE); %Here the number of standard deviations is fitted
    case 14
        [z, e, X, Xadd] = SSIM_evolve_lisu(k, input , x0); %Linear summation
        varargout{1} = Xadd;
    case 15
        [z, e, X, Xadd] = SSIM_evolve_lisu_tv(k, input , x0); %Linear summation with time variant activation of primitives
        varargout{1} = Xadd;
    case 16
        [z, e, X] = SSIM_evolve_lisu_6s(k, input , x0); %Linear summation 6 states
    case 17
         [z, e, X] = SSIM_evolve_CWSS_ISE_Naive(k, input , x0, sigmaNE); %Ignore Small errors + Constant weighting of error in the slow state
    case 18
        [z, e, X, Xadd] = SSIM_evolve_CWSS_ISE(k, input , x0, sigmaNE); %Ignore Small errors + Constant weighting of error in the slow state
        varargout{1} = Xadd;
    case 19
        [z, e, X, Xadd] = SSIM_evolve_CWSS_ISE_BIAS(k, input , x0, sigmaNE); %Ignore Small errors + Constant weighting of error in the slow state
        varargout{1} = Xadd;
    case 20
        [z, e, X] = SSIM_evolve_lisu_5s(k, input , x0, maxPA); %Linear summation 5 states
    case 21
        [z, e, X, Xadd] = SSIM_evolve_lisu_5s_ISE(k, input , x0, sigmaNE, maxPA); %Linear summation 5 states
        varargout{1} = Xadd;
    case 22
        [z, e, X, Xadd] = SSIM_evolve_lisu_5s_ISE_BIAS(k, input , x0, sigmaNE, maxPA); %Linear summation 5 states
        varargout{1} = Xadd;
    case 23
        [z, e, X, Xadd] = SSIM_evolve_lisu_5s_ISE_CWSS(k, input , x0, sigmaNE, maxPA); %Linear summation 5 states
        varargout{1} = Xadd;

end


end
