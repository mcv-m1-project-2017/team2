function [ mask_out ] = mask_bbox( mask,win_can )
%mask_bbox function creates a new mask, removing all detections that are
% not in the boundry box
mask_out = false(size(mask));
for ii = 1: length(win_can)
    
    % window
    Idx_l = round([win_can(ii).y:win_can(ii).h+win_can(ii).y]');
    Idx_c = round([win_can(ii).x:win_can(ii).w+win_can(ii).x]');
    [l,c] = meshgrid(Idx_l,Idx_c);
    mask_out(l,c) = mask(l,c);
end

end

