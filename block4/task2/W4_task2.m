function [] = W4_task2(RGBimage)
   g_img = rgb2gray(RGBimage);
   bw_img = im2bw(g_img);
   
   CalculateEdges(g_img); %DONE
   CalculateManualEdges(g_img);
   DistanceTransform(g_img,bw_img); %DONE
   ChamferDistance(g_img);
       
end
