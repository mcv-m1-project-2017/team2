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
function [ results ] = W3_task1( masks_dir,out_dir,minmax_area,minmax_ratio,minmax_ff,plot_flag )

% test mask
%==============================
masks_dir = 'C:\Users\noamor\Documents\GitHub\team2\team2\block2\masks';
test_mask = '00.005894_mask.png';
masks_list{1} = test_mask;
plot_flag = true;
% according to statistics on training data-set
if nargin < 3|| isempty(minmax_area)
    minmax_area = [890,56000];
end
if nargin < 4 || isempty(minmax_ratio)
    minmax_ratio = [0.43,1.42];
end
if nargin < 5 || isempty(minmax_ff)
    minmax_ff(1,:)   =   [0.48,0.54]; % Triangale
    minmax_ff(2,:)   =   [0.51,0.85]; % Circle
    minmax_ff(3,:)   =   [0.97,1.1]; % Rectangle
end
%=============================
%=============================

% Creating a list of all the masks in the directory
masks_list = dir(fullfile(masks_dir,'.png'));
masks_list = {masks_list.name};

% Loop on each mask
for ii = 1: length(masks_list)
    % (1). load mask:
    %^^^^^^^^^^^^^^^^
    cur_mask = imread(fullfile(masks_dir,masks_list{ii}));
    % connect neigbour pixels
    %------------------------
    CC = bwconncomp(cur_mask);
    
    % Get regions properties
    %-----------------------
    S = regionprops(CC);
    if plot_flag
        txt_title = {['There are ',num2str(CC.NumObjects),'Connected Regions'];['No Elimantion were made'] };

        plot_bBox(cur_mask,S,1,txt_title)
%         subplot(2,2,1);
%         imshow(cur_mask); hold on;
%         
%         clr = hsv(length(S));
%         for ss = 1: length(S)
%             % Box Area (Num Pixels
%             % plot each squre
%             h_rec(ss)   =   rectangle('Position',S(ss).BoundingBox,'EdgeColor',clr(ss,:),'LineWidth',2); hold on
%             h_center(ss) =  plot(S(ss).Centroid(1),S(ss).Centroid(2),'Marker','+','MarkerFaceColor',clr(ss,:),'LineWidth',2,'MarkerEdgeColor',clr(ss,:)); hold on
%             pause(1)
%         end
%         title({['There are ',num2str(CC.NumObjects),'Connected Regions'];['No Elimantion were made'] });
%         % Detect connected componnent
    end
    % removing outliers according to the fetaures:
    %   (1) BBOX AREA
    %   (2) RATIO
    %   (3) Filling -Factor
    %   (4) Centroid location [ from ul corner [distance in precentage
    %           [x - l]/width,[y-u]/height
    BoundingBox= reshape([S.BoundingBox],4,[])';
    
    % BBOX AREA
    A = BoundingBox(:,3).*BoundingBox(:,4);
    % RATIO H/W
    Ratio = BoundingBox(:,3)./BoundingBox(:,4);
    
    
    
    Idx = A>=min(minmax_area) & A<=max(minmax_area) &  Ratio>=min(minmax_ratio) & Ratio<=max(minmax_ratio)&  FF>=min(minmax_ratio) & FF<=max(minmax_ratio);
    S = S(Idx);
    
    if plot_flag
        txt_title = {['Only ', num2str(length(S)),' Connected Regions '];' after size and ration filtering'};

         plot_bBox(cur_mask,S,2,txt_title)
%         subplot(2,2,1);
%         imshow(cur_mask); hold on;
        
%         clr = hsv(length(S));
%         for ss = 1: length(S)
%             % Box Area (Num Pixels
%             % plot each squre
%             h_rec(ss)   =   rectangle('Position',S(ss).BoundingBox,'EdgeColor',clr(ss,:),'LineWidth',2); hold on
%             h_center(ss) =  plot(S(ss).Centroid(1),S(ss).Centroid(2),'Marker','+','MarkerFaceColor',clr(ss,:),'LineWidth',2,'MarkerEdgeColor',clr(ss,:)); hold on
%             pause(1)
%         end
%         title({['There are ',num2str(CC.NumObjects),'Connected Regions'];['Only ', num2str(length(S)),' after Bbox-size & Ratio filtering'] });
        % Detect connected componnent
    end
    % Filling Factor
    FF = [S.Area]./A(Idx);
    
    for ff= 1: size(minmax_ff,1)
        Idx =  FF>=min(minmax_ff) & FF<=max(minmax_ff);
        G{ff} = S(Idx);
    end
    if plot_flag
        txt_title = {['There are ',num2str(CC.NumObjects),'Connected Regions'];['Only ', num2str(length(S)),' after size and ration filtering'] };

        plot_bBox(cur_mask,S,3,txt_title)
%         imshow(cur_mask); hold on;
%         
%         clr = hsv(length(S));
%         for ss = 1: length(S)
%             % Box Area (Num Pixels
%             % plot each squre
%             h_rec(ss)   =   rectangle('Position',S(ss).BoundingBox,'EdgeColor',clr(ss,:),'LineWidth',2); hold on
%             h_center(ss) =  plot(S(ss).Centroid(1),S(ss).Centroid(2),'Marker','+','MarkerFaceColor',clr(ss,:),'LineWidth',2,'MarkerEdgeColor',clr(ss,:)); hold on
%             pause(1)
%         end
%         title({['There are ',num2str(CC.NumObjects),'Connected Regions'];['Only ', num2str(length(S)),' after size and ration filtering'] });
        % Detect connected componnent
    end
    
end
end
    function plot_bBox(cur_mask,S,sub_idx,txt_title)
        subplot(2,2,sub_idx);
        imshow(cur_mask); hold on;
        
        clr = hsv(length(S));
        for ss = 1: length(S)
            % Box Area (Num Pixels
            % plot each squre
            h_rec(ss)   =   rectangle('Position',S(ss).BoundingBox,'EdgeColor',clr(ss,:),'LineWidth',2); hold on
            h_center(ss) =  plot(S(ss).Centroid(1),S(ss).Centroid(2),'Marker','+','MarkerFaceColor',clr(ss,:),'LineWidth',2,'MarkerEdgeColor',clr(ss,:)); hold on
            pause(1)
        end
        title(txt_title);
        
        
    end