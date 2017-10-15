% main task 4 Week 2
%-------------------
dbstop if error
image_processing_flag = 1;
load('C:\Users\noamor\Google Drive\studies\Computer_vision\M1_IHCV\statistic_of_all_types.mat');
data_set_path = 'C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK1\task2\Training_2017\train';
plot_flag = 1;
[R_hue,B_hue,R_crcb, B_crcb,R_y,B_y  ] = colors_signs_statatistics( data_set_path, all_data,image_processing_flag ,plot_flag);


% test
%-----
image_path = 'C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK1\task2\Training_2017\train\Images';
mask_path = 'C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK1\task2\Training_2017\train\mask';

type = 'hue';
[ results ] = ROC_test_set( image_path,mask_path,all_data,type,R_hue,B_hue);
figure


for ii = 1: size(results,1)
    for jj = 1: size(results,2)
plot(results(ii,jj).recall,results(ii,jj).precision,'or'); hold on
text(results(ii,jj).recall,results(ii,jj).precision,['R:',num2str(results(ii,jj).red_th),',B:',num2str(results(ii,jj).blue_th)])
hold on
    end
end
xlabel('Re-call');
ylabel('precision');

test_image = 'C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK1\task2\Training_2017\train\Images\01.001466.jpg';
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
 
%% testing the result with YCbCr
 %------------------------------
 Im = rgb2ycbcr(ImRGB_wb);
  [ IBC2 ] = backprojection_prob( B_crcb,Im(:,:,2:3) );
 [ IBL2 ] = backprojection_prob(B_y,Im(:,:,1) );
IB2 = IBC2.*IBL2;
IB2 = IB2./max(IB2(:));
 [ IRC2 ] = backprojection_prob( R_crcb,Im(:,:,2:3) );
 [ IRL2 ] = backprojection_prob(R_y,Im(:,:,1) );
 IR2 = IRC2.*IRL2; 
IR2 = IR2./max(IR2(:));
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
