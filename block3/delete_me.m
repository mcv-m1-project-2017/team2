min_w=10000;
min_h=10000;
max_w=0;
max_h=0;
masks_list = dir(fullfile('../block3/results/CCL/','*.png'));
masks_list = {masks_list.name};

for c=1:362
    ccl_coordinates = load(strcat('../block3/results/CCL/',strtok(masks_list{c},'_'),'_mask.mat'));
    if length(ccl_coordinates.windowCandidates)>0
        for c2=1:length(ccl_coordinates.windowCandidates)
            if ccl_coordinates.windowCandidates(c2).w < min_w
                min_w = ccl_coordinates.windowCandidates(c2).w;
            end
            if ccl_coordinates.windowCandidates(c2).w > max_w
                max_w = ccl_coordinates.windowCandidates(c2).w;
            end
            if ccl_coordinates.windowCandidates(c2).h < min_h
                min_h = ccl_coordinates.windowCandidates(c2).h;
            end
            if ccl_coordinates.windowCandidates(c2).h > max_h
                max_h = ccl_coordinates.windowCandidates(c2).h;
            end
        end
    end
end
