% MAIN

clear all

addpath(genpath(fileparts(mfilename('fullpath'))));

data_dir = '..\train\train';
plot_flag = 1;


%TASK 1

[statistic_table,all_data] = dataset_analysis(data_dir,plot_flag);

%TASK 2

[all_data] = split_data(statistic_table,all_data);

%TASK 3

bluemax=0.55 ; bluemin= 0.65;
redmax= 0.5; redmin= 0.9;

[all_data] = task3(all_data, bluemin, bluemax, redmin, redmax);


%TASK 4





