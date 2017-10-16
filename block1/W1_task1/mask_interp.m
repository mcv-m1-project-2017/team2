function [ mask_area ,mask_index] = mask_interp( file_name , tl , br)
%text_interp extract the features in the txt file  
% I. INPUT
%==========
% 1. file_name - *.png
% 2. tl ( top-left, [line,col])
% 3. br ( buttom-right, [line,col])
if ~exist(file_name,'file')
    mask_area=-1;
    disp([file_name,' -not exist']);
    return
end
%II. OUTPUT
%==========
% 1. mask_area (in pixel units)

I = imread(file_name);
% the coordinates are given in float- as the image is discrete
% the indexes are extanded 
% the coordinate are given "c" wize (index start in 0)--> as oppose to
% matlab (index start at 1)

Box = I(ceil(tl(1)):ceil(br(1)),ceil(tl(2)):ceil(br(2)));
bBox = (Box>0);
mask_index = median(Box(bBox));
% BW2 = bwmorph(bBox,'open');
% 
% figure;imshow(BW2,[0,1]); % more accurate

%figure;imshow(bBox,[0,1]);

% calculate the Area of the shape
mask_area = sum(bBox(:));
if mask_area==0
    figure;imshow(bBox,[0,1]);
    figure; imshow(I,[0,1]);
end
end

