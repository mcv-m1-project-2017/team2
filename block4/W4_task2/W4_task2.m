function [] = W4_task2(RGBimage)
   g_img = rgb2gray(RGBimage);
   bw_img = im2bw(g_img);
   
   % Edges computed by canny, gradient magnitude or others.
   % on gray level image or contours from binary mask
   CalculateEdges(g_img,bw_img); %DONE
   
   %Model learning of edges (hand crafted, average or other)
   CalculateManualEdges(g_img);
   
   % Distance transform of test image
   DistanceTransform(g_img,bw_img); %DONE
   
   % chamfer distance to classify
   ChamferDistance(g_img);
   
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
       
end
