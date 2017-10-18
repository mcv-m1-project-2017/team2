% The main script executes one by one each task, sequentially.
%
% Task 1: Statistical analysis of the data provided
% Task 2: Split the dataset into training data (70%) and evaluation data (30%)
% Task 3: Colour segmentation to generate a mask
% Task 4: Evaluate the segmentation using ground truth
% Task 5: Study the influence of luminance normalization

clear all
addpath(genpath(fileparts(mfilename('fullpath'))));
data_dir = 'C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK2\train';
plot_flag = 1;

% TASK 1
[statistic_table,all_data] = dataset_analysis(data_dir,plot_flag);

% TASK 2
[all_data] = split_data(statistic_table,all_data);

% TASK 3
bluemax=[0.5:0.02:0.6] ; bluemin= [0.6:0.02:0.7];       % Threshold HUE values for blue and red retrieved
redmax= [0.05:0.02:0.3]; redmin= [0.8:0.02:0.96];           % after running tests on the training set.
imagedir_path = 'C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK2\train';
given_mask_path = 'C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK2\train\mask';
count = 0;
% White balance before threshold
wb_flag = true;

for ii = 1: length(bluemax)
    for jj = 1: length(bluemin)
        for kk = 1: length(redmax)
            for ss = 1: length(redmin)
                count = count+1;
                
                outdir = ['C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK1\test4bestThreshold\test',num2str(count)];
                [all_image] = W1_task3(all_data, bluemin(jj), bluemax(ii), redmin(ss), redmax(kk),imagedir_path,outdir);
                
                % TASK 4
                tmp = W1_task4(all_image,outdir,given_mask_path);
                tmp.bluemin = bluemin(jj);
                tmp.bluemax = bluemax(ii);
                tmp.redmin = redmin(ss);
                tmp.redmax = redmax(kk);
                results{count} = tmp;
                
            end
        end
    end
end

save([imagedir_path,'\results_without_WB.mat'],'results')