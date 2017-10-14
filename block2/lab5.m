%LAB5

%EXERCICE 1
ex1=double(imread('dem.gif'));
normalizedex1=normalitza(ex1); %I normalized with the function normalitza.m

watershedex1=watershed(ex1,8);%watershed
rgbex1=double(label2rgb(watershedex1));%make the image in colour

yex1(:,:,1)=rgbex1(:,:,1).*normalizedex1;
yex1(:,:,2)=rgbex1(:,:,2).*normalizedex1;
yex1(:,:,3)=rgbex1(:,:,3).*normalizedex1;

imshow(uint8(ex1))%plot the image
title('ex1')
figure
imshow(uint8(yex1))%plot the image
title('watershed')


%EXERCICE 2
ex2=double(imread('dem.gif'));%read the image
nex2=normalitza(ex2);%normalize it

%struct element 10x10
structelement21=ones(10); %make the struct element
edex21=imerode(imdilate(ex2,structelement21),structelement21);%dilate and
%erode the image with the structelement

wex21=watershed(edex21,8);%watershed the image
rgbex21=double(label2rgb(wex21)); %make the image in colour

yex21(:,:,1)=rgbex21(:,:,1).*nex2;
yex21(:,:,2)=rgbex21(:,:,2).*nex2;
yex21(:,:,3)=rgbex21(:,:,3).*nex2;

%struct element 20x20
structelement22=ones(20); %in this part i make the same but with the struct
%element 20x20
edex22=imerode(imdilate(ex2,structelement22),structelement22);

wex22=watershed(edex22,8);
rgbex22=double(label2rgb(wex22));

yex22(:,:,1)=rgbex22(:,:,1).*nex2;
yex22(:,:,2)=rgbex22(:,:,2).*nex2;
yex22(:,:,3)=rgbex22(:,:,3).*nex2;

figure
imshow(uint8(yex21))
title('watershed 10x10')

figure
imshow(uint8(yex22))
title('watershed 20x20')

%EXERCICE 3
ex3=rgb2gray(imread('coins2.jpg'));
binex3=ex3<230; %binarize the image
structelement31=ones(10);%three different structs elements
structelement32=[0 1 0;1 1 1;0 1 0];
structelement33=ones(5);
edex3=imerode(imdilate(binex3,structelement31),structelement31); %here I
%apply a dilate and then an erode of the image with an struct element 10x10

gradex3=imdilate(edex3,structelement32)-edex3; %calculate the edges of 
%objects using the gradient
dist=bwdist(gradex3);%here I calculate the distance from each pixel to the 
%nearest edge using the function bwdist
dgradex3=imdilate(dist,structelement33);%Here I apply a small dilation with
%a struct element 5x5.
idgradex3=max(max(dgradex3))-dgradex3;%inverse
wex3=watershed(idgradex3,8);%Here I watershed the inverted distance 
%function
yex3=uint8(edex3).*wex3;%multiply only with the objects of interest (the 
%rest will be multiplyed by 0.

%nyex3=normalitza(yex3); %here I try to normalize and then distribute to 
%have different colours around the gray scale, but I don't know why doesn't
%works...
%yex3=255.*nyex3;

yex3=20.*yex3;%here I multiply only to have a better image to see the 
%difference between the shapes.
coins=length(unique(yex3))-1;%calculate the coins

rgbyex3=double(label2rgb(yex3));%here I make the image in colour

yex3(:,:,1)=rgbyex3(:,:,1);
yex3(:,:,2)=rgbyex3(:,:,2);
yex3(:,:,3)=rgbyex3(:,:,3);

figure %plot the real image and the output image
imshow(ex3)
title('ex3')
figure
imshow(yex3)
title('yex3')



