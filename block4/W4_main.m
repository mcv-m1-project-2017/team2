%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        M1 BLOCK 4: Template-matching region detection			 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dbstop if error
% Task 1: Template matching using subtraction/ correlation and a gray level (color) model of the signals
% Task 2: Template matching using Distance Transform and chamfer distance
% Task 3: Perform object based evaluation
% addpath
%--------

addpath('..\evaluation');
addpath(genpath(fileparts(mfilename('fullpath'))));
addpath(genpath('..\block3'));





% General Links\paths
Given_gt_path = '..\train\gt';
provided_masks_dir = '..\train\mask';
% for evaluation
%---------------
% CCL_results_path = '..\block3\Results\CCL';
% SLW_results_path = '..\block3\Results\Sliding_window';
% eval_flag = 1;
% for test submition
%-------------------
CCL_results_path = '..\block3\Results_test_submit\CCL';
SLW_results_path = '..\block3\Results_test_submit\Sliding_window';
main_out_dir = 'W4_task1\Results_test_submit';
eval_flag = 0;
% Task 1
%=======
models_path = 'W4_task1\grey_scale_models.mat';
plot_flag = 0;
% MAE - on CCL
%==============
out_dir_mae_ccl = fullfile(main_out_dir,'MAE_CCL');
th_mae_ccl = 0.3;
tic
W4_task1(CCL_results_path,models_path,out_dir_mae_ccl,1,th_mae_ccl,plot_flag);
done_time = toc;
time_per_frame_mae_ccl = done_time/length(dir(fullfile(SLW_results_path,'*.png')));
if eval_flag
    [region_out, pix_out] = W3_Task4 (annotation_dir, out_dir_mae_ccl,provided_masks_dir,out_dir_mae_ccl);
end
% CORR - on CCL
%==============
out_dir_corr_ccl = fullfile(main_out_dir,'CORR_CCL');
th_corr_ccl = 0.475;
tic
W4_task1(CCL_results_path,models_path,out_dir_corr_ccl,2,th_corr_ccl,plot_flag);
done_time = toc;
time_per_frame_corr_ccl = done_time/length(dir(fullfile(SLW_results_path,'*.png')));
if eval_flag
    [region_out, pix_out] = W3_Task4 (annotation_dir, out_dir_corr_ccl,provided_masks_dir,out_dir_corr_ccl);
end
    % MAE - on SLW
%==============
out_dir_mae_slw = fullfile(main_out_dir,'MAE_SLW');
th_mae_slw = 0.225;
tic
W4_task1(SLW_results_path,models_path,out_dir_mae_slw,1,th_mae_slw,plot_flag);
done_time = toc;
time_per_frame_mae_slw = done_time/length(dir(fullfile(SLW_results_path,'*.png')));
if eval_flag
    [region_out, pix_out] = W3_Task4 (annotation_dir, out_dir_mae_slw,provided_masks_dir,out_dir_mae_slw);
end
% CORR - on SLW
%==============
out_dir_corr_slw = fullfile(main_out_dir,'CORR_SLW');
th_corr_slw = 0.345;
tic
W4_task1(SLW_results_path,models_path,out_dir_corr_slw,2,th_corr_slw,plot_flag);
done_time = toc;
time_per_frame_corr_slw = done_time/length(dir(fullfile(SLW_results_path,'*.png')));
if eval_flag
    [region_out, pix_out] = W3_Task4 (annotation_dir, out_dir_corr_slw,provided_masks_dir,out_dir_corr_slw);
end
% Task 2
%========
out_dir_trans_dist = fullfile(main_out_dir,'DIST_TRANS');
W4_task2(CCL_results_path,out_dir_trans_dist,0.33);
if eval_flag
    [region_out, pix_out] = W3_Task4 (annotation_dir, out_dir_trans_dist,provided_masks_dir,out_dir_trans_dist);
end

