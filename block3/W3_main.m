%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           M1 BLOCK 3: Simple region-based detection			 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Initialization and necessary data
clear all;
close all;
addpath(genpath(fileparts(mfilename('fullpath'))));

% Set the path to the folders containing the train images and their masks
image_folder = '../train/';
mask_folder = '../block2/W2_task3/m1';




% TASK 1: Connected Component Labeling (CCL)
%============================================================================
% out put folder to save results
out_dir = fullfile(pwd,'CCL');
% use the statistic table to determine the boundries
statistic_table = [];
% ploting for each mask the Original Image with the Bounding Boxes
plot_flag = false;
[ S_final ] = W3_task1( mask_folder,image_folder,out_dir,statistic_table,plot_flag );

%============================================================================

% TASK 2: Sliding window/  Multiple detections
window_numel = [56000,12000];              % Figures collected from block1:
ratio = 1;%[1.3,1,0.33];            % min_area = 899pixels, max_area = 55930pixels
counter = 1;

images_names = dir(mask_folder);
for i=3:(length(images_names)-1)
    image = strcat(images_names(i).folder,'/',images_names(i).name);
    [positive_bounding_boxes, counter] = W3_task2(image, images_names(i).name, window_numel, ratio, counter);
    close all
end

% TASK 3: Improve efficiency of feature computation using the integral image
%[] = W3_task3();

% TASK 4:   Region-based evaluation
%[] = W3_task4();


% TASK 5:   Improve efficiency of feature computation using convolutions. Compare with integral image approach
%[] = W3_task5();