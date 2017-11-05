function [] = W4_task1(mask_path,models_path,out_dir,method,threshold,plot_flag)
if nargin < 1
mask_path = 'C:\Users\noamor\Documents\GitHub\team2\team2\block3\Results\CCL';
end
if nargin < 2
models_path = fullfile(fileparts(mfilename('fullpath')),'grey_scale_models.mat');
end
if nargin < 3
out_dir = 'Results\CCL_MAE';
end
if ~isdir(out_dir)
    mkdir(out_dir)
end
all_masks = dir(fullfile(mask_path,'*.png'));
all_masks = {all_masks.name};
if nargin < 6
plot_flag = 0;
end
if nargin < 4
method = 1;
end
if nargin < 5
threshold = 0.5;
end
load(models_path);

for ii = 1: length(all_masks)
    mask = imread(fullfile(mask_path,all_masks{ii}));
    load(fullfile(mask_path,[all_masks{ii}(1:end-3),'mat']));
    if isempty(windowCandidates)
        disp([all_masks{ii},' is empty']);
        continue
    end
    old_windowCandidates = windowCandidates;
    windowCandidates = [];
    signtype = {};
    count = 0;
    for jj = 1: length(old_windowCandidates)
        sign_type1{jj}  = match_mask2model( mask,old_windowCandidates(jj),greyscale_model,threshold,method,plot_flag);
        if ~isempty(sign_type1{jj})
            count = count+1;
            windowCandidates = [windowCandidates;old_windowCandidates(jj)];
            signtype{count,1} = sign_type1{jj};
            
        end
    end
    if count==0
        windowCandidates = [];
        signtype = {};
        mask_out  = false(size(mask));
        disp([all_masks{ii},' No shape were found']);
    else
    [ mask_out ] = mask_bbox( mask,windowCandidates );
    end
    imwrite(mask_out,fullfile(out_dir,all_masks{ii}));
    save(fullfile(out_dir,[all_masks{ii}(1:end-3),'mat']),'windowCandidates','signtype');
end



end