function [R_hue,B_hue,R_crcb, B_crcb ] = colors_signs_statatistics( data_set_path, all_data,image_processing_flag ,plot_flag)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% hue_th = 0;
% I. Initializion variables
% =========================
% Red Hue
R_hue = struct('N',1,'prob',0,'x_edge',[0,1]);
% Blue Hue
B_hue = struct('N',1,'prob',0,'x_edge',[0,1]);
% Red YCrCb
R_crcb = struct('N',2,'prob',0,'x_edge',[0,1],'y_edge',[0,1]);
% Blue YCrCb
B_crcb = struct('N',2,'prob',0,'x_edge',[0,1],'y_edge',[0,1]);
%++++++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++

if image_processing_flag==2
    add_title = 'with reduction of luminance- and after white balance (Grey world)';
elseif image_processing_flag==1
    add_title = 'after white balance (Grey world)';
else
    add_title = '';
end
if nargin<4
    plot_flag = 0;
end



% Run only on training data-set
%------------------------------
all_data = all_data([all_data.validation]==0);
All_pix_red = [];
All_pix_blue= [];
All_pix_redblue = [];



% loop on every sign - to split then into 3 groups (Red/Blue/Mix)
for ii = 1: length(all_data)
    image_file = fullfile(data_set_path,'Images',[all_data(ii).file_id,'.jpg']);
    mask_file = fullfile(data_set_path,'mask',['mask.',all_data(ii).file_id,'.png']);
    
    [ Out_Im,~ ] = extract_mask_from_image( image_file,mask_file, all_data(ii).index ,image_processing_flag);
    %collect all pixels info
    Im_in_Col = reshape(Out_Im,[],1,3);
    Im_in_Col = uint8(Im_in_Col(~isnan(Im_in_Col(:,:,1)),:,:));
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

% subplot(1,2,1)
% hist fit to gaussian dist
% hist(All_pix_red_hsv(:,:,1),20)
% h2 =histfit(All_pix_red_hsv(:,:,1));
%
step = 0.025;
ce = [0:step:1]';
% [mu,sigma,muci,sigmaci] = normfit(All_pix_blue_hsv(:,:,1),0.5);
% hist(All_pix_blue_hsv(:,:,1),ce);
% bar(ce,nB/sum(nB));
% Y = normpdf(ce,mu,sigma);
% hold on;
% plot(ce,Y/(sum(Y)),'r')
nRB = [hist(All_pix_redblue_hsv(:,:,1),ce)]';
nRB = nRB/sum(nRB);
nR  = [hist(All_pix_red_hsv(:,:,1),ce)]';
nR = nR/sum(nR);
% hist(All_pix_blue_hsv(:,:,1),ce)
% h3 =histfit(All_pix_blue_hsv(:,:,1))

nB = [hist(All_pix_blue_hsv(:,:,1),ce)]';
nB = nB/sum(nB);

% Conditional Propability
%========================
R = (nR.*nRB);
R = R/sum(R);
B = (nB.*nRB);
B = B/sum(B);

% output_struct
R_hue.prob = R;
R_hue.x_edge = [ce-step/2;ce(end)+step/2];
B_hue.prob = B;
B_hue.x_edge = [ce-step/2;ce(end)+step/2];

if plot_flag
    figure
    subplot(2,1,1)
    bar(ce,[nRB,nR,nB]);
    legend('mix signs','Red sign','blue sign'); hold on
    title({'** each sign has a B&W element as well'});
    subplot(2,1,2)
    bar(ce,[R,B]);
    title('conditional probability');
    legend('Red ','blue '); hold on

    suptitle({'Hue Probability Histogram';add_title});
    

end

%  legend('mix signs','Red sign','blue sign')
% I - Cb Cr
All_pix_red_ycbcr = rgb2ycbcr(All_pix_red);
All_pix_red_ycbcr = reshape(All_pix_red_ycbcr,[size(All_pix_red_ycbcr,1),3]);
All_pix_blue_ycbcr = rgb2ycbcr(All_pix_blue);
All_pix_blue_ycbcr = reshape(All_pix_blue_ycbcr,[size(All_pix_blue_ycbcr,1),3]);
All_pix_redblue_ycbcr = rgb2ycbcr(All_pix_redblue);
All_pix_redblue_ycbcr = reshape(All_pix_redblue_ycbcr,[size(All_pix_redblue_ycbcr,1),3]);




% Histogram Equalization - to better understanding of the distribution of
% the DATA
%=========================================================================



% Remove elements that the RED and the BLUE signs has (if they both have
% them - it probably white\black.
%---------------------------------
% The mixed sign dont have white or black - so we can add them to the
% statistics- to increase probability
% 1. Removing all the data below a threshold
step = 5;
ce3 = [0:step:255]';
RGrp = hist3(double(All_pix_red_ycbcr(:,2:3)),{ce3,ce3});
RGrp = RGrp./sum(RGrp(:));
BGrp = hist3(double(All_pix_blue_ycbcr(:,2:3)),{ce3,ce3});
BGrp = BGrp./sum(BGrp(:));
MixGrp = hist3(double(All_pix_redblue_ycbcr(:,2:3)),{ce3,ce3});
MixGrp = MixGrp./sum(MixGrp(:));

R = RGrp.*MixGrp;
R = R./sum(R(:));

B = BGrp.*MixGrp;
B = B./sum(B(:));



if plot_flag
    [xq,yq] = meshgrid(min(ce3):1:max(ce3));
    
    figure
    subplot(2,1,1)
    MixGrpi = griddata(ce3,ce3,MixGrp,xq,yq,'nearest');
    surf(xq,yq,MixGrpi,'FaceColor',[1,1,1]); hold on
    RGrpi = griddata(ce3,ce3,RGrp,xq,yq,'nearest');
    surf(xq,yq,RGrpi,'FaceColor',[1,0,0]); hold on
    BGrpi = griddata(ce3,ce3,BGrp,xq,yq,'nearest');
    surf(xq,yq,BGrpi,'FaceColor',[0,0,1]); hold on
    a = MixGrpi>0 | RGrpi>0 | BGrpi>0;
    ylim([min(xq(a)),max(xq(a))]);
    xlim([min(xq(a)),max(xq(a))]);
    
    title({'the 3 Group.','** each sign has a B&W element as well'});
    
    subplot(2,1,2)
    Ri = griddata(ce3,ce3,R,xq,yq,'nearest');
    surf(xq,yq,Ri,'FaceColor',[1,0,0]); hold on
    Bi = griddata(ce3,ce3,B,xq,yq,'nearest');
    surf(xq,yq,Bi,'FaceColor',[0,0,1]); hold on
    title({'Red & Blue.','conditional probability'});
    a = Bi>0 | Ri>0;
    ylim([min(xq(a)),max(xq(a))]);
    xlim([min(xq(a)),max(xq(a))]);
    
    
    suptitle({'YCbCr Histogram,',add_title});
    
    
end









B_crcb.x_edge = [ce3-step/2;max(ce3)+step/2];
R_crcb.x_edge = [ce3-step/2;max(ce3)+step/2];
B_crcb.y_edge = [ce3-step/2;max(ce3)+step/2];
R_crcb.y_edge = [ce3-step/2;max(ce3)+step/2];
R_crcb.prob = R;
B_crcb.prob = B;



end
