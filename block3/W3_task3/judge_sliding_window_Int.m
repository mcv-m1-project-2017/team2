function [score,bbox_coor] = judge_sliding_window_Int(bounding_box,weights)
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
% amount of true pixels
s = rectangleWindow(bounding_box, 1, 1, siz(1), siz(2));

% this box is empty
if s==0
    return
end

% resize the bbox to the smallest frame possible that contains detections
% to minimaze the box using oan integral image
%find max and min value to crop according to those value
minValue = min(bounding_box(:));
maxValue = max(bounding_box(:));
[x1,y1]=find (bounding_box == minValue,1,'last');
[x2,y2]=find (bounding_box == maxValue,1,'first');
min_bbox = bounding_box(x1:x2,y1:y2);


[h,w] = size(min_bbox);
bbox_coor = [y1,x1,w,h];
% size limits (to skip outliers)
if h*w < size_limits(1) | h*w > size_limits(2)
    return
end

if (h/w)<ratio_limits(1) |  (h/w)>ratio_limits(2)
    return
end


s = rectangleWindow(min_bbox, 1, 1, w, h);


filling_ratio= s/(w*h);

if filling_ratio<0.45
    return
end

mass_center = centerOfMass(min_bbox);
mass_center = mass_center./size(min_bbox);
if mass_center(2)>mass_horiz_limits(2) | mass_center(2)<mass_horiz_limits(1)
    return
end


        % I wrote it like this because I'm guessing we'll use more factors (LORENZO)
bbox_coor = [min(J),min(I),w,h];
[ score ,sign] = Bbox_score( bbox_coor,{min_bbox} ,weights);
end