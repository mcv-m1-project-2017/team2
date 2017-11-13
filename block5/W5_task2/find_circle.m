% ------------------------------------------------------------------------- %
%                          f i n d _ p o l y g o n                          %
% ------------------------------------------------------------------------- %
% Function "find_polygon"  find    %
% shape using the given masks and annotation of the training data-set.      %
%  Method
%  ------
%   Hough lines transform
%
%
%  Input parameters                                                         %
%   ----------------                                                        %
%        Im:  given Image (after emphasizing the contours using LoG\Canny) %
%             NxMx1 , binary image                                          %
%        tol:  tolerance for the shape angles. for exp: rectangle is 90+-tol%
%              units [ angle- deg  ]                                        %
%
%        num_sides:   number of sides for the polygon.                      %
%                           for exp: triangle : num_sides=3                 %
%        initial_angle:   the first angle for one of the sides of the
%                         polygon relative to the horizon clockwise         %
%                           for exp: ------- ,    initial_angle = 0         %
%        tol_rot:   tolerance for the rotation , intial_angle +-tol_rot     %
%                   tol_rot can't exceed 180/num_sides.
%                       tol_rot<180/num_sides
%                                                                           %
%        plot_flag:(Optional) plotting a subplot with 4 images with the Bbox %
%                  default : false                                          %
%                                                                           %
%   Output variables
%   ----------------                                                        %
%        bbox : Window canidates for traffic sign. struct(x,y,w,h)          %
%        binary_mask : true are all the pixels inside of the polygon        %
% -----------------------------------------------------------------------   %

% ----------------------------------------------------------------------- %


function [ bbox,binary_mask ] = find_circle( BW,plot_flag)
if nargin<2
    plot_flag = true;
end

bbox = [];


if nargin<1 | isempty(BW)
    % trial
    Image = imread('..\train\00.003179.jpg'); % circle
    %Image = imread('..\train\01.001962.jpg');
    % YCbCr : the Luminance (Y==Ycbcr_im(:,:,1)) capture the best diff between object
    % (cause each object in my head has diff luminanace)
    Ycbcr_im = rgb2ycbcr(Image);
    BW = double(Ycbcr_im(:,:,1));
end

rgb_mask = zeros(size(BW));
binary_mask = false(size(BW));




[accum, circen, cirrad,~ ]  = CircularHough_Grd(BW, [10,120], 10, 20);

if plot_flag
figure(10); subplot(2,2,1);imagesc(accum); axis image; title('accumulation matrix');
subplot(2,2,2);imagesc(BW); colormap('gray'); title('Y from YCbCr');
  subplot(2,2,4);imagesc(BW); colormap('gray'); axis image;
 hold on;
 plot(circen(:,1), circen(:,2), 'r+');
 for k = 1 : size(circen, 1),
     DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'b-');
     rgb_mask = insertShape(rgb_mask,'FilledCircle',[circen(k,1), circen(k,2), cirrad(k)],'color',[255,0,0]);
     
 end
 title('Marked circle');
 binary_mask( rgb_mask(:,:,1)>0) = true;
 subplot(2,2,3);
 imshow(binary_mask);
title('Binary mask');

suptitle('accumulation Circular Hough-transform');

end
if all(binary_mask(:) == 0)
    bbox = [];
else
    [bbox.y,bbox.x] = find(binary_mask,1,'first');
    [y2,x2] = find(binary_mask,1,'last');
    

   bbox.w = x2 -bbox.x;
   bbox.h = y2- bbox.y;
end


end
