% script test run for task 1
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
th_1 = 0.5;
th_2 = 0.5;
th_3 = 0.5;
models_path = 'W4_task1\grey_scale_models.mat';
% Method - MAE
%==============
% For CCL
th = [0:0.025:1];
for ii = 1:length(th)
    current_out_dir = fullfile(out_dir,'MAE',['CCL',num2str(ii)]);
    W4_task1(ccl_masks,models_path,current_out_dir,1,th(ii),plot_flag);
    [region_out, pix_out] = W3_Task4 (annotation_dir, current_out_dir,provided_masks_dir,current_out_dir);
    region_out.th = th(ii);
    all_reg(ii) = region_out;
    all_pix(ii) = pix_out;
    
end
clear pix_out region_out
region_out = all_reg;
pix_out = all_pix;
save('CCL_MAE.mat','region_out','pix_out','th')
txt = 'MAE with grey-scale model over CCL';
create_ROC(pix_out,region_out,txt,th);
clear all_reg all_pix region_out pix_out
% For Sliding Window

for ii = 1:length(th)
    current_out_dir = fullfile(out_dir,'MAE',['SLW',num2str(ii)]);
    W4_task1(slw_masks,models_path,current_out_dir,1,th(ii),plot_flag);
    [region_out, pix_out] = W3_Task4 (annotation_dir, current_out_dir,provided_masks_dir,current_out_dir);
    region_out.th = th(ii);
    all_reg(ii) = region_out;
    all_pix(ii) = pix_out;
    
end
clear pix_out region_out
region_out = all_reg;
pix_out = all_pix;
save('SLW_MAE.mat','region_out','pix_out','th')
txt = 'MAE with grey-scale model over sliding window';
figure
create_ROC(pix_out,region_out,txt,th);
clear all_reg all_pix region_out pix_out
% II. Method - Correlation
% For CCL
for ii = 1:length(th)
    current_out_dir = fullfile(out_dir,'CORR',['CCL',num2str(ii)]);
    W4_task1(ccl_masks,models_path,current_out_dir,2,th(ii),plot_flag);
    [all_reg(ii), all_pix(ii)] = W3_Task4 (annotation_dir, current_out_dir,provided_masks_dir,current_out_dir);
end
clear pix_out region_out
region_out = all_reg;
pix_out = all_pix;
save('CCL_CORR.mat','region_out','pix_out','th')
txt = 'Correlation with grey-scale model over CCL';
figure
create_ROC(pix_out,region_out,txt,th);
clear all_reg all_pix region_out pix_out

% For Sliding Window
for ii = 1:length(th)
    current_out_dir = fullfile(out_dir,'CORR',['SLW',num2str(ii)]);
    %W4_task1(slw_masks,models_path,current_out_dir,2,th(ii),plot_flag);
    [region_out(ii) , pix_out(ii)] = W3_Task4 (annotation_dir, current_out_dir,provided_masks_dir,current_out_dir);
    
    %region_out(ii) = tmpr;
    region_out(ii).th = th(ii);
    pix_out(ii) = tmpp;
    clear tmpr tmpp
end

save('SLW_CORR.mat','region_out','pix_out','th')
txt = 'Correlation with grey-scale model over sliding window';
figure
create_ROC(pix_out,region_out,txt,th);
clear all_reg all_pix region_out pix_out

% III. OVER A REAL IMAGE
%-----------------------

% For CCL
for jj = 1: length(th)
    for ii = 1:length(th)
        current_out_dir = fullfile(out_dir,'Combined',['CCL',num2str(ii)]);
        W4_task1(slw_masks,models_path,current_out_dir,3,[th(ii),th(jj)],plot_flag);
        [tmpr, tmpp] = W3_Task4 (annotation_dir, current_out_dir,provided_masks_dir,current_out_dir);
        region_out(ii,jj) = tmpr;
        region_out(ii,jj).th_mae = th(ii);
        region_out(ii,jj).th_corr = th(jj);
        pix_out(ii,jj) = tmpp;
    end
end
clear pix_out region_out
region_out = all_reg;
pix_out = all_pix;
save('CCL_COMBINE.mat','region_out','pix_out','th')
txt = 'Correlation & MAE with grey-scale model over CCL';
figure
create_ROC(pix_out,region_out,txt,th);
clear all_reg all_pix region_out pix_out

% For Sliding Window
for jj = 1: length(th)
    for ii = 1:length(th)
        current_out_dir = fullfile(out_dir,'Combined',['SLW',num2str(ii)]);
        W4_task1(slw_masks,models_path,current_out_dir,3,[th(ii),th(jj)],plot_flag);
        [tmpr, tmpp] = W3_Task4 (annotation_dir, current_out_dir,provided_masks_dir,current_out_dir);
        region_out(ii,jj) = tmpr;
        region_out(ii,jj).th_mae = th(ii);
        region_out(ii,jj).th_corr = th(jj);
        pix_out(ii,jj) = tmpp;
    end
end
clear pix_out region_out
region_out = all_reg;
pix_out = all_pix;
save('SLW_COMBINE.mat','region_out','pix_out','th')
txt = 'Correlation & MAE with grey-scale model over Sliding window';
figure
create_ROC(pix_out,region_out,txt,th);
clear all_reg all_pix region_out pix_out
% For Sliding Window
%W4_task1(slw_masks,models_path,fullfile(out_dir,'CORR_MAE','SLW'),3,th_3,plot_flag)