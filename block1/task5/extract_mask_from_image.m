function [ Out_Im,Im_mask ] = extract_mask_from_image( image_file,mask_file, mask_index ,process_image_flag)
% extract_mask_from_image , this function extrack the rgb data from the
% image according to the mask,
if nargin<4
    process_image_flag = false;
end
    
plot_flag = false;
%   INPUT
%========
%   1. image_file,: a jpg
%   2. mask_file : *.png
%	3. mask index- default is 1 (represents the numeric index in the file)
%       if there are more then 1 patch, there are a few index.
% OUTPUT
%=======
% Out_Im - NXMX3 according to the mask frame box
% Im_mask - [logical] NXMX3: FALSE is background, TRUE is the traffic sign

Im_mask = imread(mask_file);
% create a binary mask only for the specific index
Im_mask = [Im_mask==mask_index];

% read the original image
Im = imread(image_file);

% reduce the luminance effect
if process_image_flag ==2
    [ Im ] = reduce_luminance_effect( Im );
elseif process_image_flag ==1
 [ Im ] = simple_WB( Im );
end

% create a squre patch
%---------------------
pix_idx = find(Im_mask);
[line,col]=ind2sub(size(Im_mask),pix_idx);
minLine = min(line);
maxLine = max(line);
minCol = min(col);
maxCol = max(col);

Out_Im = Im(minLine:maxLine,minCol:maxCol,:);
Im_mask = Im_mask(minLine:maxLine,minCol:maxCol);
% increase the number of diminesion to match the RGB image
Im_mask = repmat(Im_mask,1,1,3);
Out_Im(Im_mask==0) = nan;
if plot_flag % for debugging
    imagesc(Out_Im);
end


end


