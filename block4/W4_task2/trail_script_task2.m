% script test run for task 2
% =====================================================
%
%
%   IF YOU RUN THIS SCRIPT MOE IT ONE FOLDER UP
%   ...\team2\block4
%   ITS MAKES AN ROC TO DETECT THE THRESHOLD FOR TASK 1
%
%
% =====================================================
clear all

ccl_masks = '..\block3\Results\CCL';
slw_masks = '..\block3\Results\Sliding_window';
out_dir = 'W4_task1\Results';
addpath('..\evaluation');
addpath(genpath(fileparts(mfilename('fullpath'))));
addpath(genpath('..\block3'));
provided_masks_dir = '..\train\mask';
annotation_dir = '..\train\gt';
plot_flag = 0;
models_path = 'W4_task1\grey_scale_models.mat';
% Method - MAE
%==============
% For CCL
th = [0.03:0.03:1];
for ii = 1:length(th)
    current_out_dir = fullfile(out_dir,'Canny',['CCL',num2str(ii)]);
    W4_task2(ccl_masks,current_out_dir,th(ii));
    [region_out(ii), pix_out(ii)] = W3_Task4 (annotation_dir, current_out_dir,provided_masks_dir,current_out_dir);

    
end

save('CCL_CANNY.mat','region_out','pix_out','th')
txt = 'Edge detection over CCL';
create_ROC(pix_out,region_out,txt,th);
clear all_reg all_pix region_out pix_out
