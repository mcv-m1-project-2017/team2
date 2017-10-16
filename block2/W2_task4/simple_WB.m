function [ rgb_out ] = simple_WB( rgb_in )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

rgb_out = zeros(size(rgb_in));
dim = size(rgb_in,3);
% find the average for each color R-G-B
% and normalize it proportionally to the "classic" grey
for jj=1:dim
    scalVal=sum(sum(rgb_in(:,:,jj)))/numel(rgb_in(:,:,jj));
    rgb_out(:,:,jj)=rgb_in(:,:,jj)*(127.5/scalVal);
end
rgb_out=uint8(rgb_out);
end

