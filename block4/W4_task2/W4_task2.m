function [] = W4_task2(RGBimage)
   g_img = rgb2gray(RGBimage);
   bw_img = im2bw(g_img);
   
   % Edges computed by canny, gradient magnitude or others.
   % on gray level image or contours from binary mask
   CalculateEdges(g_img); %DONE
   
   %Model learning of edges (hand crafted, average or other)
   CalculateManualEdges(g_img);
   
   % Distance transform of test image
   DistanceTransform(g_img,bw_img); %DONE
   
   % chamfer distance to classify
   ChamferDistance(g_img);
       
end
