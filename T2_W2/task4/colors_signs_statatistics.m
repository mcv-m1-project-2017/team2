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
step = 0.05;
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

% output_struct
R_hue.prob = nR;
R_hue.x_edge = [ce-step/2;ce(end)+step/2];
B_hue.prob = nB;
B_hue.x_edge = [ce-step/2;ce(end)+step/2];

if plot_flag
    figure
    bar3(ce,[nRB/sum(nRB),nR/sum(nR),nB/sum(nB)]);
    
    title({'Hue Histogram';add_title;'** each sign has a B&W element as well'});
    
    legend('mix signs','Red sign','blue sign')
end
%  figure
%  plot(All_pix_redblue_hsv(:,:,1),All_pix_redblue_hsv(:,:,2),'.k');hold on
%  plot(All_pix_red_hsv(:,:,1),All_pix_red_hsv(:,:,2),'or');hold on
%  plot(All_pix_blue_hsv(:,:,1),All_pix_blue_hsv(:,:,2),'+b');hold on
% %
%  ylabel('Sat');
%  xlabel('Hue');
%  title({'Hue vs Saturation';add_title;'** each sign has a B&W element as well'});
%  legend('mix signs','Red sign','blue sign')
% I - Cb Cr
All_pix_red_ycbcr = rgb2ycbcr(All_pix_red);
All_pix_red_ycbcr = reshape(All_pix_red_ycbcr,[size(All_pix_red_ycbcr,1),3]);
All_pix_blue_ycbcr = rgb2ycbcr(All_pix_blue);
All_pix_blue_ycbcr = reshape(All_pix_blue_ycbcr,[size(All_pix_blue_ycbcr,1),3]);
All_pix_redblue_ycbcr = rgb2ycbcr(All_pix_redblue);
All_pix_redblue_ycbcr = reshape(All_pix_redblue_ycbcr,[size(All_pix_redblue_ycbcr,1),3]);
% trying to understand white behaver
%------------------------------
% white_pix_red_ycbcr = All_pix_red_ycbcr(All_pix_red_ycbcr(:,2)==128 &All_pix_red_ycbcr(:,3)==128,:);
% white_pix_blue_ycbcr = All_pix_blue_ycbcr(All_pix_blue_ycbcr(:,2)==128 &All_pix_blue_ycbcr(:,3)==128,:);
% white_pix_redblue_ycbcr = All_pix_redblue_ycbcr(All_pix_redblue_ycbcr(:,2)==128 &All_pix_redblue_ycbcr(:,3)==128,:);
% white_pix_red_hsv= All_pix_red(All_pix_red_ycbcr(:,2)==128 &All_pix_red_ycbcr(:,3)==128,:,:);
% white_pix_blue_hsv = All_pix_blue(All_pix_blue_ycbcr(:,2)==128 &All_pix_blue_ycbcr(:,3)==128,:,:);
% white_pix_redblue_hsv = All_pix_redblue(All_pix_redblue_ycbcr(:,2)==128 &All_pix_redblue_ycbcr(:,3)==128,:,:);

% Removing to White -Grey Colors
% All_pix_red_ycbcr = All_pix_red_ycbcr(All_pix_red_ycbcr(:,2)~=128 &All_pix_red_ycbcr(:,3)~=128,:);
% All_pix_blue_ycbcr = All_pix_blue_ycbcr(All_pix_blue_ycbcr(:,2)~=128 &All_pix_blue_ycbcr(:,3)~=128,:);
% All_pix_redblue_ycbcr = All_pix_redblue_ycbcr(All_pix_redblue_ycbcr(:,2)~=128 &All_pix_redblue_ycbcr(:,3)~=128,:);
% trying to understand white behaver
%------------------------------

% Also in the HSV
%----------------



% Histogram Equalization - to better understanding of the distribution of
% the DATA
%=========================================================================
% reduce number of bins to 20X20;
% DifR3 = max(All_pix_red_ycbcr(:,3))-min(All_pix_red_ycbcr(:,3));
% DifR2 = max(All_pix_red_ycbcr(:,2))-min(All_pix_red_ycbcr(:,2));
% 
% All_pix_red_ycbcr(:,3) = (All_pix_red_ycbcr(:,3)+min(All_pix_red_ycbcr(:,3)))*255/DifR3;
% All_pix_red_ycbcr(:,2) = All_pix_red_ycbcr(:,2)+min(All_pix_red_ycbcr(:,2))*255/DifR2;
% 
% DifB3 = max(All_pix_blue_ycbcr(:,3))-min(All_pix_blue_ycbcr(:,3));
% DifB2 = max(All_pix_blue_ycbcr(:,2))-min(All_pix_blue_ycbcr(:,2));
% All_pix_blue_ycbcr(:,3) = (All_pix_blue_ycbcr(:,3)+min(All_pix_blue_ycbcr(:,3)))*255/DifB3;
% All_pix_blue_ycbcr(:,2) = All_pix_blue_ycbcr(:,2)+min(All_pix_blue_ycbcr(:,2))*255/DifB2;
% 
% DifRB3 = max(All_pix_redblue_ycbcr(:,3))-min(All_pix_redblue_ycbcr(:,3));
% DifRB2 = max(All_pix_redblue_ycbcr(:,2))-min(All_pix_redblue_ycbcr(:,2));
% All_pix_redblue_ycbcr(:,3) = (All_pix_redblue_ycbcr(:,3)+min(All_pix_redblue_ycbcr(:,3)))*255/DifRB3;
% All_pix_redblue_ycbcr(:,2) = All_pix_redblue_ycbcr(:,2)+min(All_pix_redblue_ycbcr(:,2))*255/DifRB2;
% All_pix_redblue_ycbcr(:,1) = 128;
% All_pix_red_ycbcr(:,1) = 128;
% All_pix_blue_ycbcr(:,1) = 128;
% 
% All_pix_blue_ycbcr = histeq(All_pix_blue_ycbcr);
% All_pix_red_ycbcr = histeq(All_pix_red_ycbcr);
% All_pix_redblue_ycbcr = histeq(All_pix_redblue_ycbcr);

figure
% find Grey Pix Cr = 0 & Cb = 0
% Grey_pix = All_pix_red_ycbcr(:,2)<=1 & All_pix_red_ycbcr(:,3)<=1 & All_pix_red_ycbcr(:,3)>= (-1) & All_pix_red_ycbcr(:,2)>=(-1);
% h1=histogram2(All_pix_red_ycbcr(~Grey_pix,2),All_pix_red_ycbcr(~Grey_pix,3),'BinMethod','fd','Normalization','pdf','FaceColor',[1,0,0],'FaceAlpha',0.8);
h1=histogram2(All_pix_red_ycbcr(:,2),All_pix_red_ycbcr(:,3),'BinMethod','fd','Normalization','pdf','FaceColor',[1,0,0],'FaceAlpha',0.8);

hold on

% Grey_pix = All_pix_blue_ycbcr(:,2)<=1 & All_pix_blue_ycbcr(:,3)<=1 & All_pix_blue_ycbcr(:,3)>= (-1) & All_pix_blue_ycbcr(:,2)>=(-1);
% h2 =histogram2(All_pix_blue_ycbcr(~Grey_pix,2),All_pix_blue_ycbcr(~Grey_pix,3),'BinMethod','fd','Normalization','pdf','FaceColor',[0,0,1],'FaceAlpha',0.8);

h2 =histogram2(All_pix_blue_ycbcr(:,2),All_pix_blue_ycbcr(:,3),'BinMethod','fd','Normalization','pdf','FaceColor',[0,0,1],'FaceAlpha',0.8);
hold on
% Grey_pix = All_pix_redblue_ycbcr(:,2)<=1 & All_pix_redblue_ycbcr(:,3)<=1 & All_pix_redblue_ycbcr(:,3)>= (-1) & All_pix_redblue_ycbcr(:,2)>=(-1);
% h3 =histogram2(All_pix_redblue_ycbcr(~Grey_pix,2),All_pix_redblue_ycbcr(~Grey_pix,3),'BinMethod','fd','Normalization','pdf','FaceColor',[1,1,1],'FaceAlpha',0.5);
h3 =histogram2(All_pix_redblue_ycbcr(:,2),All_pix_redblue_ycbcr(:,3),'BinMethod','fd','Normalization','pdf','FaceColor',[1,1,1],'FaceAlpha',0.5);

hold on

 B_crcb.x_edge = get(h2,'YBinEdges');
 R_crcb.x_edge = get(h1,'YBinEdges');
 B_crcb.y_edge = get(h2,'XBinEdges');
 R_crcb.y_edge = get(h1,'XBinEdges');
 R_crcb.prob = get(h1,'Values');  
 B_crcb.prob = get(h2,'Values');
 
return
% Histogram Equalization - to better understanding of the distribution of
%========================================================================
% red_ycbcr_eq = All_pix_red_ycbcr;
% red_ycbcr_eq(:,2) = histeq(All_pix_red_ycbcr(:,2),60);
% red_ycbcr_eq(:,3) = histeq(All_pix_red_ycbcr(:,3),60);
% 
% blue_ycbcr_eq = All_pix_blue_ycbcr;
% blue_ycbcr_eq(:,2) = histeq(All_pix_blue_ycbcr(:,2),60);
% blue_ycbcr_eq(:,3) = histeq(All_pix_blue_ycbcr(:,3),60);
% 
% mix_ycbcr_eq = All_pix_redblue_ycbcr;
% mix_ycbcr_eq = histeq(All_pix_redblue_ycbcr(:,2),[min(All_pix_redblue_ycbcr(:,2)),max(All_pix_redblue_ycbcr(:,2))]);
% mix_ycbcr_eq = histeq(All_pix_redblue_ycbcr(:,3),60);



% figure
% h1=histogram2(red_ycbcr_eq(:,2),red_ycbcr_eq(:,3),'BinMethod','fd','Normalization','pdf','FaceColor',[1,0,0],'FaceAlpha',0.8);
% hold on
% h2 =histogram2(blue_ycbcr_eq(:,2),blue_ycbcr_eq(:,3),'BinMethod','fd','Normalization','pdf','FaceColor',[0,0,1],'FaceAlpha',0.8);
% hold on
% h3 =histogram2(mix_ycbcr_eq(:,2),mix_ycbcr_eq(:,3),'BinMethod','fd','Normalization','pdf','FaceColor',[1,1,1],'FaceAlpha',0.5);
% hold on


% Cb= get(h1,'XBinEdges');
% Cr= get(h1,'Values');
% Back_proj_RED = get(h1,'Values');

% ylim([50,300]);
% xlim([50,300])
xlabel('Cb');
xlabel('Cr');
title({'Signs that are labeled as RED';'Cr vs Cb (YCrCb) histogram ';add_title});
figure
h2 =histogram2(All_pix_blue_ycbcr(:,2),All_pix_blue_ycbcr(:,3),'BinMethod','scott','Normalization','pdf','FaceColor',[0,0,1]);
N = fewerbins(h2)
% ylim([50,300]);
% xlim([50,300])
xlabel('Cb');
xlabel('Cr');
title({'Signs that are labeled as BLUE';'Cr vs Cb (YCrCb) histogram '});
figure
h3 =histogram2(All_pix_redblue_ycbcr(:,2),All_pix_redblue_ycbcr(:,3),'BinMethod','scott','Normalization','probability','FaceColor',[1,1,1]);
% ylim([50,300]);
% xlim([50,300]);
xlabel('Cb');
xlabel('Cr');
title({'Signs that are labeled as MIXED';'Cr vs Cb (YCrCb) histogram '});
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
% function [] = plot3D(X1,X2,X3)
% 
% plot3(X1(:,:,1),X1(:,:,2),X1(:,:,3),'.k'); hold on
% plot3(X2(:,:,1),X2(:,:,2),X2(:,:,3),'or'); hold on
% plot3(X3(:,:,1),X3(:,:,2),X3(:,:,3),'xb'); hold on
% 
% grid on
% 
% end
