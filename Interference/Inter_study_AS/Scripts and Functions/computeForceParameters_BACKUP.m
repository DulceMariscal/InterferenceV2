function [out] = computeForceParameters(strideEvents, GRFData ,s)
% %UNTITLED4 Summary of this function goes here
% %   Detailed explanation goes here

%% BACKUP FILE

indSHS=strideEvents.tSHS;
indFTO=strideEvents.tFTO;
indFHS=strideEvents.tFHS;
indSTO=strideEvents.tSTO;
indSHS2=strideEvents.tSHS2;
indFTO2=strideEvents.tFTO2;
indFHS2=strideEvents.tFHS2;
indSTO2=strideEvents.tSTO2;

if strcmp(s,'L')
    f='R';
elseif strcmp(s,'R')
    f='L';
else
    error();
end 

[COP]=GRFData.computeCOP;

sp=COP.sampPeriod*10; % 


% [GRFDataF, GRFDataS, GRFDataH] = getGRFs(GRFData,s,f);    
% % %% COP range and symmetry
% [COP] = computeCOP(GRFDataS,GRFDataF,s,f);
%         %Mawase's way based on TO and HS
%         %COPrangeF(step)=COP(2,indFTO)-COP(2,indSHS);
%         %COPrangeS(step)=COP(2,indSTO)-COP(2,indFHS);
%         %My way based on TO and HS
% %         COPrangeF(step)=COP(2,indFTO)-COP(2,indFHS);
% %         COPrangeS(step)=COP(2,indSTO)-COP(2,indSHS);
%         %Mawase's ugly way:
%         COPrangeF=min(COP(2,indSHS:indFHS))-max(COP(2,max([indSHS-100,1]):indFTO));
%         COPrangeS=min(COP(2,indFHS:indSHS2))-max(COP(2,indFTO:indSTO));
%         COPsymM=(COPrangeF-COPrangeS)/(COPrangeF+COPrangeS);
        %My very nice way:
%         COPrangeF=min(COP(2,indSHS:indFHS))-max(COP(2,indFTO:indSTO));
%         COPrangeS=min(COP(2,indFHS:indSHS2))-max(COP(2,indSTO:indFTO2)); 
%         COPsym=(COPrangeF-COPrangeS)/(COPrangeF+COPrangeS);

%indFTO2(isnan(indFTO2))=[];
ns=length(indFTO2); %Number of strides

[COPyrangeF_NW, COPyrangeS_NW, COPysym_NW, COPyrangeF_MW, COPyrangeS_MW, COPysym_MW, COPxrangeF_MW, COPxrangeS_MW, COPxsym_MW] = deal(nan(1,ns));
[COPx_t1_vec, COPx_t2_vec, COPx_t3_vec, COPx_t4_vec, COPx_t12_vec, COPx_t23_vec, COPx_t34_vec, COPx_t45_vec]= deal(nan(1,ns));
[COPy_t1_vec, COPy_t2_vec, COPy_t3_vec, COPy_t4_vec, COPy_t12_vec, COPy_t23_vec, COPy_t34_vec, COPy_t45_vec]= deal(nan(1,ns));
        
for i=1:ns
    if isnan(indSHS(i)) || isnan(indFHS(i))|| isnan(indSTO(i)) || isnan(indFTO(i)) || isnan(indSHS2(i)) || isnan(indFTO2(i))
        %Do nothing
    else 
        %% RE-implementantion of "My very nice way"------------------------
        COPyrangeF_NW(i)=min(COP.split(indSHS(i), indFHS(i)).getDataAsVector('COPy'))- ...
                     max(COP.split(indFTO(i), indSTO(i)).getDataAsVector('COPy'));
        
        COPyrangeS_NW(i)=min(COP.split(indFHS(i), indSHS2(i)).getDataAsVector('COPy'))-...
                    max(COP.split(indSTO(i), indFTO2(i)).getDataAsVector('COPy'));
        
        COPysym_NW(i)=(COPyrangeF_NW(i)-COPyrangeS_NW(i))/(COPyrangeF_NW(i)+COPyrangeS_NW(i));
        
        %% RE-implementantion of "Mawase's way (based on TO and HS)"-------
        % Extract y data
        COPyt1 = COP.split(indFTO(i),indFTO(i)+sp).getDataAsVector('COPy'); 
        COPyt2 = COP.split(indSHS(i),indSHS(i)+sp).getDataAsVector('COPy');
        COPyt3 = COP.split(indSTO(i),indSTO(i)+sp).getDataAsVector('COPy') ;
        COPyt4 = COP.split(indFHS(i),indFHS(i)+sp).getDataAsVector('COPy');
        
        % Extract x data
        COPxt1 = COP.split(indFTO(i),indFTO(i)+sp).getDataAsVector('COPx'); 
        COPxt2 = COP.split(indSHS(i),indSHS(i)+sp).getDataAsVector('COPx');
        COPxt3 = COP.split(indSTO(i),indSTO(i)+sp).getDataAsVector('COPx') ;
        COPxt4 = COP.split(indFHS(i),indFHS(i)+sp).getDataAsVector('COPx');
        
        %Compute y symmetry
        COPyrangeF_MW(i) =  COPyt1(1)  - COPyt2(1); %FTO(2nd)-SHS(1st) Left COP length
        COPyrangeS_MW(i) =  COPyt3(1)  - COPyt4(1); %STO(4th)-FHS(3rd)               
        COPysym_MW(i)=(COPyrangeF_MW(i)-COPyrangeS_MW(i))/(COPyrangeF_MW(i)+COPyrangeS_MW(i));
        
        %Compute x symmetry
        COPxrangeF_MW(i) =  COPxt1(1)  - COPxt2(1); %Left COP length
        COPxrangeS_MW(i) =  COPxt3(1)  - COPxt4(1);                
        COPxsym_MW(i)=(COPxrangeF_MW(i)-COPxrangeS_MW(i))/(COPxrangeF_MW(i)+COPxrangeS_MW(i));
        
        %% STORE DOWSAMPLED COP AS PARAMETER-------------------------------
        %Compute intermediate times
        t12=(indFTO(i)+indSHS(i))/2;
        t23=(indSHS(i)+indSTO(i))/2;
        t34=(indSTO(i)+indFHS(i))/2;
        t45=(indFHS(i)+indFTO2(i))/2;
        
        %Extract the correspoinding COP data
        % y
        COPyt12 = COP.split(t12,t12+sp).getDataAsVector('COPy');
        COPyt23 = COP.split(t23,t23+sp).getDataAsVector('COPy');
        COPyt34 = COP.split(t34,t34+sp).getDataAsVector('COPy');
        COPyt45 = COP.split(t45,t45+sp).getDataAsVector('COPy');
        % x
        COPxt12 = COP.split(t12,t12+sp).getDataAsVector('COPx');
        COPxt23 = COP.split(t23,t23+sp).getDataAsVector('COPx');
        COPxt34 = COP.split(t34,t34+sp).getDataAsVector('COPx');
        COPxt45 = COP.split(t45,t45+sp).getDataAsVector('COPx');
        
        %Copy COP data in vectors (We are extracting 8 values for each stride)
        % y
        COPy_t1_vec(i)=COPyt1(1);
        COPy_t2_vec(i)=COPyt2(1);
        COPy_t3_vec(i)=COPyt3(1);
        COPy_t4_vec(i)=COPyt4(1);
        COPy_t12_vec(i)=COPyt12(1);
        COPy_t23_vec(i)=COPyt23(1);
        COPy_t34_vec(i)=COPyt34(1);
        COPy_t45_vec(i)=COPyt45(1);

        %x
        COPx_t1_vec(i)=COPxt1(1);
        COPx_t2_vec(i)=COPxt2(1);
        COPx_t3_vec(i)=COPxt3(1);
        COPx_t4_vec(i)=COPxt4(1);
        COPx_t12_vec(i)=COPxt12(1);
        COPx_t23_vec(i)=COPxt23(1);
        COPx_t34_vec(i)=COPxt34(1);
        COPx_t45_vec(i)=COPxt45(1);

    end
end
% 
% %% Hand holding
%         handHolding=sum(mean(abs(GRFDataH)))>2;

data=[ [COPyrangeF_NW]', [COPyrangeS_NW]', [COPysym_NW]', [COPyrangeF_MW]', [COPyrangeS_MW]', [COPysym_MW]',[COPxrangeF_MW]', [COPxrangeS_MW]', [COPxsym_MW]'...
       [COPy_t1_vec]', [COPy_t2_vec]', [COPy_t3_vec]', [COPy_t4_vec]', [COPy_t12_vec]', [COPy_t23_vec]', [COPy_t34_vec]', [COPy_t45_vec]',...
       [COPx_t1_vec]', [COPx_t2_vec]', [COPx_t3_vec]', [COPx_t4_vec]', [COPx_t12_vec]', [COPx_t23_vec]', [COPx_t34_vec]', [COPx_t45_vec]'];
   
labels={ 'COPyrangeF_NW', 'COPyrangeS_NW', 'COPysym_NW', 'COPyrangeF_MW', 'COPyrangeS_MW', 'COPysym_MW','COPxrangeF_MW', 'COPxrangeS_MW', 'COPxsym_MW'...
         'COPy_t1_vec', 'COPy_t2_vec', 'COPy_t3_vec', 'COPy_t4_vec', 'COPy_t12_vec', 'COPy_t23_vec', 'COPy_t34_vec','COPy_t45_vec',...
         'COPx_t1_vec', 'COPx_t2_vec', 'COPx_t3_vec', 'COPx_t4_vec', 'COPx_t12_vec', 'COPx_t23_vec', 'COPx_t34_vec', 'COPx_t45_vec'};
     
description={ 'COP y rangeF NW', 'COP y rangeS NW', 'COP y sym NW', 'COP y rangeF_MW', 'COP y rangeS_MW', 'COP y sym_MW', 'COP x rangeF_MW', 'COP x rangeS_MW', 'COP x sym_MW'...
              'COP y @FTO', 'COP y @SHS', 'COP y @STO', 'COP y @FHS', 'COP y @0.5(FTO+SHS)', 'COP y @0.5(SHS+STO)', 'COP y @0.5(STO+FHS)','COP y @0.5(FHS+FTO2)',...
              'COP x @FTO', 'COP x @SHS', 'COP x @STO', 'COP x @FHS', 'COP x @0.5(FTO+SHS)', 'COP x @0.5(SHS+STO)', 'COP x @0.5(STO+FHS)','COP x @0.5(FHS+FTO2)'};
          
out=parameterSeries(data,labels,[],description); 
 
%% HOW TO RESTORE COP SEQUENTIALITY
% COP X
COPx= [COPx_t1_vec', COPx_t12_vec', COPx_t2_vec',COPx_t23_vec', COPx_t3_vec', COPx_t34_vec' ,COPx_t4_vec',COPx_t45_vec'];
COPx_sq=reshape(COPx',size(COPx,1)*size(COPx,2),1);
% COP Y
COPy= [COPy_t1_vec', COPy_t12_vec', COPy_t2_vec',COPy_t23_vec', COPy_t3_vec', COPy_t34_vec' ,COPy_t4_vec',COPy_t45_vec'];
COPy_sq=reshape(COPy',size(COPy,1)*size(COPy,2),1);
figure, plot(COPx_sq(9:17),COPy_sq(9:17),'-o')%, set(gca, 'Xdir', 'reverse'); set(gca, 'Ydir', 'reverse')



end

