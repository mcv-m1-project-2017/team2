%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           M1 BLOCK 3: Simple region-based detection			%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Initialization and necessary data
clear all;
close all;
addpath(genpath(fileparts(mfilename('fullpath'))));

% Set the path to the folders containing the train images and their masks
image_folder = '..\train\';
mask_folder = '..\train\mask\';

% Read all images with specified extention, its png in our case
filenames = dir(fullfile(image_folder, '*.png'));


% TASK 1: Connected Component Labeling (CCL)
%[] = W3_task1();


% TASK 2: Sliding window/  Multiple detections
size_min = 29;              % Figures collected from block1:
size_max = 236;             % min_area = 899pixels, max_area = 55930pixels

images_names = dir(image_folder);
for i=4:length(images_names)
    image = strcat(images_names(i).folder,'\',images_names(i).name);
    [positive_bounding_boxes] = W3_task2(image, size_min, size_max);
end

% TASK 3: Improve efficiency of feature computation using the integral image
%[] = W3_task3();


% TASK 4:   Region-based evaluation
%[] = W3_task4();


% TASK 5:   Improve efficiency of feature computation using convolutions. Compare with integral image approach
%[] = W3_task5();