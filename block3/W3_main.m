




%---------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------
%                       M1 BLOCK 3: Simple region-based detection
%---------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------





%---------------------------------------------------------------------------------------------------
% Initialization and necessary data

clear all;
close all;

addpath(genpath(fileparts(mfilename('fullpath'))));

image_folder = 'C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK1\task2\Training_2017\train\train';
%folder where the masks are
mask_folder = 'C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK1\task2\Training_2017\train\mask'; 

filenames = dir(fullfile(image_folder, '*.png'));
%read all images with specified extention, its png in our case

% %---------------------------------------------------------------------------------------------------
% % TASK 1: Connected Component Labeling (CCL)
% %------------------------------------------------

[] = W3_task1(   );


% %---------------------------------------------------------------------------------------------------
% % TASK 2: Sliding window/  Multiple detections
% %------------------------------------------------



[] = W3_task2();



% %---------------------------------------------------------------------------------------------------
% % TASK 3:   Improve efficiency of feature computation using the integral image
% %------------------------------------------------------------------------
 

[] =W3_task3();

% %---------------------------------------------------------------------------------------------------
% % TASK 4:   Region-based evaluation
% %------------------------------------------------------------------------
[] =W3_task4();


% %---------------------------------------------------------------------------------------------------
% % TASK 5:   Improve efficiency of feature computation using convolutions
% %           Compare with integral image approach
% %------------------------------------------------------------------------
[] =W3_task5();

%CONCLUSIONS:

%1. ??

%2. ??

%3. ??

%4. ??


