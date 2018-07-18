%least_square
function SSresid = two_state_lsq2(k , data , x0, input, model, varargin)
% Input is equal to "Perturbation" for SM2006 and SSIM models
% is equal to "Ideal motor output" for ETM
if ~isempty(varargin)
    sigmaNE = varargin{1};
end
[nexps, nt] = size(data);
SSresid=0;

for exp = 1:nexps
    x_meas = data(exp,:);
    cinput   = squeeze(input(exp,:,:));
    indok  = ~isnan(x_meas);
    
    switch model
        case 1
            x = SM2006_evolve(k, cinput , x0);
        case 2
            x = SSIM_evolve1(k, cinput , x0);
        case 3
            x_meas = [zeros(1,nt); x_meas]; %Including X coordinate
            x = ETM_evolve(k, cinput , x0);
        case 4
            x = SSIM_evolve2(k, cinput , x0); %NO SLOW FACILITATION
        case 5
            x = SSIM_evolve3(k, cinput , x0); %FACILITATION ALSO IN THE FAST STATE
        case 6
            x = SSIM_evolve4(k, cinput , x0); %MULTIPLICATIVE INTERFERENCE
            
        case 7 %This is currently the best model
            x = SSIM_evolve5(k, cinput , x0); %FACILITATION AND INTERFERENCE IN THE SLOW STATE ARE NOT PROPORTIONAL TO THE ERROR
            
        case 8
            x = SSIM_evolve6(k, cinput , x0); %TIME VARIANT STUFF
            
        case 9
            x_meas = [zeros(1,nt); x_meas]; %Including X coordinate
            x = ETM_evolve2(k, cinput , x0); %Alpha 180 fixed to 1
        case 10
            x = SSIM_evolve_gtuning(k, cinput , x0);
        case 11
            x = SSIM_evolve_gtuning_sigmaf_fixed(k, cinput , x0);
        case 12
            x = SSIM_evolve_ISE(k, cinput , x0, sigmaNE); %Here the number of std is fixed to a certai value (eg 5)
        case 13
            x = SSIM_evolve_ISE2(k, cinput , x0, sigmaNE); %Here the number of standard deviations is fitted
        case 14
            x = SSIM_evolve_lisu(k, cinput , x0); %Linear summation
        case 15
            x = SSIM_evolve_lisu_tv(k, cinput , x0); %Linear summation
        case 16
            x = SSIM_evolve_lisu_6s(k, cinput , x0); %Linear summation 6 states
        case 17
            x = SSIM_evolve_CWSS_ISE_Naive(k, cinput , x0, sigmaNE); %Ignore Small errors + Constant weighting of error in the slow state
        case 18
            x = SSIM_evolve_CWSS_ISE(k, cinput , x0, sigmaNE); %Ignore Small errors + Constant weighting of error in the slow state
        case 19
            x = SSIM_evolve_CWSS_ISE_BIAS(k, cinput , x0, sigmaNE); %Ignore Small errors + Constant weighting of error in the slow state
        case 20
            x = SSIM_evolve_lisu_6s_ISE(k, cinput , x0, sigmaNE); %Ignore Small errors + Linear summation 6 states
        case 21
            x = SSIM_evolve_lisu_5s(k, cinput , x0); %Linear summation 5 states
        case 22
            x = SSIM_evolve_lisu_5sNew(k, cinput , x0); %Linear summation 5 states contrained
        case 23
            x = SSIM_evolve_lisu_5s_noFac(k, cinput , x0); %Linear summation 5 states no fac in slow
        case 24
            x = SSIM_evolve_lisu_5s(k, cinput , x0); %Linear summation 5 states
        case 25
            x = SSIM_evolve_lisu_5sOld(k, cinput , x0); %Linear summation 5 states
        case 26
            x = SSIM_evolve_lisu_5s_gtunning(k, cinput , x0); %Linear summation 5 states
        case 27
            x = SSIM_evolve_lisu_5s_gtuningOff(k, cinput , x0); %Linear summation 5 states
        case 28
            x = SSIM_evolve_lisu_5s_gtuningfixed(k, cinput , x0); %Linear summation 5 states
        case 29
            x = SSIM_evolve_lisu_5s_sigm(k, cinput , x0); %Linear summation 5 states
        case 30
            x = SSIM_evolve_lisu_5s_DM(k, cinput , x0); %Linear summation 5 states
        case 31
            x = SSIM_evolve_lisu_4s_DM(k, cinput , x0); %Linear summation 5 states
        case 32
            x = SSIM_evolve_lisu_3s(k, input , x0); %%Linear summation 3 states
        case 33
            x = SSIM_evolve_lisu_4s(k, input , x0); %Linear summation 5 states
        case 34
            x = SSIM_evolve_lisu_4s_body(k, input , x0); %Linear summation 5 states
        case 35
            x = SSIM_evolve_lisu_4s_DMV2(k, cinput , x0); %Linear summation 5 states
        case 36
            x = SSIM_evolve_lisu_4s_DM_body(k, input , x0); %Same as GTO  SSIM_evolve_lisu_4s_body
            
    end
    SSresid = SSresid + sum(sum((x(:,indok)-x_meas(:,indok)).^2));
    
end

end