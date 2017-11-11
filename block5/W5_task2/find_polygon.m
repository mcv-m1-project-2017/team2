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


function [ bbox,binary_mask ] = find_polygon( Im,num_sides,tol,initial_angle,tol_rot,plot_flag)
if nargin<6
    plot_flag = false;
end
if isempty(Im)
    % trial
    Image = imread('..\train\00.003179.jpg');
    HSV_im = rgb2hsv(Image);
    edge(image, 'canny',thresh,sigma) 
    Im = edge(HSV_im(:,:,1),'canny');
    if plot_flag
        subplot(1,2,1)
        title('Original Image')
        imshow(Image)
        subplot(1,2,2)
        title('Edge detection - "Canny"')
        
        imshow(Im)
    end
end
    
 [H,T,R] = hough(Im);
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
figure, imshow(rotI), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
end
