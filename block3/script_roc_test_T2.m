%% ROC TEST FOR TASK 2
clear all
% adding the path to the evaluation functions folder
addpath('..\evaluation');
load('..\block1\W1_task2\statistic_of_all_types.mat');
% use the statistic table to determine the boundries
statistic_table = [];
% ploting for each mask the Original Image with the Bounding Boxes
plot_flag = false;
addpath(genpath(fileparts(mfilename('fullpath'))));
detection_dir =fullfile(pwd,'Results\Sliding_window');
annotation_dir = '..\train\gt';
image_folder = '..\train\';
mask_folder = '..\block2/W2_task3/m1';
provided_mask_path = '..\train\mask';
score_threshold = 0.35;%:0.05:0.5;
weights = [0,0,0,1];
samples = [0:1];
A  = combvec(samples,samples,samples,samples);
A= A';
window_numel = [56000,12000];              % Figures collected from block1:
ratio = 1;%[1.3,1,0.33];            % min_area = 899pixels, max_area = 55930pixels
step = 10;
out_dir = fullfile(pwd,'Results_test\Sliding_window');

for pp = 1: size(A,1)
    for kk  = 1: length(score_threshold)
        
        weights = A(pp,:)./sum( A(pp,:));
        weights = [0,0,0,1];
        detection_dir = [out_dir,num2str(kk),'_',num2str(pp)];
        tic 
        W3_task2(mask_folder, window_numel, ratio, step,detection_dir,plot_flag,score_threshold(kk),weights,all_data);
        
        time_per_frame = toc/length(dir(fullfile(detection_dir,'*.png')));
        [region_out, pix_out] = W3_Task4 (annotation_dir, detection_dir,provided_mask_path,detection_dir);
        th(kk,pp).score = score_threshold(kk);
        th(kk,pp).step = step;
        th(kk,pp).weights = weights;
        th(kk,pp).window_numel = window_numel;
        Evaluation_region = struct2table(region_out);
display(Evaluation_region);
pix_out.time_per_frame = time_per_frame;
Evaluation_pixel = struct2table(pix_out);
display(Evaluation_pixel);
        %         movefile('Results\Sliding_window', ['Results\Sliding_window',num2str(kk),'_',num2str(pp)])
        %         pause(3)
    end
%     save(['ROC_SLW_k',num2str(kk),'.mat'],'pix_out','region_out','th');
end
save(['ROC_SLW_W.mat'],'pix_out','region_out','th');



