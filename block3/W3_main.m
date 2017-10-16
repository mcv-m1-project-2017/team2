




%---------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------
%                       M1 BLOCK 3: ??????????????????????????????????????
%---------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------





%---------------------------------------------------------------------------------------------------
% Initialization and necessary data

clear all;close all;
addpath(genpath(fileparts(mfilename('fullpath'))));

image_folder = fullfile(fileparts(mfilename('fullpath')),'masks');
%folder where the masks are

filenames = dir(fullfile(image_folder, '*.png'));
%read all images with specified extention, its png in our case

nmasks = numel(filenames);
%count total number of photos present in that folder

masks= cell(1,nmasks);
%initialize masks cell

for n = 1:nmasks
    masks{1,n} = imfill(imread([filenames(n).name]),'holes');
end
% 
% 
% %---------------------------------------------------------------------------------------------------
% % TASK 1:   ??????




[] = W3_task1(   );



% 
% 
% %---------------------------------------------------------------------------------------------------
% % TASK 2:   Measure the computational efficiency of your programed operators Erosion/Dilation


[] = W3_task2();

%NOTE: it takes a looong time to do myerode or my dilate (mydilate less time
%because there's less one's in the mask) so we have to optimie it in some
%way

% 
% 
% 
% 
% 
% %---------------------------------------------------------------------------------------------------
% % TASK 3:   Use operators to improve results in sign detection
 

[] =W3_task3();



%CONCLUSIONS:

%1. ??

%2. ??

%3. ??

%4. ??


