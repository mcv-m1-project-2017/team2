function [ S_out ] = find_bBox( cur_mask,file_id,statistic_table,plot_flag,origin_im,main_idx )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
S_out = [];
if nargin<4
    plot_flag = false;
    % sub_idx and main idx are only for the plotting
end
% according to statistics on training data-set
if nargin < 3|| isempty(statistic_table)
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
CC = bwconncomp(cur_mask);

% Get regions properties
%-----------------------
S = regionprops(CC,'Solidity','BoundingBox','Centroid','Area','EulerNumber');
if plot_flag
    txt_title = 'The Original Image ';
    im = imread(origin_im);
    figure(main_idx)
    subplot(2,2,1)
    imshow(im);
    title(txt_title);
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



Idx = A>=min(minmax_area) & A<=max(minmax_area) &  Ratio>=min(minmax_ratio) & Ratio<=max(minmax_ratio);
S = S(Idx);
A = A(Idx);
BoundingBox = BoundingBox(Idx,:);
if plot_flag
    txt_title = {[ num2str(length(S)),' Connected Regions '];' after size and ratio filtering'};
    
    plot_bBox(cur_mask,S,2,main_idx,txt_title)
    
    
end

% Mass Center Col (horizontal)
Centroid = reshape([S.Centroid],2,[])';
MC = [Centroid-BoundingBox(:,1:2)]./[BoundingBox(:,3:4)];
Idx = MC(:,1)>=min(minmax_mc_col) & MC(:,1)<=max(minmax_mc_col) ;
S = S(Idx);
MC = MC(Idx,:);
A = A(Idx);
if plot_flag
    txt_title = {[ num2str(length(S)),' Connected Regions '];' after Mass Center (Col) filtering'};
    
    plot_bBox(cur_mask,S,3,main_idx,txt_title)
end
% Filling Factor
FF = [S.Area]'./A;
%     BoundingBox= reshape([S.BoundingBox],4,[])';
%     Centroid = reshape([S.Centroid],2,[])';
%     MC = [Centroid-BoundingBox(:,1:2)]./[BoundingBox(:,3:4)];
clr = hsv(size(minmax_ff,1));
count = 0;
clr_final = [];
S_final = [];
for ff= 1: size(minmax_ff,1)
    Idx =  FF>=min(minmax_ff(ff,:)) & FF<=max(minmax_ff(ff,:)) & MC(:,2)>=min(minmax_mc_row(ff,:)) & MC(:,2)<=max(minmax_mc_row(ff,:));
    tmp = S(Idx);
    
    for gg = 1: length(tmp)
        count = count+1;
        S_out(count).file_id        = file_id;
        S_out(count).BoundingBox    = tmp(gg).BoundingBox;
        S_out(count).sub_idx        = count;
        S_final = [S_final;tmp(gg)];
        clr_final(count,:) = clr(ff,:);
        
       
    end
    
    
end


if plot_flag & ~isempty(S_final)
    txt_title = {['There are ',num2str(num2str(length(S_final))),'Connected Regions'];['FF vs MC (vertical)'] };
    
    plot_bBox(cur_mask,S_final,4,main_idx,txt_title,clr_final)
    
end

S_out = S_out(:);
end

function plot_bBox(cur_mask,S,sub_idx,main_idx,txt_title,clr)
figure(main_idx);
subplot(2,2,sub_idx);
imshow(cur_mask); hold on;

if nargin<6
    clr = hsv(length(S));
end
for ss = 1: length(S)
    % Box Area (Num Pixels
    % plot each squre
    h_rec(ss)   =   rectangle('Position',S(ss).BoundingBox,'EdgeColor',clr(ss,:),'LineWidth',1); hold on
    h_center(ss) =  plot(S(ss).Centroid(1),S(ss).Centroid(2),'Marker','+','MarkerFaceColor',clr(ss,:),'LineWidth',1,'MarkerEdgeColor',clr(ss,:)); hold on
    pause(1)
end
title(txt_title);


end