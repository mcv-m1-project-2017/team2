function [score,bbox_coor] = judge_sliding_window_Int(bounding_box,weights)
% Give a score between 0 and 1 to a bounding box that might contain a
% traffic sign. The score is affected by the filling ratio
%imshow(bounding_box);
if nargin<2
    
    weights = [1/4,1/4,1/4,1/4];
end
[h_in,w_in] = size(bounding_box);
bbox_coor = [1,1,w_in,h_in];
ratio_limits = [0.45,1.35];
size_limits= [900,56000];
mass_horiz_limits = [0.47,0.53];
score = 0;


% amount of true pixels
s = bounding_box(end,end);

% this box is empty
if s==0
    return
end

% resize the bbox to the smallest frame possible that contains detections
% to minimaze the box using oan integral image
%find max and min value to crop according to those value

l1 =find (bounding_box(:,end)> 0,1,'first');
c1=find (bounding_box(end,:)> 0,1,'first');
% find the first pixel that exceed all that has all the pixels
[l2,c2]=find (bounding_box == s,1,'first');

%min_bbox = bounding_box(x1:x2,y1:y2);

min_bbox = crop_int_img(bounding_box,[c1,l1,c2-c1+1,l2-l1+1]);
[h,w] = size(min_bbox);
bbox_coor = [c1,l1,w,h];
% size limits (to skip outliers)
if h*w < size_limits(1) | h*w > size_limits(2)
    return
end

if (h/w)<ratio_limits(1) |  (h/w)>ratio_limits(2)
    return
end

% fill-factor in a cropped integral image
s = min_bbox(end,end);


ff= s/(w*h);

if ff<0.5
    return
end

mass_center = centerOfMass_Int(min_bbox);
mass_center = mass_center./[h,w];
if mass_center(2)>mass_horiz_limits(2) | mass_center(2)<mass_horiz_limits(1)
    return
end


% I wrote it like this because I'm guessing we'll use more factors (LORENZO)
% The weight equation
hmc_score = 1-abs(mass_center(2)-0.5)/2;
ratio_score = 1-abs((h/w)-1);
sym_score = 0;
score = weights(1)*ff+weights(2)*hmc_score+weights(3)*ratio_score+weights(4)*sym_score;

% [ score ,sign] = Bbox_score( bbox_coor,{min_bbox} ,weights);
end