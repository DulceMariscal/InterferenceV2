clc
close all
clear all

% orImage=imread('Contribution_sl.png');
load('protocolsSL.mat');
orImage=cdata;
B=orImage(:,:,3);
indBLeg=B>40 & B<150;

green=[0, 204, 0];
yellow=[255, 204, 0];

modImage=orImage;


for i=1:3
   MI=modImage(:,:,i);
   MI(indBLeg)=green(i);
   modImage(:,:,i)=MI;
end

figure
imshow(modImage)