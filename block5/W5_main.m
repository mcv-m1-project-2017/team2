clear all
img_list = dir(fullfile('..\train','*.jpg'));
    
 for i = 1:1%ength(img_list)
    img_name= img_list(i).name;
    img = imread(strcat('../train/',img_name));

    %figure; imshow(img);
   [outR, outB] = W5_task1(img);
    figure;    
       subplot(3,1,1); imshow(img);
       subplot(3,1,2); imshow(outR);
       subplot(3,1,3); imshow(outB);
end