function [R_hue,B_hue,R_crcb, B_crcb,R_y,B_y ] = colors_signs_statatistics( data_set_path, all_data,image_processing_flag ,plot_flag)
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

R_y= struct('N',1,'prob',0,'x_edge',[0,1]);
B_y= struct('N',1,'prob',0,'x_edge',[0,1]);
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


% RGB to HSV ( cause our threshould is of the Hue)


Max_vec = max([length(All_pix_red),length(All_pix_blue),length(All_pix_redblue)]);
All_pix_red_hsv= nan(Max_vec,1,3);
All_pix_blue_hsv = nan(Max_vec,1,3);
All_pix_redblue_hsv = nan(Max_vec,1,3);

All_pix_red_hsv(1:length(All_pix_red),1,:)  = rgb2hsv(All_pix_red);
All_pix_blue_hsv(1:length(All_pix_blue),1,:) = rgb2hsv(All_pix_blue);
All_pix_redblue_hsv(1:length(All_pix_redblue),1,:) = rgb2hsv(All_pix_redblue);


%
step = 0.025;
% create the axis res
%-------------------

ce = [0:step:1]';

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
    bar(ce,[nRB,nR,nB],'stacked');
    legend('mix signs','Red sign','blue sign'); hold on
    title({'** each sign has a B&W element as well'});
    subplot(2,1,2)
    bar(ce,[R,B],'stacked');
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
ce4 = [0:1:255]';
LRGrp = hist(double(All_pix_red_ycbcr(:,1)),ce4);
LRGrp = LRGrp./max(LRGrp(:));
RGrp = hist3(double(All_pix_red_ycbcr(:,2:3)),{ce3,ce3});
RGrp = RGrp./max(RGrp(:));
LBGrp = hist(double(All_pix_blue_ycbcr(:,1)),ce4);
LBGrp = LBGrp./max(LBGrp(:));
BGrp = hist3(double(All_pix_blue_ycbcr(:,2:3)),{ce3,ce3});
BGrp = BGrp./max(BGrp(:));
LMixGrp= hist(double(All_pix_redblue_ycbcr(:,1)),ce4);
LMixGrp = LMixGrp./max(LMixGrp(:));
MixGrp = hist3(double(All_pix_redblue_ycbcr(:,2:3)),{ce3,ce3});
MixGrp = MixGrp./max(MixGrp(:));

R = RGrp.*MixGrp;
R = R./max(R(:));

B = BGrp.*MixGrp;
B = B./max(B(:));

RL = LRGrp.*LMixGrp;
RL = RL./max(RL(:));

BL = LBGrp.*LMixGrp;
BL = BL./max(BL(:));

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
    
    title('** each sign has a B&W element as well');
    
    subplot(2,1,2)
    Ri = griddata(ce3,ce3,R,xq,yq,'nearest');
    surf(xq,yq,Ri,'FaceColor',[1,0,0]); hold on
    Bi = griddata(ce3,ce3,B,xq,yq,'nearest');
    surf(xq,yq,Bi,'FaceColor',[0,0,1]); hold on
    title('conditional probability');
    a = Bi>0 | Ri>0;
    ylim([min(xq(a)),max(xq(a))]);
    xlim([min(xq(a)),max(xq(a))]);
    
    
    suptitle(['YCbCr Histogram,',add_title]);
    
    figure
    subplot(2,1,1)
    bar(ce4,[LMixGrp(:),LBGrp(:),LRGrp(:)],'stacked');
    title('** each sign has a B&W element as well');
    
    legend('Mix','Blue','Red');
    subplot(2,1,2)
    bar(ce4,[BL(:),RL(:)],'stacked');
    
    legend('Blue','Red');
    title('conditional probability');
    suptitle('Traffic sign''s Luminance (Ycbcr) , of training data set');
    
end









B_crcb.x_edge = [ce3-step/2;max(ce3)+step/2];
R_crcb.x_edge = [ce3-step/2;max(ce3)+step/2];
R_y.x_edge = [ce4-step/2;max(ce4)+step/2];
B_y.x_edge = [ce4-step/2;max(ce4)+step/2];
B_crcb.y_edge = [ce3-step/2;max(ce3)+step/2];
R_crcb.y_edge = [ce3-step/2;max(ce3)+step/2];
R_crcb.prob = R;
B_crcb.prob = B;
R_y.prob = RL;
B_y.prob = BL;


end
