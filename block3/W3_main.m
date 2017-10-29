%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           M1 BLOCK 3: Simple region-based detection			 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Initialization and necessary data
clear all;
close all;
addpath(genpath(fileparts(mfilename('fullpath'))));

% adding the path to the evaluation functions folder
addpath('../evaluation');
addpath('../block1/W1_task4');
% Set the path to the folders containing the train images and their masks
% image_folder = '../train/';
image_folder = '../test/';
mask_folder = '../test';
load('..\block1\W1_task2\statistic_of_all_types.mat');



% TASK 1: Connected Component Labeling (CCL)
%============================================================================
% out put folder to save results
out_dir = fullfile(pwd,'Results_final_test\CCL');
% use the statistic table to determine the boundries
statistic_table = [];
% ploting for each mask the Original Image with the Bounding Boxes
plot_flag = false;

detection_dir =fullfile(pwd,'Results_final_test\CCL');
annotation_dir = '..\train\gt';
provided_mask_path = '..\train\mask';
th_sym = 0.75;
tic
%[ S_final ] = W3_task1( mask_folder,image_folder,out_dir,statistic_table,plot_flag ,th_sym,all_data);
[ S_final ] = W3_task1( mask_folder,image_folder,out_dir,statistic_table,plot_flag ,th_sym);

A= toc;
time_per_frame = toc/length(dir(fullfile(detection_dir,'*.png')));
[region_out, pix_out] = W3_Task4 (annotation_dir, detection_dir,provided_mask_path,detection_dir);
Evaluation_region = struct2table(region_out);
display(Evaluation_region);
pix_out.time_per_frame = time_per_frame;
Evaluation_pixel = struct2table(pix_out);
display(Evaluation_pixel);
%============================================================================

%% TASK 2: Sliding window/  Multiple detections
window_numel = [56000,12000];              % Figures collected from block1:
ratio = 1;%[1.3,1,0.33];            % min_area = 899pixels, max_area = 55930pixels
step = 10;
out_dir = fullfile(pwd,'Results_final_test\Sliding_window');
score_threshold = 0.25;
weights = [0,0,0,1];
tic
W3_task2(mask_folder, window_numel, ratio, step,out_dir,plot_flag,score_threshold,weights);
toc

%% TASK 3: Improve efficiency of feature computation using the integral image
%[] = W3_task3();

%% TASK 4:   Region-based evaluation
% CCL - evaluation
% detection_dir = 'C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK3\CCL';
% there is a problem the empty masks are not counted in the evaluation
detection_dir =fullfile(pwd,'Results\CCL');
annotation_dir = '..\train\gt';
provided_mask_path = '..\train\mask';

% [precision_CCL, sensitivity_CCL, accuracy_CCL] = W3_Task4(annotation_dir, detection_dir);


detection_dir2 = fullfile(pwd,'Results\Sliding_window');
% [precision_SLW, sensitivity_SLW, accuracy_SLW] = W3_Task4(annotation_dir, detection_dir2);

% Pixal evalution
% CCL
[region_out_CCL, pix_out_CCL] = W3_Task4 (annotation_dir, detection_dir,provided_mask_path,detection_dir,all_data);
% [out_ccl] = W3_task4_pix (all_data,detection_dir,provided_mask_path);
save('Results\CCL_results.mat','region_out_CCL', 'pix_out_CCL');
% SLW
[region_out_SLW, pix_out_SLW] = W3_Task4 (annotation_dir, detection_dir2,provided_mask_path,detection_dir2,all_data);
save('Results\sliding_window_results.mat','region_out_SLW', 'pix_out_SLW');


% [out_slw] = W3_task4_pix (all_data,detection_dir2,provided_mask_path);
% save('Results\sliding_window_results.mat','precision_SLW', 'sensitivity_SLW', 'accuracy_SLW','out_slw');
% TASK 5:   Improve efficiency of feature computation using convolutions. Compare with integral image approach
%[] = W3_task5();