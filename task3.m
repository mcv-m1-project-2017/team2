function [all_data] = task3(all_data, bluemin, bluemax, redmin, redmax)
%TASK3 Summary of this function goes here
%   Detailed explanation goes here
dbstop if error
for ii = 1:size({all_data.file_id},2)
    
if strcmp(all_data(ii).type,'D')==1 || strcmp(all_data(ii).type,'F')==1
    
    
    [BW,maskedRGBImage] = createMaskForBlue(imread(strcat('train\train\', all_data(ii).file_id,'.jpg')), bluemin, bluemax);
    imwrite(~BW,strcat('block1\task3\masks\',all_data(ii).file_id, '_mask.png'));

    
    
else
    [BW,maskedRGBImage] = createMaskForRed(imread(strcat('train\train\',all_data(ii).file_id,'.jpg')), redmin, redmax);
    imwrite(BW,strcat('block1\task3\masks\',all_data(ii).file_id, '_mask.png'));

    
end
    







end

