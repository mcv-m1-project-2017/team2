%% ROC TEST FOR TASK 1
addpath(genpath(fileparts(mfilename('fullpath'))));
out_dir = fullfile(pwd,'Results2\CCL');
% use the statistic table to determine the boundries
statistic_table = [];
% ploting for each mask the Original Image with the Bounding Boxes
plot_flag = false;
opt = [0.45:0.02:0.96];
detection_dir =fullfile(pwd,'Results2\CCL');
image_folder = '..\train\';
mask_folder = '..\block2\W2_task3\m1';
provided_mask_path = '..\train\mask';
annotation_dir = '..\train\gt';
provided_mask_path = '..\train\mask';
addpath('..\evaluation');
load('..\block1\W1_task2\statistic_of_all_types.mat');

for kk  = 1: length(opt)
[ S_final ] = W3_task1( mask_folder,image_folder,out_dir,statistic_table,plot_flag ,opt(kk),all_data);
[region_out(kk), pix_out(kk)] = W3_Task4 (annotation_dir, detection_dir,provided_mask_path,detection_dir);
th_sym(kk) = opt(kk);

movefile('Results2\CCL', ['Results2\CCL',num2str(kk)])
pause(3)
end
save('ROC_CCL.mat','pix_out','region_out','th_sym');