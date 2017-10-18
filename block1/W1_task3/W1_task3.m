% This function generates merged masks for red and blue and saves the
% results in /block1/task3/masks

function [out_struct] = W1_task3(all_data, bluemin, bluemax, redmin, redmax,data_path, out_dir,wb_flag)
dbstop if error
% preform WB on the imaegs before creating the masks
if nargin<7
    wb_flag = false;
end
% the folder that contains the images
% the default option is the current folder

if nargin<5
    data_path = pwd;
end
% Output folder to save the mask
% the default folder location if there is no input
if nargin<6
    out_dir = fullfile(pwd,'W1_task3\masks');
end
if ~isdir(out_dir)
    mkdir(out_dir);
end
if isempty(all_data)
    % there is no data list- with gold standart
    % this function runs on the test images.
    test_flag = true;
else
    test_flag = false;
end


% Uncomment line 19 or line 22 to generate masks only for the
% validation dataset or only for the training dataset.
if test_flag
    all_image_data = dir([data_path,'\*.jpg']);
    out_struct = [];
else
    % Only validation images
     all_data = all_data([all_data.validation]==1);
    
    % Only training images
    % all_data = all_data([all_data.validation]==0);
    
    % list of all images
    [~,idx,~] = unique({all_data.file_id});
    out_struct = all_data(idx);
    % Area and form will be only of the first sign
    all_image_data = strcat({all_data(idx).file_id},'.jpg');
end
% Loop on all the Images
%=======================
%test_files_names = dir('test');
tic
for ii = 1:length(all_image_data)
    im_full_path = fullfile(data_path,all_image_data{ii});
    
    Im = imread(im_full_path);
    % White Balance
    if wb_flag
        [ Im ] = simple_WB( Im );
    end
    % Red mask
    [BW_red,~] = createMaskForRed(Im, redmin, redmax);
    
    % Blue mask
    [BW_blue,~] = createMaskForBlue(Im, bluemin, bluemax);
%     BW_blue = (~BW_blue);
    
    % Merge - the 2 maskes
    BW = BW_red|BW_blue;
    
    writing_path = strcat(out_dir,'\',all_image_data{ii}(1:end-4),'_mask.png');
    %disp(writing_path);
    imwrite(BW, writing_path);
    
end
toc

end