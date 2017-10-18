% This function generates merged masks for red and blue and saves the
% results in /block1/task3/masks

function [all_data] = W1_task3(all_data, bluemin, bluemax, redmin, redmax,data_path)
    dbstop if error
	
	if nargin<5
        data_path = pwd;
    end
	if isempty(all_data)
	% there is no data list- with gold standart
	% this function runs on the test images.
	test_flag = true;
	else
	test_flag = false;
	end
    if ~isdir('block1\W1_task3\masks')
        mkdir('block1\W1_task3\masks');
    end
	
    % Uncomment line 19 or line 22 to generate masks only for the
    % validation dataset or only for the training dataset.
    if test_flag
	all_image_data = dir([data_path,'\*.jpg']);
	else
    % Only validation images
    % all_data = all_data([all_data.validation]==1);
    
    % Only training images
     all_data = all_data([all_data.validation]==0);
    
    % list of all images
    [~,idx,~] = unique({all_data.file_id});
    % Area and form will be only of the first sign
    all_image_data = fullfile({all_data(idx).file_id},'.jpg');
	end
    % Loop on all the Images
    %=======================
for ii = 1:size(all_image_data)
    
if strcmp(all_data(ii).type,'D')==1 || strcmp(all_data(ii).type,'F')==1

    

    [BW,maskedRGBImage] = createMaskForBlue(imread(strcat('train\train\', all_data(ii).file_id,'.jpg')), bluemin, bluemax);
    imwrite(~BW,strcat('block1\W1_task3\masks\',all_data(ii).file_id, '_mask.png'));

    
    
else
    [BW,maskedRGBImage] = createMaskForRed(imread(strcat('train\train\',all_data(ii).file_id,'.jpg')), redmin, redmax);
        writing_path = strcat('block1\task3\masks_test\',test_files_names(ii).name(1:end-4),'.png');
        disp(writing_path);
        imwrite(BW, writing_path);


end
    
toc






end

