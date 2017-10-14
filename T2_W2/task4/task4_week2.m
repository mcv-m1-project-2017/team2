% main task 4 Week 2
%-------------------
dbstop if error
image_processing_flag = 1;
load('C:\Users\noamor\Google Drive\studies\Computer_vision\M1_IHCV\statistic_of_all_types.mat');
data_set_path = 'C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK1\task2\Training_2017\train';
plot_flag = 1;
[R_hue,B_hue,R_crcb, B_crcb ] = colors_signs_statatistics( data_set_path, all_data,image_processing_flag ,plot_flag);


% test
%-----
test_image = 'C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK1\task2\Training_2017\train\Images\00.003178.jpg';
ImRGB = imread(test_image);
[ ImRGB_wb ] = simple_WB( ImRGB );
Im = rgb2hsv(ImRGB_wb);

 [ IB ] = backprojection_prob( B_hue,Im(:,:,1) );
 
 [ IR ] = backprojection_prob( R_hue,Im(:,:,1) );
 figure
 subplot(2,2,1);
 imshow(ImRGB);
 title('Original Image');
  subplot(2,2,3);
 imshow(ImRGB_wb);
 title('WB');
   subplot(2,2,2);
 imshow(IB,[min(IB(:)),max(IB(:))]);
 colorbar
 title('Blue probability map');
  subplot(2,2,4);
 imshow(IR,[min(IR(:)),max(IR(:))]);
 colorbar
 title ('red probability map');
 
 suptitle('probability maps were created using HUE color space');
 
 % testing the result with YCbCr
 %------------------------------
 Im = rgb2ycbcr(ImRGB_wb);
  [ IB2 ] = backprojection_prob( B_crcb,Im(:,:,2:3) );
 
 [ IR2 ] = backprojection_prob( R_crcb,Im(:,:,2:3) );
  figure
 subplot(2,2,1);
 imshow(ImRGB);
 title('Original Image');
  subplot(2,2,3);
 imshow(ImRGB_wb);
 title('WB');
   subplot(2,2,2);
 imshow(IB2,[min(IB2(:)),max(IB2(:))]);
 colorbar
 title('Blue probability map');
  subplot(2,2,4);
 imshow(IR2,[min(IR2(:)),max(IR2(:))]);
 colorbar
 title ('red probability map');
 
  suptitle('probability maps were created using YCbCr color space');
