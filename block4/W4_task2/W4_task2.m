function [] = W4_task2(mask_dir,out_dir,th_input)

%%%% Settings %%%%
if ~isdir (out_dir)
    mkdir(out_dir)
end
masks_list = dir(fullfile(mask_dir,'*.png'));
masks_list = {masks_list.name};

circle_template = imread('W4_task2/templates/circulo.png');
circle_template = im2bw(circle_template);
square_template = imread('W4_task2/templates/cuadrado.png');
square_template = im2bw(square_template);
triangleDown_template = imread('W4_task2/templates/trianguloDown.png');
triangleDown_template = im2bw(triangleDown_template);
triangleUp_template = imread('W4_task2/templates/trianguloUp.png');
triangleUp_template = im2bw(triangleUp_template);

algorithm = 'canny';             % Other options: sobel, prewitt, roberts, log, zerocross
threshold = 0.1;
%%%%%%%%%%%%%%%%%%

% Loop on each mask
tic
for ii = 1: length(masks_list)
   
   mask = (imread(strcat(mask_dir,'/',masks_list{ii})));
   ccl_coordinates = load(strcat(mask_dir,'/',strtok(masks_list{ii},'_'),'_mask.mat'));
   % Sometimes our masks are entirely black (no sign will be detected) and
   % sometimes they contain more than one positive detection (>1 sign?)
   count = 0;
   windowCandidates = [];
   if ~isempty(ccl_coordinates.windowCandidates)

        for c2=1:length(ccl_coordinates.windowCandidates)
           %mask_centre_x = floor(ccl_coordinates.windowCandidates(c2).x+(ccl_coordinates.windowCandidates(c2).w/2));
           %mask_centre_y = floor(ccl_coordinates.windowCandidates(c2).y+(ccl_coordinates.windowCandidates(c2).h/2));
           mask_only_edges = DetectEdges(mask, algorithm, threshold);
           y1=floor(ccl_coordinates.windowCandidates(c2).y);
           y2=floor(ccl_coordinates.windowCandidates(c2).y+ccl_coordinates.windowCandidates(c2).h);
           x1=floor(ccl_coordinates.windowCandidates(c2).x);
           x2=floor(ccl_coordinates.windowCandidates(c2).x+ccl_coordinates.windowCandidates(c2).w);
           % Sometimes the initial x and y are 0 (inde out of matrix error)
           % so assign 1 to them.
           if x1==0
               x1=1;
           end
           if y1==0
               y1=1;
           end
           cropped_sign = mask_only_edges(y1:y2,x1:x2);
           sum = computeSum(cropped_sign, circle_template, square_template, triangleUp_template, triangleDown_template);
           [M,index] = min(sum);
           % normalizing
           M = M/numel(cropped_sign);
           if M<th_input
           if index == 1
               disp('It is a circle');
           elseif index == 2
               disp('It is a square');
           elseif index == 3
               disp('It is a triangleUp');
           elseif index == 4
               disp('It is a triangleDown');
           end
           count = count+1;
           windowCandidates = [windowCandidates;ccl_coordinates.windowCandidates(c2)];
           signtype{count} = index;
           
               
           end
        end
           % Edges computed by canny, gradient magnitude or others.
           % on gray level image or contours from binary mask
           %CalculateEdges(g_img,bw_img);   % Compare different algorithms
   end
   %Model learning of edges (hand crafted, average or other)
   %CalculateManualEdges(g_img);
   
   % Distance transform of test image
   %DistanceTransform(g_img,bw_img); %DONE
   
   % chamfer distance to classify
   %ChamferDistance(g_img);
   
%   Template Matching (chamfer)  
%    Given:
%     • binary image, B, of edge and local feature locations
%     • binary “edge template”, T, ofshape we want to match
%    
%    Let D be an array s.t. D(i,j) is the distance to the nearest “1” in B. This array is
%    called the distance transform (DT) of B --> Matlab: bwdist()
%    
%    Goal: Find placement of T in D that minimizes the sum, M, of the DT
%    multiplied by the pixel values in T
%     – if T is an exact match to B at location (i,j) then M(i,j) = 0
%     – if the edges in B are slightly displaced from their ideal locations in T, we still get
%     a good match using the distance transform technique
%    

      if count==0
        windowCandidates = [];
        signtype = {};
        mask_out  = false(size(mask));
        %disp([all_masks{ii},' No shape were found']);
    else
    [ mask_out ] = mask_bbox( mask,windowCandidates );
      end
    file_name = [masks_list{ii}(1:9),'_mask.png'];
    imwrite(mask_out,fullfile(out_dir,file_name));
    save(fullfile(out_dir,[file_name(1:end-3),'mat']),'windowCandidates','signtype');
end
toc
end
