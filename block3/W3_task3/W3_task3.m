function [ output_args ] = W3_task3(mask_folder, A, ratio, step,out_dir,plot_flag,score_threshold,weights,all_data)
% preforming sliding window using an integral image
dbstop if error
% positive_bounding_boxes = [];
% bbox_candidates = [];

% Read image
% img = imread(img_path);
% [height, width] = size(img);

% window size - according to the statistics analysis in the data set
% Area size options [ max,median,min];
if nargin < 2
    A = [56000,12000];
end
if nargin<3
    % Ratio optios [min,median,max]
    
    ratio = 1;%[1.3,1,0.33];
end
if nargin<4
    step = 10;
end
if nargin<5
    out_dir = fullfile(pwd,'Sliding_window_Integral_Image');
end
if ~isdir(out_dir)
    mkdir(out_dir);
end
if nargin<6
    plot_flag = false;
end
if nargin <7
    score_threshold = 0.2;
end
if nargin<8
    
    weights = [1/4,1/4,1/4,1/4];
end

    
% all options
%-----------
alloptions = combvec(A,ratio)';
Win_size = zeros(size(alloptions));
Win_size(:,1) = sqrt(alloptions(:,1)./alloptions(:,2));
Win_size(:,2) = Win_size(:,1).*alloptions(:,2);
Win_size = round(Win_size);
[~,I] = sort(alloptions(:,1),'descend');
Win_size = Win_size(I,:);
images_names = dir(fullfile(mask_folder,'*.png'));


for i=1:(length(images_names))
    img_path = strcat(images_names(i).folder,'/',images_names(i).name);
    
        
    file_id = images_names(i).name(1:9);
    if nargin==9 % runn only on testing data
        if all([all_data([strcmp({all_data.file_id},file_id)]).validation]==0)
            continue
        end
    end
    Im = imread(img_path);

  
     Int_mask = integralImage(Im);
     Int_mask = Int_mask(2:end,2:end);
  %  B = imresize(img,scale)
    windowCandidates = sliding_window_integral_image(Int_mask, Win_size,step, out_dir,plot_flag,score_threshold,weights,Im);
    [ mask_out ] = mask_bbox( Im,windowCandidates );
    save_win_and_mask(mask_out, windowCandidates,file_id,out_dir);
    close all
end



end

function [] = save_win_and_mask(img, windowCandidates,file_id,out_dir)
if isempty(windowCandidates)
    disp([file_id, ' has NO detections']);
    mask_out = false(size(img));
    
else
    [ mask_out ] = mask_bbox( img,windowCandidates );
end
out_mask_name = fullfile(out_dir,[file_id,'_mask.png']);
imwrite(mask_out,out_mask_name);
out_mat_name = fullfile(out_dir,[file_id,'_mask.mat']);
save(out_mat_name,'windowCandidates');


end





