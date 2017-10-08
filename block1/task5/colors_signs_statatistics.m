function [ce, nRB,nB,nR ] = colors_signs_statatistics( data_set_path, all_data,image_processing_flag )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% hue_th = 0;
if image_processing_flag==2
    add_title = 'with reduction of luminance- and after white balance (Grey world)';
elseif image_processing_flag==1
 add_title = 'after white balance (Grey world)';
else
    add_title = '';
end
% Run only on training data-set
%------------------------------
all_data = all_data([all_data.validation]==0);
All_pix_red = [];
All_pix_blue= [];
All_pix_redblue = [];
for ii = 1: length(all_data)
    image_file = fullfile(data_set_path,'Images',[all_data(ii).file_id,'.jpg']);
    mask_file = fullfile(data_set_path,'mask',['mask.',all_data(ii).file_id,'.png']);

    [ Out_Im,~ ] = extract_mask_from_image( image_file,mask_file, all_data(ii).index ,image_processing_flag);
    %collect all pixels info
    Im_in_Col = reshape(Out_Im,[],1,3);
    Im_in_Col = Im_in_Col(~isnan(Im_in_Col(:,:,1)),:,:);
    if all_data(ii).color_wrbk(2) & all_data(ii).color_wrbk(3)
        All_pix_redblue = [All_pix_redblue;Im_in_Col];
    elseif all_data(ii).color_wrbk(2)
        
    All_pix_red = [All_pix_red;Im_in_Col];
    
    elseif all_data(ii).color_wrbk(3)
        
    All_pix_blue = [All_pix_blue;Im_in_Col];
    end
    %plot3(Out_Im(:,:,1),Out_Im(:,:,2),Out_Im(:,:,3),'+');
    
end
% figure
% plot3D(All_pix_redblue,All_pix_red,All_pix_blue)
% 
% xlabel('RED');
% ylabel('GREEN');
% zlabel('BLUE');
% title({'RGB color space';add_title;'** each sign has a B&W element as well'});
% legend('blue & red mixed sign','red_signs','blue signs');

% figure
% plot(All_pix_redblue(:,:,1),All_pix_redblue(:,:,3),'.k'); hold on
% plot(All_pix_red(:,:,1),All_pix_red(:,:,3),'or'); hold on
% plot(All_pix_blue(:,:,1),All_pix_blue(:,:,3),'+b'); hold on
% 
% 
% grid on
% xlabel('RED');
% 
% ylabel('BLUE');
% title({'R-B color space';add_title;'** each sign has a B&W element as well'});
% legend('blue & red mixed sign','red_signs','blue signs');

% RGB to HSV ( cause our threshould is of the Hue)
Max_vec = max([length(All_pix_red),length(All_pix_blue),length(All_pix_redblue)]);
All_pix_red_hsv= nan(Max_vec,1,3);
All_pix_blue_hsv = nan(Max_vec,1,3);
All_pix_redblue_hsv = nan(Max_vec,1,3);

All_pix_red_hsv(1:length(All_pix_red),1,:)  = rgb2hsv(All_pix_red);
All_pix_blue_hsv(1:length(All_pix_blue),1,:) = rgb2hsv(All_pix_blue);
All_pix_redblue_hsv(1:length(All_pix_redblue),1,:) = rgb2hsv(All_pix_redblue);
figure
% subplot(1,2,1)
ce = [0:0.02:1]';
 nRB = [hist(All_pix_redblue_hsv(:,:,1),ce)]';
 nR  = [hist(All_pix_red_hsv(:,:,1),ce)]';
 nB = [hist(All_pix_blue_hsv(:,:,1),ce)]';
 bar3(ce,[nRB/sum(nRB),nR/sum(nR),nB/sum(nB)]);
% hist([All_pix_redblue_hsv(:,:,1),All_pix_red_hsv(:,:,1),All_pix_blue_hsv(:,:,1)],20)
% bar3
title({'Hue Histogram';add_title;'** each sign has a B&W element as well'});
% subplot(1,2,2)
% plot3D(All_pix_redblue_hsv,All_pix_red_hsv,All_pix_blue_hsv)
legend('mix signs','Red sign','blue sign')
 figure
 plot(All_pix_redblue_hsv(:,:,1),All_pix_redblue_hsv(:,:,2),'.k');hold on
 plot(All_pix_red_hsv(:,:,1),All_pix_red_hsv(:,:,2),'or');hold on
 plot(All_pix_blue_hsv(:,:,1),All_pix_blue_hsv(:,:,2),'+b');hold on
% 
 ylabel('Sat');
 xlabel('Hue');
 title({'Hue vs Saturation';add_title;'** each sign has a B&W element as well'});
 legend('mix signs','Red sign','blue sign')
% I - Cb Cr
% All_pix_red_ycbcr = rgb2ycbcr(All_pix_red);
% All_pix_blue_ycbcr = rgb2ycbcr(All_pix_blue);
% All_pix_redblue_ycbcr = rgb2ycbcr(All_pix_redblue);
% 
% figure
% plot(All_pix_redblue_ycbcr(:,:,2),All_pix_redblue_ycbcr(:,:,3),'.k'); hold on
% plot(All_pix_red_ycbcr(:,:,2),All_pix_red_ycbcr(:,:,3),'or'); hold on
% plot(All_pix_blue_ycbcr(:,:,2),All_pix_blue_ycbcr(:,:,3),'+b'); hold on


% grid on
% ylabel('RED');
% xlabel('BLUE');
% 
% title({'Y-Cb-Cr color space';add_title;'** each sign has a B&W element as well'});
% legend('blue & red mixed sign','red_signs','blue signs');

end
function [] = plot3D(X1,X2,X3)

plot3(X1(:,:,1),X1(:,:,2),X1(:,:,3),'.k'); hold on
plot3(X2(:,:,1),X2(:,:,2),X2(:,:,3),'or'); hold on
plot3(X3(:,:,1),X3(:,:,2),X3(:,:,3),'xb'); hold on

grid on

end
