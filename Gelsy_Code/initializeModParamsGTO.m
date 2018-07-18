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
modParams(cmod).klb = zeros(1,npars);
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
modParams(cmod).klb = zeros(1,npars);
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
%% SSIM - 6s - ISE Model with six states
cmod = 20;
npars = 10;
nstates = 6;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - 6S -ISE'; %Constant weighting in the slow state
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0 0;... af<as
                        0 0 0 1 0 0 0 -1 0 0;...  as<aet
                        0 -1 0 0 1 0 0 0 0 0;...  bf>bs
                        0 0 0 0 -1 0 0 0 1 0;...  bs>bet
                        zeros(npars-4,npars)];
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
                            'b_{s}^{int}','a_{et}','b_{et}','NSTD'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states 
modParams(cmod).avDescr = {};
%% SSIM - 5s Model with five states
cmod = 21;
npars = 9;
nstates = 5;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - 5S'; %Constant weighting in the slow state
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 -1 0 0 0 0 0 0;... af<as
    0 0 1 0 0 -1 0 0 0;...  as<aet
    0 0 0 0 0 0 1 0 -1;...  bb>bet
    1 0 0 0 0 0 0 -1 0;...  af<ab
    0 0 -1 0 0 0 0 1 0;...  ab<as
    %0 0 0 -1 10 0 0 0 0;...bset>bsint
    zeros(4,npars)];  
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{fa}','x^{sa}','x^{pe}','x^{ne}','x^{b}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs =  {':','--','-.','-.',':'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan nan 4 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_{f}^{fac}','a_s','b_{s}^{fac}',...
    'b_{s}^{int}','a_{et}','b_{et}','a_b','b_b'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states
modParams(cmod).avDescr = {};
%% SSIM - 5s Model with five states
cmod = 25;
npars = 11;
nstates = 5;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - 5S-Old'; %Constant weighting in the slow state
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0 0 0;... af<as
    0 0 0 1 0 0 0 -1 0 0 0;...  as<aet
    0 -1 0 0 1 0 0 0 0 0 0;...  bf>bs
    0 0 0 0 -1 0 0 0 1 0 0;...  bs>bet
    1 0 0 0 0 0 0 0 0 -1 0;...  af<ab
    0 0 0 -1 0 0 0 0 0 1 0;...  ab<as
    0 -1 0 0 0 0 0 0 0 0 1;...  bf>bb
    0 0 0 0 1 0 0 0 0 0 -1;...  bb>bs
    zeros(3,npars)];  
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
modParams(cmod).lineSpecs =  {':','-.','-.',':','--'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan nan 4 4 nan nan]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
    'b_{s}^{int}','a_{et}','b_{et}','a_b','b_b'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states
modParams(cmod).avDescr = {};
%% SSIM - 5sNew Model with five states and same dynamics for body and slow state
cmod = 22;
npars = 9;
nstates = 5;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - 5S -9p'; %Constant weighting in the slow state
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
modParams(cmod).stNames = {'x^{b}','x^{pe}','x^{ne}','x^{fa}','x^{sa}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {'-','-.','-.',':','--'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan nan 4 4 nan nan]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s','b_{s}^{fac}',...
    'b_{s}^{int}','a_{et}','b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states
modParams(cmod).avDescr = {};
%% SSIM - 5s Model with five states
cmod = 23;
npars = 10;
nstates = 5;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - 5SnoFac'; %Constant weighting in the slow state
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0 0;... af<as
    0 0 0 1 0 0 -1 0 0 0;...  as<aet
    0 -1 0 0 1 0 0 0 0 0;...  bf>bs
    0 0 0 0 -1 0 0 1 0 0;...  bs>bet
    1 0 0 0 0 0 0 0 -1 0;...  af<ab
    0 0 0 -1 0 0 0 0 1 0;...  ab<as
    0 -1 0 0 0 0 0 0 0 1;...  bf>bb
    0 0 0 0 1 0 0 0 0 -1;...  bb>bs
    zeros(2,npars)];  
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
modParams(cmod).lineSpecs =  {':','-.','-.',':','--'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan nan 4 4 nan nan]; %Line width
modParams(cmod).parNames = {'a_f','b_f','b_{f}^{fac}','a_s','b_s',...
    'b_{s}^{int}','a_{et}','b_{et}','a_b','b_b'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states
modParams(cmod).avDescr = {};
%% SSIM - 5s Model with five states
cmod = 24;
npars = 9;
nstates = 5;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - 5S-free'; %Constant weighting in the slow state
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 -1 0 0 0 0 0 0;... af<as
    0 0 1 0 0 -1 0 0 0;...  as<aet
    0 0 0 0 0 0 1 0 -1;...  bb>bet
    0 0 0 -1 10 0 0 0 0;...bset>bsint
    zeros(5,npars)];  
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
modParams(cmod).lineSpecs =  {':','-.','-.',':','--'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan nan 4 4 nan nan]; %Line width
modParams(cmod).parNames = {'a_f','b_{f}^{fac}','a_s','b_{s}^{fac}',...
    'b_{s}^{int}','a_{et}','b_{et}','a_b','b_b'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states
modParams(cmod).avDescr = {};
%% SSIM 5 states, G tuning - sigmaFast fixed
cmod = 26;
npars = 9;
nstates = 5;
ncoo = 1; %Number of coordinates
modParams(cmod).name = '5s - G_{TUN}^{\sigma_f}';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 -1 0 0 0 0 0 0;... af<as
    0 0 1 0 0 -1 0 0 0;...  as<aet
    0 0 0 0 0 0 1 0 -1;...  bb>bet
    1 0 0 0 0 0 0 -1 0;...  af<ab
    0 0 -1 0 0 0 0 1 0;...  ab<as
    0 1 0 -10 0 0 0 0 0;...  fpeak>speak
    zeros(3,npars)];  
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{fa}','x^{sa}','x^{pe}','x^{ne}','x^{b}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.',':'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan nan 4 4 4]; %Line width
modParams(cmod).parNames = {'a_f','peak_{f}','a_s','peak_{s}','std_{s}',...
    'a_{et}','b_{et}','a_b','b_b'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states
modParams(cmod).avDescr = {};

%% SSIM 5 states, G tuning - sigmaFast fixed
cmod = 27;
npars = 9;
nstates = 5;
ncoo = 1; %Number of coordinates
modParams(cmod).name = '5s - offG_{TUN}^{\sigma_f}';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 -1 0 0 0 0 0 0;... af<as
    0 0 1 0 -1 0 0 0 0;...  as<aet
    0 0 0 0 0 1 0 -1 0;...  bb>bet
    1 0 0 0 0 0 -1 0 0;...  af<ab
    0 0 -1 0 0 0 1 0 0;...  ab<as
    0 1 0 -10 0 0 0 0 0;...  fpeak>speak
    zeros(3,npars)];  
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{fa}','x^{sa}','x^{pe}','x^{ne}','x^{b}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.',':'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan nan 4 4 4]; %Line width
modParams(cmod).parNames = {'a_f','peak_{f}','a_s','peak_{s}',...
    'a_{et}','b_{et}','a_b','b_b','o'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states
modParams(cmod).avDescr = {};
%% SSIM 5 states, G tuning - sigmaFast fixed
cmod = 28;
npars = 8;
nstates = 5;
ncoo = 1; %Number of coordinates
modParams(cmod).name = '5s - G_{TUN}^{\sigma_f}';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 -1 0 0 0 0 0;... af<as
    0 0 1 0 -1 0 0 0;...  as<aet
    0 0 0 0 0 1 0 -1;...  bb>bet
    1 0 0 0 0 0 -1 0;...  af<ab
    0 0 -1 0 0 0 1 0;...  ab<as
    0 1 0 -20 0 0 0 0;...  fpeak>speak
    zeros(2,npars)];  
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{fa}','x^{sa}','x^{pe}','x^{ne}','x^{b}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.',':'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan nan 4 4 4]; %Line width
modParams(cmod).parNames = {'a_f','peak_{f}','a_s','peak_{s}',...
    'a_{et}','b_{et}','a_b','b_b'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states
modParams(cmod).avDescr = {};

%% SSIM 5 states, Sigmoid tuning 
cmod = 29;
npars = 10;
nstates = 5;
nconstraints=12;
ncoo = 1; %Number of coordinates
modParams(cmod).name = '5s - Sigmf';
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 0 -1 0 0 0 0 0 0;... af<as
    0 0 0 1 0 0 -1 0 0 0;...  as<aet
    0 0 0 0 0 0 0 1 0 -1;...  bb>bet
    1 0 0 0 0 0 0 0 -1 0;...  af<ab
    0 0 0 -1 0 0 0 1 0 0;...  ab<as
    0 -1 0 0 100 0 0 0 0 0;...  100*s_a<f_a
    0 1 0 0 0 0 0 0 0 0;...  100>f_a
    0 -1 0 0 0 0 0 0 0 0;...  10<f_a
    0 0 0 0 -1 0 0 0 0 0;...  0<s_a    
    0 0 1 0 0 0 0 0 0 0;...  1>fc
    0 0 0 0 0 1 0 0 0 0;...  1>sc
    0 0 -1 0 0 0 0 0 0 0;...  0<fc
    0 0 0 0 0 -1 0 0 0 0;...  0<sc
         ];  
%modParams(cmod).bcond = zeros(nconstraints,1);
modParams(cmod).bcond = [0;0;0;0;0;0;100;-10;0;1;1;0;0];
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{fa}','x^{sa}','x^{pe}','x^{ne}','x^{b}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs = {':','--','-.','-.',':'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan nan 4 4 4]; %Line width
modParams(cmod).parNames = {'a_f','sigma_{f}','center_{f}','a_s','sigma_{s}','center_{s}',...
    'a_{et}','b_{et}','a_b','b_b'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd= []; %Additional variables that are not states
modParams(cmod).avDescr = {};
%% SSIM - 3s Model with five states
cmod = 31;
npars = 5;
nstates = 3;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - 3S'; %Constant weighting in the slow state
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 0 -1 0;... af<aet
    0 -1 0 1 0;...  bset>bet
    %0 -1 0 1 0;...  bfet>bset
    %0 0 0 0 0 0 1 0 -1;...  bb>bet
    %1 0 0 0 0 0 0 -1 0;...  af<ab
    %0 0 -1 0 0 0 0 1 0;...  ab<as  
    %0 0 0 -1 10 0 0 0 0;...bset>bsint
    zeros(3,npars)];  
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{fa}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs =  {':','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan 4 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_{f}^{fac}',...
    'b_{f}^{int}','a_{et}','b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states
modParams(cmod).avDescr = {};
%% SSIM - 4s Model with five states
cmod = 30;
npars = 8;
nstates = 4;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - 4S'; %Constant weighting in the slow state
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [1 0 -1 0 0 0 0 0;... af<as
    0 0 1 0 0 0 -1 0;...  as<aet
    0 0 0 -1 0 0 0 1;...  bset>bet
    0 -1 0 1 0 0 0 0;...  bfet>bset
    %0 0 0 0 0 0 1 0 -1;...  bb>bet
    %1 0 0 0 0 0 0 -1 0;...  af<ab
    %0 0 -1 0 0 0 0 1 0;...  ab<as  
    %0 0 0 -1 10 0 0 0 0;...bset>bsint
    zeros(4,npars)];  
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{fa}','x^{sa}','x^{pe}','x^{ne}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs =  {':','--','-.','-.'}; %States line specs
modParams(cmod).colors = {nan,nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan nan 4 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_{f}^{fac}','a_s','b_{s}^{fac}',...
    'b_{s}^{int}','b_{f}^{int}','a_{et}','b_{et}'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states
modParams(cmod).avDescr = {};
%% SSIM - 4s_body Model with five states
cmod = 32;
npars = 7;
nstates = 4;
ncoo = 1; %Number of coordinates
modParams(cmod).name = 'SSIM - 4S-body'; %Constant weighting in the slow state
modParams(cmod).npars = npars;
modParams(cmod).nstates = nstates;
modParams(cmod).x0 = zeros(1,nstates);
modParams(cmod).k0 = zeros(1,npars);
modParams(cmod).klb = zeros(1,npars);
modParams(cmod).kub = ones(1,npars);
modParams(cmod).Acond = [ 1 0 0 0 0 -1 0;...  af<ab
    0 -1 0 0 0 0 1;...  bfet>bb
    0 0 0 0 1 0 -1;...  bb>bet
    0 0 0 -1 0 1 0;...  ab<aet  
    %0 0 0 -1 10 0 0 0 0;...bset>bsint
    zeros(3,npars)];  
modParams(cmod).bcond = zeros(npars,1);
modParams(cmod).input = perturbations; %Group X Strides
modParams(cmod).kmin = nan(1,npars);
modParams(cmod).z = nan(ng,nt,ncoo);
modParams(cmod).e = nan(ng,nt,ncoo);
modParams(cmod).X = nan(ng,nstates,nt);
modParams(cmod).stNames = {'x^{fa}','x^{pe}','x^{ne}','x^{b}'};
modParams(cmod).R2 = nan;
modParams(cmod).BIC = nan;
modParams(cmod).zcoord = 1;
modParams(cmod).TAU = nan(ng,nconds,nstates);
modParams(cmod).PV = nan(ng, nstates);
modParams(cmod).lineSpecs =  {':','-.','-.',':'}; %States line specs
modParams(cmod).colors = {nan,[0.466,0.674,0.188],[0.494,0.184,0.556],[0.9290    0.6940    0.1250],[0.9290    0.6940    0.1250]};%States colors
modParams(cmod).lw = [nan nan 4 4 4]; %Line width
modParams(cmod).parNames = {'a_f','b_{f}^{fac}',...
    'b_{f}^{int}','a_{et}','b_{et}','a_b','b_b'};
modParams(cmod).summaryString = '';
modParams(cmod).Xadd = []; %Additional variables that are not states
modParams(cmod).avDescr = {};
end