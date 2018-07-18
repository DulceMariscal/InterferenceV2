clc
close all
clear all

load IFP.mat
%recall %             ifp(group,cond,subject)=index_first_point;
minNOSToRemove=zeros(2,8);
for group=1:2
    cdata=squeeze(ifp(group,:,:));
    minNOSToRemove(group,:)=max(cdata,[],1);
end
nosI8=ifp(1,2,7);
minNOSToRemove(1,7)=nosI8;