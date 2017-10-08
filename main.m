% The main script executes one by one each task, sequentially. 
%
% Task 1: Statistical analysis of the data provided
% Task 2: Split the dataset into training data (70%) and evaluation data (30%)
% Task 3: Colour segmentation to generate a mask
% Task 4: Evaluate the segmentation using ground truth
% Task 5: Study the influence of luminance normalization

clear all
addpath(genpath(fileparts(mfilename('fullpath'))));
<<<<<<< HEAD
data_dir = 'train\train';
=======

data_dir = 'train/train';
>>>>>>> baadf6469653c42da086e4874df13a9e74a0083e
plot_flag = 1;

% TASK 1
[statistic_table,all_data] = dataset_analysis(data_dir,plot_flag);

% TASK 2
[all_data] = split_data(statistic_table,all_data);

% TASK 3
bluemax=0.55 ; bluemin= 0.65;       % Threshold HUE values for blue and red retrieved 
redmax= 0.5; redmin= 0.9;           % after running tests on the training set.
[all_data] = task3(all_data, bluemin, bluemax, redmin, redmax);

<<<<<<< HEAD
% TASK 4
task4(all_data);
=======

%TASK 4

task4 (all_data);

>>>>>>> baadf6469653c42da086e4874df13a9e74a0083e


