function [] = W4_task1()

mask_path = 'C:\Users\noamor\Documents\GitHub\team2\team2\block3\Results\CCL';
models_path = fullfile(fileparts(mfilename('fullpath')),'grey_scale_models.mat');
out_dir = 'Results\CCL_MAE';
if ~isdir(out_dir)
    mkdir(out_dir)
end
all_masks = dir(fullfile(mask_path,'*.png'));
all_masks = {all_masks.name};
plot_flag = 0;
method = 1;
threshold = 0.5;
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
    type = {};
    count = 0;
    for jj = 1: length(old_windowCandidates)
        sign_type{jj}  = match_mask2model( mask,old_windowCandidates(jj),greyscale_model,threshold,method,plot_flag);
        if ~isempty(sign_type{jj})
            count = count+1;
            windowCandidates = [windowCandidates;old_windowCandidates(jj)];
            type{count,1} = sign_type{jj};
            
        end
    end
    if count==0
        windowCandidates = [];
        type = {};
        mask_out  = false(size(mask));
        disp([all_masks{ii},' No shape were found']);
    else
    [ mask_out ] = mask_bbox( mask,windowCandidates );
    end
    imwrite(mask_out,fullfile(out_dir,all_masks{ii}));
    save(fullfile(out_dir,[all_masks{ii}(1:end-3),'mat']),'windowCandidates','type');
end



end