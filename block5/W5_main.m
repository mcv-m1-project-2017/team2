%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        M1 BLOCK 5: New segmentation + Geometric Heuristics	 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dbstop if error
% Task 1: Try to improve segmentation
% Task 2: Geometric Heuristics -- Hough Transform + Heuristics
% addpath
%--------
addpath(genpath(fileparts(mfilename('fullpath'))));

close all;
clear all;

%%%%%%%%%%%%%%%%
%    Task 1    %
%%%%%%%%%%%%%%%%
img_list = dir(fullfile('../train','*.jpg'));
out_dir = 'W5_task1/new_masks';
for i = 1:length(img_list)
    img_name = img_list(i).name;
    img = imread(strcat('../train/',img_name));
    
    out = W5_task1(img);
    writing_path = strcat(out_dir,'/','w5_masks_',img_name);
    %disp(writing_path);
    imwrite(out, writing_path);
    %     figure;
    %        subplot(1,3,1); imshow(img);
    %        subplot(1,3,2); imshow(outR);
    %        subplot(1,3,3); imshow(outB);
end


%%%%%%%%%%%%%%%%
%    Task 2    %
%%%%%%%%%%%%%%%%
masks_list = dir(fullfile('../block3/results/CCL','*.png'));
out_dir = 'W5_task2/results';
for i=1:length(masks_list)
    mask_name = masks_list(i).name;
    img = imread(strcat('../block3/results/CCL/',mask_name));
    W5_task2(img, out_dir);
end