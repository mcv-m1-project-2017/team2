function [ output_args ] = find_model_in_image( rgb_in,models ,plot_flag)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Xcroscoorelation - gives as the best 
hsv_im = rgb2hsv(rgb_in);
if plot_flag
    hFig = figure;
end
for ii = 1: length(models)
C = normxcorr2(models(ii).mask,hsv_im(:,:,1));
[ypeak, xpeak] = find(C==max(C(:)));
yoffSet = ypeak-size(models(ii).mask,1);
xoffSet = xpeak-size(models(ii).mask,2);
if plot_flag
    
    subplot(2,4,ii)
    
    imagesc(rgb_in);hold on
    hAx  = axes;
    imrect(hAx, [xoffSet+1, yoffSet+1, size(models(ii).mask,2), size(models(ii).mask,1)]);
    subplot(2,4,ii+4)
    imagesc(C);
    
end
end

