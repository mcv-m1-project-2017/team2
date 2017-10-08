% This function generates merged masks for red and blue and saves the
% results in /block1/task3/masks

function [all_image_data] = task3(all_data, bluemin, bluemax, redmin, redmax,data_path)
    
    tic
    dbstop if error

    if nargin<5
        data_path = pwd;
    end

    if ~isdir('block1\task3\masks')
        mkdir('block1\task3\masks');
    end
    
    % Uncomment line 19 or line 22 to generate masks only for the
    % validation dataset or only for the training dataset.
    
    % Only validation images
    % all_data = all_data([all_data.validation]==1);
    
    % Only training images
    % all_data = all_data([all_data.validation]==0);
    
    % list of all images
    [~,idx,~] = unique({all_data.file_id});
    % Area and form will be only of the first sign
    all_image_data = all_data(idx);

    % Loop on all the Images
    %=======================
    for ii = 1:size({all_image_data.file_id},2)
        im_full_path = strcat('train\train\', all_data(ii).file_id,'.jpg');

        % Red mask
        [BW_red,~] = createMaskForRed(imread(im_full_path), redmin, redmax);
        
        % Blue mask
        [BW_blue,~] = createMaskForBlue(imread(im_full_path), bluemin, bluemax);
        BW_blue = (~BW_blue);
        
        % Merge - the 2 maskes
        BW = BW_red|BW_blue;
        
        imwrite(BW,strcat('block1\task3\masks\',all_image_data(ii).file_id, '_mask.png'));

    end
    toc

end