% This function generates merged masks for red and blue and saves the
% results in /block1/task3/masks

function [out_struct] = W1_task3(all_data, bluemin, bluemax, redmin, redmax, data_path, out_dir, wb_flag)
dbstop if error
% Perform WB on the images before creating the masks
if nargin<7
    wb_flag = false;
end

% The folder that contains the images
% The default option is the current folder
if nargin<5
    data_path = pwd;
end
% Output folder to save the mask
% The default folder location if there is no input
if nargin<6
    out_dir = fullfile(pwd,'\masks');
end
if ~isdir(out_dir)
    mkdir(out_dir);
end
if isempty(all_data)
    % There is no data list - with gold standart
    % This function runs on the test images.
    test_flag = true;
else
    test_flag = false;
end


if test_flag
    all_image_data = dir([data_path,'\*.jpg']);
    out_struct = [];
else
    % Only validation images
    % all_data = all_data([all_data.validation]==1);
    
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
    
    %%
    outputImag=Im;
    r=outputImag(:,:,1);
    g=outputImag(:,:,2);
    b=outputImag(:,:,3);


    extra_blue = max(b-max(r,g),0);
    imRGB_B = im2bw(extra_blue,0.075);
%     figure
%     imshow(imRGB_B);

    extra_red = max(r-max(b,g),0);
    imRGB_R = im2bw(extra_red,0.1);
%     figure
%     imshow(imRGB_R);
     
    %%
    % Red mask
    [BW_red,~] = createMaskForRed(Im, redmin, redmax);
    
    % Blue mask
    [BW_blue,~] = createMaskForBlue(Im, bluemin, bluemax);
%     BW_blue = (~BW_blue);
    
    % Merge - the 2 maskes
%     BW = BW_red|BW_blue;
    %%
    redMask= and(imRGB_R,BW_red);
    blueMask= and(imRGB_B,BW_blue);
    BW = redMask|blueMask;

    %%
    writing_path = strcat(out_dir,'\',all_image_data{ii}(1:end-4),'_maskFinal.png');
    %disp(writing_path);
    imwrite(BW, writing_path);
    
%     writing_path = strcat(out_dir,'\',all_image_data{ii}(1:end-4),'_maskB.png');
%     %disp(writing_path);
%     imwrite(BW_blue, writing_path);
%     
end
toc

end