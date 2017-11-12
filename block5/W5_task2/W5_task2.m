% Call from cmd with:
% a = imread('../train/00.000948.jpg');
% out = CircularHough_Grd(double(edge(im2bw(a),'canny')), [15, 80]);
function [] = W5_task2(im_dir, out_dir,all_data,plot_flag)
if nargin<2
    
filelist= dir(fullfile(im_dir,'*.jpg'));
filelist = {filelist.name};
else
end
if nargin <4 
    plot_flag = false;
end
for ii = 1: length(filelist)
    
    % detect circles
    RGB_im = imread(fullfile(im_dir,filelist{ii}));
    YCbCr_im = rgb2ycbcr(RGB_im);
    [ bbox1,binary_mask1 ] = find_circle( YCbCr_im(:,:,1),plot_flag);
    
    % For lines - using Canny edge detection
     thresh = [0.15,0.27];
    sigma = 2.5;
    [BW] = edge(YCbCr_im(:,:,1), 'canny',thresh,sigma) ;
    % detect triangles UP
    num_sides= 3;
    tol = 7;
    initial_angle = 0;
    tol_rot = 7;
    [ bbox2,binary_mask2 ] = find_polygon( BW,num_sides,tol,initial_angle,tol_rot,plot_flag);
    % detect triangles DN
    [ bbox3,binary_mask3 ] = find_polygon( BW,num_sides,tol,initial_angle,tol_rot,plot_flag);
    % detect rectangles
    num_sides= 4;
    [ bbox4,binary_mask4 ] = find_polygon( BW,num_sides,tol,initial_angle,tol_rot,plot_flag);
    mask = binary_mask1 |binary_mask2 | binary_mask3 | binary_mask4;
    
    % save the mask in out dir
    
    
end
end