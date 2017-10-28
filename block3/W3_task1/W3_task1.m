% I.Function Description : W3_task1
%==========================================
% II. INPUT:
%==========
%   1. masks_dir
%       The directory of the masks ( After preforming Color segmantation, hole-filling, Opening & closing).
%       *.png
%
%   2. out_dir:
%       Output directories to save the new masks
%
%   3. minmax_area
%       min max value of the Box Area (pix)
%       uses to elimenates outliers Boxes
%
%   4. minmax_ratio
%       h/w of the Bbx
%       uses to elimenates outliers Boxes
%
%   3. plot_flag
%       To create histograms of the statistical analysis.
%
% III. OUTPUT
%============
%   1. results :
%       List of BBox for each image.
function [ S_final ] = W3_task1( masks_dir,image_dir,out_dir,statistic_table,plot_flag,th_sym ,all_data)

% test mask
%==============================
if nargin<1
    masks_dir = '../block2/W2_task3/m1';
end
if nargin<2
    image_dir = '../train';
end
if nargin<3
    out_dir = pwd;
end
if nargin < 6 
    th_sym = 0.72;
end
if ~isdir(out_dir)
    % output directory to save the results
    mkdir(out_dir);
end
% test_mask = '00.005894_mask.png';
% masks_list{1} = test_mask;

% according to statistics on training data-set
if nargin < 4
   statistic_table = [];
end

if nargin<5
    plot_flag = false;
end
%=============================
%=============================

% Creating a list of all the masks in the directory
masks_list = dir(fullfile(masks_dir,'*.png'));
masks_list = {masks_list.name};
% count_total = 1;
S_final = [];
% Loop on each mask
for ii = 1: length(masks_list)
    % (1). load mask:
    %^^^^^^^^^^^^^^^^
    cur_mask = imread(fullfile(masks_dir,masks_list{ii}));
    % connect neigbour pixels
    %------------------------
    file_id = masks_list{ii}(1:9);
    
    if nargin==7 % runn only on testing data
        if all([all_data([strcmp({all_data.file_id},file_id)]).validation]==0)
            continue
        end
    end
    [ windowCandidates ] = find_bBox( cur_mask,file_id,statistic_table,plot_flag,fullfile(image_dir,[file_id,'.jpg']),ii ,th_sym);
    % save mat file
    [ mask_out ] = mask_bbox( cur_mask,windowCandidates );
    out_mask_name = fullfile(out_dir,[file_id,'_mask.png']);
    imwrite(mask_out,out_mask_name);
    out_mat_name = fullfile(out_dir,[file_id,'.mat']);
    save(out_mat_name,'windowCandidates');
    for jj = 1: length(windowCandidates)
        windowCandidates(jj).file_id = file_id;
    end
    S_final = [S_final;windowCandidates];
    

end
end
