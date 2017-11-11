close all;
clear all;

img_list = dir(fullfile('..\train','*.jpg'));
out_dir ='W5_task1/new_masks'; 
 for i =301:length(img_list)
    img_name= img_list(i).name;
    img = imread(strcat('../train/',img_name));

   out = W5_task1(img);
   writing_path = strcat(out_dir,'\','w5_masks_',img_name);
    %disp(writing_path);
   imwrite(out, writing_path);
%     figure;    
%        subplot(1,3,1); imshow(img);
%        subplot(1,3,2); imshow(outR);
%        subplot(1,3,3); imshow(outB);
end