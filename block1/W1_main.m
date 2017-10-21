% The main script executes one by one each task, sequentially.
%
% Task 1: Statistical analysis of the data provided
% Task 2: Split the dataset into training data (70%) and evaluation data (30%)
% Task 3: Colour segmentation to generate a mask
% Task 4: Evaluate the segmentation using ground truth
% Task 5: Study the influence of luminance normalization

clear all
addpath(genpath(fileparts(mfilename('fullpath'))));
data_dir = '..\train';
plot_flag = 0;

% TASK 1
[statistic_table,all_data] = dataset_analysis(data_dir,plot_flag);

% TASK 2
[all_data] = split_data(statistic_table,all_data);

% TASK 3
bluemax=0.65;   bluemin= 0.55;       % Threshold HUE values for blue and red retrieved
redmax= 0.1;    redmin= 0.9;         % after running tests on the training set.

imagedir_path = '..\train';
given_mask_path = '..\train\mask';
count = 0;
% White balance before threshold
wb_flag = true;

             
outdir = ['test4bestThresholdWB\test',num2str(count)];
[all_image] = W1_task3(all_data, bluemin, bluemax, redmin, redmax, imagedir_path, outdir, wb_flag);

% TASK 4
tmp = W1_task4(all_image,outdir,given_mask_path);
tmp.bluemin = bluemin;
tmp.bluemax = bluemax;
tmp.redmin = redmin;
tmp.redmax = redmax;
results{1} = tmp;
                


save([imagedir_path,'\results_with_WB.mat'],'tmp')