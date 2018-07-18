function modParams = initializeModParams(perturbations,nt,ng,nconds)

%% Model-specific Initializations
%% SM2006-------------------------------------------------------------------
cmod = 1;
npars = 4;
nstates = 2;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SM2006';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = ones(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 -1 0; 0 -1 0 1; 0 0 0 0; 0 0 0 0];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--'}; %States line specs
modParams(cmod).colors = {nan,nan};%States colors
modParams(cmod).lw = [nan nan]; %Line width
modParams(cmod).parNames = {'a_f','b_f','a_s','b_s'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM---------------------------------------------------------------------
cmod = 2;
npars = 9;
nstates = 4;
ncond = 5;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 =  zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1  0  0 -1  0 0 0  0 0 ;... af<as
                         0  0  0  1  0 0 0 -1 0;... as<aet
                         0 -1  0  0  1 0 0  0 0;... bf>bs
                         0  0  0  0 -1 0 0  0 1;... bs>bet
                         0  0 -1  0  0 1 0  0 0;... bsFac < bfFac
                        zeros(npars-ncond,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
                            'b_{s}^{int}','a_{et}','b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% ETM---------------------------------------------------------------------
cmod = 3;
npars = 8;
nstates = 2;
ncoo = 2; %Number of coordinates
modParams(cmod).name = 'ETM';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [];
modParams(cmod).bcond = [];
modParams(cmod).input = permute(cat(3,[zeros(1,nt); perturbations(1,:)], [zeros(1,nt); perturbations(2,:)]),[3 2 1]);
%Group X Strides X Coordinates(x or y)
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{90}','x^{-90}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 2;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {'-.','-.'}; %States line specs
modParams(cmod).colors = {[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [4 4]; %Line width
modParams(cmod).parNames = {'\alpha_0','\alpha_{180}', '\beta_0','\beta_{180}','c_{180}', 'AA' ,'BA', 'CA'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};


%% SSIM, no Slow Facilitation-----------------------------------------------
%It is even worse than Smith 2006 in terms of BIC
cmod = 4;
npars = 8;
nstates = 4;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM-NSF';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 0 -1 0 0  0 0;...
    0 0 0  1 0 0 -1 0;...
    0 -1 0 0 1 0  0 0;...
    0 0 0 0 -1 0  0 1;...
    zeros(4,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s',...
    'b_{s}^{int}','a_{et}','b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM, with interference also in the fast state---------------------------
cmod = 5;
npars = 10;
nstates = 4;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM-FSF';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1  0 0 0 -1  0 0 0  0  0;... af<as
    0  0 0 0  1  0 0 0 -1  0;... as<aet
    0 -1 0 0  0  1 0 0  0  0;... bf>bs
    0  0 0 0  0 -1 0 0  0  1;... bs>bet
    zeros(6,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','b_{f}^{int}','a_s','b_s','b_{s}^{fac}',...
    'b_{s}^{int}','a_{et}','b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM, with MULTIPLICATIVE interference in the slow state (instead of additive)---------------------------
cmod = 6;
npars = 9;
nstates = 4;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0;... af<as
                        0 0 0 1 0 0 0 -1 0;... as<aet
                        0 -1 0 0 1 0 0 0 0;... bf>bs
                        0 0 0 0 -1 0 0 0 1;... bs>bet
                        zeros(5,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
                            'b_{s}^{int}','a_{et}','b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM - FACILITATION AND INTERFERENCE NOT PROPORTIONAL TO THE ERROR IN THE SLOW STATE
cmod = 7;
npars = 9;
nstates = 4;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - CWSS'; %Constant weighting in the slow state
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0;... af<as
                        0 0 0 1 0 0 0 -1 0;... as<aet
                        0 -1 0 0 1 0 0 0 0;... bf>bs
                        0 0 0 0 -1 0 0 0 1;... bs>bet
                        zeros(5,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
    'b_{s}^{int}','a_{et}','b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM - TIME VARIANT STUFF
cmod = 8;
npars = 11;
nstates = 4;
ncoo = 1; %Number of coordinates
nconstr = 4;
modParams(cmod).name = 'SSIM - TV';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = [zeros(1,npars-1)  eps];
modParams(cmod).klb = [zeros(1,npars-1) eps];
modParams(cmod).kub = [ones(1,npars-1) 1000];
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0 0 0;... af<as
                        0 0 0 1 0 0 0 -1 0 0 0;... as<aet
                        0 -1 0 0 1 0 0 0 0 0 0;... bf>bs
                        0 0 0 0 -1 0 0 0 1 0 0;... bs>bet
                        zeros(npars-nconstr,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
    'b_{s}^{int}','a_{et}','b_{et}','NS1','NS2'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% ETM with alpha180 fixed to 1 (i.e. decay of non-engaged primitive)------
cmod = 9;
npars = 4;
nstates = 2;
ncoo = 2; %Number of coordinates
modParams(cmod).name = 'ETM';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars) + 0.5;
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [];
modParams(cmod).bcond = [];
modParams(cmod).input = permute(cat(3,[zeros(1,nt); perturbations(1,:)], [zeros(1,nt); perturbations(2,:)]),[3 2 1]);
%Group X Strides X Coordinates(x or y)
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{90}','x^{-90}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 2;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {'-.','-.'}; %States line specs
modParams(cmod).colors = {[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [4 4]; %Line width
modParams(cmod).parNames = {'alpha_0', 'beta_0','beta_{180}','c_{180}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM G tuning
cmod = 10;
npars = 10;
nstates = 4;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - G_{TUN}';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 0 0 -1  0 0 0  0 0;... af<as
                        0  0 0 0  1  0 0 0 -1 0;... as<aet
                        0 -1 0 0  0  1 0 0  0 0;... bf>bs
                        0  0 0 0  0 -1 0 0  0 1;... bs>bet
                        zeros(6,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','peak_{f}','std_{f}','a_s','b_s','peak_{s}','std_{s}',...
                            'a_{et}','b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM G tuning - sigmaFast fixed
cmod = 11;
npars = 9;
nstates = 4;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - G_{TUN}^{\sigma_f}';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 0  -1  0 0 0  0 0;... af<as
                        0  0 0   1  0 0 0 -1 0;... as<aet
                        0 -1 0   0  1 0 0  0 0;... bf>bs
                        0  0 0   0 -1 0 0  0 1;... bs>bet
                        zeros(npars-4,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','peak_{f}','a_s','b_s','peak_{s}','std_{s}',...
                            'a_{et}','b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM - Ignore Errors in natural range (Withing 5STD)----------------------------------
cmod = 12;
npars = 9;
nstates = 4;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - ISE'; %Ignore Small Errors
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0;... af<as
                        0 0 0 1 0 0 0 -1 0;... as<aet
                        0 -1 0 0 1 0 0 0 0;... bf>bs
                        0 0 0 0 -1 0 0 0 1;... bs>bet
                        zeros(5,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
                            'b_{s}^{int}','a_{et}','b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM - Ignore Errors in natural range (Fit the number of STD)-----------
cmod = 13;
npars = 10;
nstates = 4;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - ISE2'; %Ignore Small Errors
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = [ones(1,npars-1) 100];
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0 0;... af<as
                         0 0 0 1 0 0 0 -1 0 0;... as<aet
                         0 -1 0 0 1 0 0 0 0 0;... bf>bs
                         0 0 0 0 -1 0 0 0 1 0;... bs>bet
                        zeros(npars-4,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
                            'b_{s}^{int}','a_{et}','b_{et}','NSTD'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM - LISU
cmod = 14;
npars = 9;
nstates = 4;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - LiSu'; %Constant weighting in the slow state
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0;... af<as
                        0 0 0 1 0 0 0 -1 0;... as<aet
                        0 -1 0 0 1 0 0 0 0;... bf>bs
                        0 0 0 0 -1 0 0 0 1;... bs>bet
                        zeros(5,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
    'b_{s}^{int}','a_{et}','b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {'x_{fa}','x_{sa}'};

%% SSIM - LISU TIME VARIANT

cmod = 15;
npars = 11;
nstates = 4;
ncoo = 1; %Number of coordinates
nconstr = 5;
modParams(cmod).name = 'SSIM - TV';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 =  [zeros(1,npars-2) eps  eps];
modParams(cmod).klb = [zeros(1,npars-2) eps  eps];
modParams(cmod).kub = [ones(1,npars-1) 1000];
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0 0 0;...  af<as
                        0 0 0 1 0 0 0 -1 0 0 0;...   as<aet
                        0 -1 0 0 1 0 0 0 0 0 0;...   bf>bs
                        0 0 0 0 -1 0 0 0 10 0 0;...  bs>bet
                        0 0 0 0 0 0  0  0 0 1 -1;... NS1<NS2
                        zeros(npars-nconstr,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
                            'b_{s}^{int}','a_{et}','b_{et}','NS1','NS2'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states 
modParams(cmod).avDescr = {'x_{fa}','x_{sa}','w_{fa}','w_{sa}'};

%% SSIM - 6s Model with six states
cmod = 16;
npars = 9;
nstates = 6;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - 6S'; %Constant weighting in the slow state
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0;... af<as
                        0 0 0 1 0 0 0 -1 0;...  as<aet
                        0 -1 0 0 1 0 0 0 0;...  bf>bs
                        0 0 0 0 -1 0 0 0 1;...  bs>bet
                        zeros(5,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}','x^{fa}','x^{sa}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.',':','--'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan nan 4 4 nan nan]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
                            'b_{s}^{int}','a_{et}','b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM - CWS+ISE Constant Weighting of Errors in the slow state + Ignore Errors in natural range (Fit the number of STD)-----------
cmod = 17;
npars = 10;
nstates = 4;
ncoo = 1;   %Number of coordinates
modParams(cmod).name = 'SSIM - ISE + CWSS (Naive)'; %Ignore Small Errors
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = [ones(1,npars-1) 100];
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0 0;... af<as
                         0 0 0 1 0 0 0 -1 0 0;... as<aet
                         0 -1 0 0 1 0 0 0 0 0;... bf>bs
                         0 0 0 0 -1 0 0 0 1 0;... bs>bet
                        zeros(npars-4,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
                            'b_{s}^{int}','a_{et}','b_{et}','NSTD'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM - CWS+ISE Constant Weighting of Errors in the slow state + Ignore Errors in natural range (Fit the number of STD) + Use probability (instead of threshold) to update primitives-----------
cmod = 18;
npars = 12;
nstates = 4;
ncoo = 1;   %Number of coordinates
modParams(cmod).name = 'SSIM - ISE + CWSS'; %Ignore Small Errors
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = [zeros(1,npars-1) 10];
modParams(cmod).kub = [ones(1,npars-1) 100];
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0 0 0 0;... af<as
                         0 0 0 1 0 0 0 -1 0 0 0 0;... as<aet
                         0 -1 0 0 1 0 0 0 0 0 0 0;... bf>bs
                         0 0 0 0 -1 0 0 0 1 0 0 0;... bs>bet
                         0  0 -1  0  0  1 0  0 0 0 0 0;... bsFac < bfFac/10 At least one order of magnitude smaller
                        zeros(npars-5,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
                            'b_{s}^{int}','a_{et}','b_{et}','NSTD'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM - CWS+ISE Constant Weighting of Errors in the slow state + Ignore Errors in natural range (Fit the number of STD) + Use probability (instead of threshold) to update primitives-----------
% On the slow state there is only bias
cmod = 19;
npars = 9;
nstates = 4;
ncoo = 1;   %Number of coordinates
modParams(cmod).name = 'SSIM - ISE + CWSS + BIAS'; %Ignore Small Errors
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = [zeros(1,npars-1) 35];
modParams(cmod).kub = [ones(1,npars-1) 100];
modParams(cmod).Acond = [1 0 0 -1 0 0  0 0 0 ;... af<as
                         0 0 0 1 0 0  -1 0 0 ;... as<aet
                         0 -1 0 0 1 0  0 0 0 ;... bf>bs
                         0 0 0 0 -1 0  0 1 0 ;... bs>bet
                         0  0 -1  0  0  1   0 0 0;... bsFac < bfFac/10 At least one order of magnitude smaller
                        zeros(npars-5,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{f}','x^{s}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556]};%States colors
modParams(cmod).lw = [nan nan 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
                            'a_{et}','b_{et}','NSTD'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM - 56s Model with five states and 9 parameters
%[ab,bb,af,bfet,as,bset,bsint,aet,bet] = kcell{:};

cmod = 20;
npars = 9;
nstates = 5;
ncoo = 1; %Number of coordinates
nconstr = 4;
modParams(cmod).name = 'SSIM - 5S'; %Constant weighting in the slow state
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
%% Bigger variable has to have  a "-1"
modParams(cmod).Acond = [0  0  1 0 -1 0 0    0  0 ;...   af<as
                         0  0  0 0  1 0 0   -1  0 ;...   as<aet
                         1  0  0 0  0 0 0   -1  0 ;...  ab<aet
                         0 -1  0 0   0 0 0    0  1   ;...  bb>bet
                        zeros(npars-nconstr,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{b}','x^{pe}','x^{ne}','x^{fa}','x^{sa}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','-.','-.',':','--'}; %States line specs
modParams(cmod).colors = {nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan 4 4 nan nan]; %Line width
modParams(cmod).parNames = {'a_b', 'b_b', 'a_f', ...
                            'b_{f}^{fac}', 'a_s', 'b_{s}^{fac}',...
                            'b_{s}^{int}', 'a_{et}', 'b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM - 56s Model with five states and 10 parameters
%[ab,bb,af,bfet,as,bset,bsint,aet,bet] = kcell{:};

cmod = 21;
npars = 10;
nstates = 5;
ncoo = 1; %Number of coordinates
nconstr = 4;
modParams(cmod).name = 'SSIM - 5S - ISE'; 
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = [zeros(1,npars-1) 40];
modParams(cmod).kub = [ones(1,npars-1) 100];
%% Bigger parameter has to have  a "-1"
modParams(cmod).Acond = [0  0  1 0 -1 0 0    0  0 0;...    af<as
                         0  0  0 0  1 0 0   -1  0 0 ;...   as<aet
                         1  0  0 0  0 0 0   -1  0 0 ;...   ab<aet
                         0 -1  0 0  0 0 0    0  1 0  ;...  bb>bet
                        zeros(npars-nconstr,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{b}','x^{pe}','x^{ne}','x^{fa}','x^{sa}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','-.','-.',':','--'}; %States line specs
modParams(cmod).colors = {nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan 4 4 nan nan]; %Line width
modParams(cmod).parNames = {'a_b', 'b_b', 'a_f', ...
                            'b_{f}^{fac}', 'a_s', 'b_{s}^{fac}',...
                            'b_{s}^{int}', 'a_{et}', 'b_{et}','nSTD'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states 
modParams(cmod).avDescr = {};


%% SSIM - 56s Model with five states and 9 parameters BIAS
%[ab,bb,af,bfet,as,bset,bsint,aet,bet] = kcell{:};

cmod = 22;
npars = 9;
nstates = 5;
ncoo = 1; %Number of coordinates
nconstr = 4;
modParams(cmod).name = 'SSIM - 5S - ISE - BIAS'; 
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = [zeros(1,npars-1) 35];
modParams(cmod).kub = [ones(1,npars-1) 100];
%% Bigger parameter has to have  a "-1"
modParams(cmod).Acond = [0  0  1 0 -1 0   0  0 0;...    af<as
                         0  0  0 0  1 0  -1  0 0 ;...   as<aet
                         1  0  0 0  0 0  -1  0 0 ;...   ab<aet
                         0 -1  0 0  0 0   0  1 0  ;...  bb>bet
                        zeros(npars-nconstr,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{b}','x^{pe}','x^{ne}','x^{fa}','x^{sa}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','-.','-.',':','--'}; %States line specs
modParams(cmod).colors = {nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan 4 4 nan nan]; %Line width
modParams(cmod).parNames = {'a_b', 'b_b', 'a_f', ...
                            'b_{f}^{fac}', 'a_s', 'b_{s}^{fac}',...
                            'a_{et}', 'b_{et}','nSTD'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

%% SSIM - 56s Model with five states and 10 parameters
%[ab,bb,af,bfet,as,bset,bsint,aet,bet] = kcell{:};

cmod = 23;
npars = 10;
nstates = 5;
ncoo = 1; %Number of coordinates
nconstr = 4;
modParams(cmod).name = 'SSIM - 5S - ISE - CWSS'; 
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = [zeros(1,npars-1) 40];
modParams(cmod).kub = [ones(1,npars-1) 100];
%% Bigger parameter has to have  a "-1"
modParams(cmod).Acond = [0  0  1 0 -1 0 0    0  0 0;...    af<as
                         0  0  0 0  1 0 0   -1  0 0 ;...   as<aet
                         1  0  0 0  0 0 0   -1  0 0 ;...   ab<aet
                         0 -1  0 0  0 0 0    0  1 0  ;...  bb>bet
                        zeros(npars-nconstr,npars)];
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{b}','x^{pe}','x^{ne}','x^{fa}','x^{sa}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','-.','-.',':','--'}; %States line specs
modParams(cmod).colors = {nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan 4 4 nan nan]; %Line width
modParams(cmod).parNames = {'a_b', 'b_b', 'a_f', ...
                            'b_{f}^{fac}', 'a_s', 'b_{s}^{fac}',...
                            'b_{s}^{int}', 'a_{et}', 'b_{et}','nSTD'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states 
modParams(cmod).avDescr = {};

end