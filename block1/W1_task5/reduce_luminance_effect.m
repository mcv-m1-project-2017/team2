function [ rgb_out ] = reduce_luminance_effect( rgb_in )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
plot_flag = false;
if plot_flag
    figure
    imshow(rgb_in);
    title('RGB');
end
% create simple white balance correction according to "grey- world" assumption
% ---------------------------------
 [ rgb_in ] = simple_WB( rgb_in );

if plot_flag
    figure
    imshow(rgb_in);
    title('RGB- after WB correction');
end
% RGB -- > Y Cb Cr (Illuminance- Blue - Red)
%-------------------------------------------
rgb_out = rgb2ycbcr(rgb_in);
if plot_flag
    figure
    imshow(rgb_out);
    title('Y-Cb-Cr');
end
% only Luminance - on the 0.5 plane for best Separation capability
%-----------------------------------------------------------------

mean_lumin = mean(mean(rgb_out(:,:,1)));
rgb_out(:,:,1)= 127;%round(rgb_out(:,:,1)./(mean_lumin/127.5));
if plot_flag
    figure
    imshow(rgb_out);
    title('Y-Cb-Cr, on Y=0.5 plane');
end
% back to RGB color space
%------------------------
rgb_out = ycbcr2rgb(rgb_out);
if plot_flag
    figure
    imshow(rgb_out);
    title('RGB- after luminance correction');
end



end

