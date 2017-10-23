% I.Function Description : W3_task1
%==========================================
% II. INPUT:
%==========
%   1. masks_dir
%       The directory of the masks ( After preforming Color segmantation, hole-filling, Opening & closing).
%       *.png
%
%   2. out_dir:
%       Output directories to save the new masks
%
%   3. minmax_area
%       min max value of the Box Area (pix)
%       uses to elimenates outliers Boxes
%
%   4. minmax_ratio
%       h/w of the Bbx
%       uses to elimenates outliers Boxes
%
%   3. plot_flag
%       To create histograms of the statistical analysis.
%
% III. OUTPUT
%============
%   1. results :
%       List of BBox for each image.
function [ S_final ] = W3_task1( masks_dir,image_dir,out_dir,statistic_table,plot_flag )

% test mask
%==============================
if nargin<1
    masks_dir = 'C:\Users\noamor\Documents\GitHub\team2\team2\block2\W2_task3\m1';
end
if nargin<2
    image_dir = 'C:\Users\noamor\Documents\GitHub\team2\team2\train';
end
if nargin<3
    out_dir = pwd;
end
% test_mask = '00.005894_mask.png';
% masks_list{1} = test_mask;

% according to statistics on training data-set
if nargin < 4|| isempty(statistic_table)
    minmax_area = [890,56000];
    minmax_ratio = [0.43,1.42];
    minmax_mc_col = [0.45, 0.58];
    
    minmax_ff(1,:)   =   [0.42,0.6]; % Triangale
    minmax_ff(2,:)   =   [0.42,0.6]; % Triangale_Up
    minmax_ff(3,:)   =   [0.49,0.89]; % Circle
    minmax_ff(4,:)   =   [0.96,1.1]; % Rectangle
    
    minmax_mc_row(1,:)   =   [0.61,0.74]; % Triangale
    minmax_mc_row(2,:)   =   [0.29,0.41]; % Triangale_Up
    minmax_mc_row(3,:)   =   [0.44,0.55]; % Circle
    minmax_mc_row(4,:)   =   [0.44,0.55]; % Rectangle
else
    %     Tri =
    %     minmax_ff(1,:)  =   statistic_table(ismember(statistic_table.type,{'A','B'})).form_factor)
end
% if nargin < 4 || isempty(minmax_ratio)
%     minmax_ratio = [0.43,1.42];
% end
% if nargin < 5 || isempty(minmax_ff)
%     minmax_ff(1,:)   =   [0.48,0.54]; % Triangale
%     minmax_ff(2,:)   =   [0.51,0.85]; % Circle
%     minmax_ff(3,:)   =   [0.97,1.1]; % Rectangle
% end
if nargin<4
    plot_flag = false;
end
%=============================
%=============================

% Creating a list of all the masks in the directory
masks_list = dir(fullfile(masks_dir,'*.png'));
masks_list = {masks_list.name};
% count_total = 1;
S_final = [];
% Loop on each mask
for ii = 1: length(masks_list)
    % (1). load mask:
    %^^^^^^^^^^^^^^^^
    cur_mask = imread(fullfile(masks_dir,masks_list{ii}));
    % connect neigbour pixels
    %------------------------
    [ S_cur ] = find_bBox( cur_mask,masks_list{ii}(1:9),[],plot_flag,fullfile(image_dir,[masks_list{ii}(1:9),'.jpg']),ii );
    S_final = [S_final;S_cur];
    
    %     CC = bwconncomp(cur_mask);
%     
%     % Get regions properties
%     %-----------------------
%     S = regionprops(CC,'Solidity','BoundingBox','Centroid','Area','EulerNumber');
%     if plot_flag & ~isempty(image_dir)
%         txt_title = 'The Original Image ';
%         im = imread(fullfile(image_dir,[masks_list{ii}(1:9),'.jpg']));
%         figure(ii)
%         subplot(2,2,1)
%         imshow(im);
%         title(txt_title);
%     end
%     if 0%plot_flag
%         txt_title = {['There are ',num2str(CC.NumObjects),'Connected Regions'];['No Elimantion were made'] };
%         
%         plot_bBox(cur_mask,S,1,ii,txt_title);
% 
%     end
%     % removing outliers according to the fetaures:
%     %   (1) BBOX AREA
%     %   (2) RATIO
%     %   (3) Filling -Factor
%     %   (4) Centroid location [ from ul corner [distance in precentage
%     %           [x - l]/width,[y-u]/height
%     BoundingBox= reshape([S.BoundingBox],4,[])';
%     
%     % BBOX AREA
%     A = BoundingBox(:,3).*BoundingBox(:,4);
%     % RATIO H/W
%     Ratio = BoundingBox(:,3)./BoundingBox(:,4);
%     
%     
%     
%     Idx = A>=min(minmax_area) & A<=max(minmax_area) &  Ratio>=min(minmax_ratio) & Ratio<=max(minmax_ratio);
%     S = S(Idx);
%     A = A(Idx);
%     BoundingBox = BoundingBox(Idx,:);
%     if plot_flag
%         txt_title = {['Only ', num2str(length(S)),' Connected Regions '];' after size and ratio filtering'};
%         
%         plot_bBox(cur_mask,S,2,ii,txt_title)
% 
% 
%     end
%     
%     % Mass Center Col (horizontal)
%     Centroid = reshape([S.Centroid],2,[])';
%     MC = [Centroid-BoundingBox(:,1:2)]./[BoundingBox(:,3:4)];
%     Idx = MC(:,1)>=min(minmax_mc_col) & MC(:,1)<=max(minmax_mc_col) ;
%     S = S(Idx);
%     MC = MC(Idx,:);
%     A = A(Idx);
%     if plot_flag
%         txt_title = {['Only ', num2str(length(S)),' Connected Regions '];' after Mass Center (Col) filtering'};
%         
%         plot_bBox(cur_mask,S,3,ii,txt_title)
%     end
%     % Filling Factor
%     FF = [S.Area]'./A;
%     %     BoundingBox= reshape([S.BoundingBox],4,[])';
%     %     Centroid = reshape([S.Centroid],2,[])';
%     %     MC = [Centroid-BoundingBox(:,1:2)]./[BoundingBox(:,3:4)];
%     clr = hsv(size(minmax_ff,1));
%     count = 1;
%     S_cur_final = [];
%     clr_final = [];
%     for ff= 1: size(minmax_ff,1)
%         Idx =  FF>=min(minmax_ff(ff,:)) & FF<=max(minmax_ff(ff,:)) & MC(:,2)>=min(minmax_mc_row(ff,:)) & MC(:,2)<=max(minmax_mc_row(ff,:));
%         tmp = S(Idx);
%         for gg = 1: length(tmp)
%             S_final(count_total).file_id        = masks_list{ii}(1:9);
%             S_final(count_total).BoundingBox    = tmp(gg).BoundingBox;
%             S_final(count_total).sub_idx        = count;
%             S_cur_final = [S_cur_final;tmp(gg)];
%             clr_final(count,:) = clr(ff,:);
%             count = count+1;
%             count_total = count_total+1;
%         end
%         
%         
%     end
%     
%     
%     if plot_flag & ~isempty(S_cur_final)
%         txt_title = {['There are ',num2str(num2str(length(S_cur_final))),'Connected Regions'];['FF vs MC (vertical)'] };
%         
%         plot_bBox(cur_mask,S_cur_final,4,ii,txt_title,clr_final)
%         %         imshow(cur_mask); hold on;
%         %
%         %         clr = hsv(length(S));
%         %         for ss = 1: length(S)
%         %             % Box Area (Num Pixels
%         %             % plot each squre
%         %             h_rec(ss)   =   rectangle('Position',S(ss).BoundingBox,'EdgeColor',clr(ss,:),'LineWidth',2); hold on
%         %             h_center(ss) =  plot(S(ss).Centroid(1),S(ss).Centroid(2),'Marker','+','MarkerFaceColor',clr(ss,:),'LineWidth',2,'MarkerEdgeColor',clr(ss,:)); hold on
%         %             pause(1)
%         %         end
%         %         title({['There are ',num2str(CC.NumObjects),'Connected Regions'];['Only ', num2str(length(S)),' after size and ration filtering'] });
%         % Detect connected componnent
%     end

    
end
end
% function plot_bBox(cur_mask,S,sub_idx,main_idx,txt_title,clr)
% figure(main_idx);
% subplot(2,2,sub_idx);
% imshow(cur_mask); hold on;
% 
% if nargin<6
%     clr = hsv(length(S));
% end
% for ss = 1: length(S)
%     % Box Area (Num Pixels
%     % plot each squre
%     h_rec(ss)   =   rectangle('Position',S(ss).BoundingBox,'EdgeColor',clr(ss,:),'LineWidth',1); hold on
%     h_center(ss) =  plot(S(ss).Centroid(1),S(ss).Centroid(2),'Marker','+','MarkerFaceColor',clr(ss,:),'LineWidth',1,'MarkerEdgeColor',clr(ss,:)); hold on
%     pause(1)
% end
% title(txt_title);
% 
% 
% end