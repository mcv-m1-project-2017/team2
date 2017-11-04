%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        M1 BLOCK 4: Template-matching region detection			 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Task 1: Template matching using subtraction/ correlation and a gray level (color) model of the signals
% Task 2: Template matching using Distance Transform and chamfer distance
% Task 3: Perform object based evaluation

% General Links\paths
Given_gt_path = '..\train\gt';
CCL_results_path = '..\block3\Results\CCL';
SLW_results_path = '..\block3\Results\Sliding_window';

% Task 1
W4_task1;

% Task 2
W4_task2;

% Task 3
%%
method =1;
if (method==1)
    %METHOD1: Global approach
    annotation_dir = Given_gt_path;
    out_dir_int =;
    provided_mask_path = '../train/mask';

elseif (method==2)
    %METHOD2: Using CC
    annotation_dir = ;%CCL_results_path;
    out_dir_int =fullfile(pwd,'Results/CCL');
    provided_mask_path = '../train/mask';

else
    %METHOD3: Using SLW
    annotation_dir = ;%SLW_results_path;
    out_dir_int = fullfile(pwd,'Results/Sliding_window');
    provided_mask_path = '../train/mask';

end
%%
[region_out_int, pix_out_int] = W4_Task3 (annotation_dir, out_dir_int,provided_mask_path,out_dir_int);
Evaluation_region = struct2table(region_out_int);
display(Evaluation_region);
pix_out_int.time_per_frame = time_per_frame;

Evaluation_pixel = struct2table(pix_out_int);
display(Evaluation_pixel);
