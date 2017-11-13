% Call from cmd with:
% a = imread('../train/00.000948.jpg');
% out = CircularHough_Grd(double(edge(im2bw(a),'canny')), [15, 80]);
function [] = W5_task2(im_dir, out_dir,all_data,plot_flag)
if ~isdir(out_dir)
    mkdir(out_dir);
end
addpath('..\block3\W3_task1');
filelist= dir(fullfile(im_dir,'*.png'));
filelist = {filelist.name};
jpg_dir = 'C:\Users\noamor\Documents\GitHub\team2\team2\test';
if nargin <4 
    plot_flag = false;
end
for ii = 1: length(filelist)
    
    % detect circles
    file_name = fullfile(im_dir,filelist{ii});
    RGB_im = imread(file_name);
    load([file_name(1:end-3),'mat']);
    YCbCr_im = RGB_im;%rgb2ycbcr(RGB_im);
    Im_real_file = imread(fullfile(jpg_dir,[filelist{ii}(1:9),'.jpg']));
   Im_real_file = rgb2ycbcr( Im_real_file);
   
    [ bbox1,binary_mask1 ] = find_circle(Im_real_file(:,:,1),plot_flag);
   
    if isempty(bbox1)
        binary_mask1 = false(size(YCbCr_im));
    else
    
    end
    if ~isempty(bbox1)
        disp('WINNNN');
    end
    % For lines - using Canny edge detection
     thresh = [0.15,0.27];
    sigma = 2.5;
    [BW] = edge(YCbCr_im(:,:,1), 'canny',thresh,sigma) ;
    % detect triangles UP
    num_sides= 3;
    tol = 7;
    initial_angle =225;
    tol_rot = 7;
    [ bbox2,binary_mask2 ] = find_triangle_up( BW,tol,tol_rot,windowCandidates,plot_flag);
    if isempty(bbox2)
        binary_mask2 = false(size(YCbCr_im));
    else
    [ binary_mask2 ] = mask_bbox( YCbCr_im,bbox2 );
    end
    if ~isempty(bbox2)
        disp('WINNNN');
    end
    % detect triangles DN
[ bbox3,binary_mask3 ] = find_triangle_up( BW,tol,tol_rot,windowCandidates,plot_flag);%     % detect rectangles
    if isempty(bbox3)
        binary_mask3 = false(size(YCbCr_im));
    else
    [ binary_mask3 ] = mask_bbox( YCbCr_im,bbox3 );
    end    
if ~isempty(bbox3)
        disp('WINNNN');
    end
%     num_sides= 4;
%     [ bbox4,binary_mask4 ] = find_polygon( BW,num_sides,tol,initial_angle,tol_rot,plot_flag);
%     mask = binary_mask1 |binary_mask2 | binary_mask3 | binary_mask4;
    mask = binary_mask1|binary_mask2 | binary_mask3 ;
    windowCandidates = [bbox1;bbox2;bbox3];
    out_name= [filelist{ii}(1:9),'_mask.png'];
    imwrite(mask,fullfile(out_dir,out_name));
    save(fullfile(out_dir,[out_name(1:end-3),'mat']),'windowCandidates');
    % save the mask in out dir
    
    
end
end