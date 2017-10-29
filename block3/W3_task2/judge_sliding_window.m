function [score,bbox_coor] = judge_sliding_window(bounding_box,weights)
% Give a score between 0 and 1 to a bounding box that might contain a
% traffic sign. The score is affected by the filling ratio
%imshow(bounding_box);
if nargin<2
    
weights = [1/4,1/4,1/4,1/4];
end
ratio_limits = [0.45,1.35];
size_limits= [900,56000];
mass_horiz_limits = [0.48,0.52];
score = 0;
siz = size(bounding_box);
bbox_coor = [0,0,siz(2),siz(1)];
IDX = find(bounding_box);
if isempty(IDX)
    return
end

[I,J] = ind2sub(siz,IDX);

% resize the bbox to the smallest frame possible that contains detections
min_bbox = bounding_box(min(I):max(I),min(J):max(J));
[h,w] = size(min_bbox);

% size limits (to skip outliers)
if h*w < size_limits(1) | h*w > size_limits(2)
    return
end

if (h/w)<ratio_limits(1) |  (h/w)>ratio_limits(2)
    return
end

filling_ratio = sum(min_bbox(:)==1)/length(min_bbox(:));

if filling_ratio<0.5
    return
end

mass_center = centerOfMass(min_bbox);
mass_center = mass_center./size(min_bbox);
if mass_center(2)>mass_horiz_limits(2) | mass_center(1)<mass_horiz_limits(1)
    return
end


        % I wrote it like this because I'm guessing we'll use more factors (LORENZO)
bbox_coor = [min(J),min(I),w,h];
[ score ,sign] = Bbox_score( bbox_coor,{min_bbox} ,weights);
end