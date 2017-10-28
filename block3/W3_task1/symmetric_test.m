function [ score ] = symmetric_test( bbox_mask )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
siz = size(bbox_mask);
left_side = bbox_mask(:,1:floor(siz(2)/2));
right_side = bbox_mask(:,ceil(siz(2)/2)+1:end);
% flip right_side
right_side = fliplr(right_side);
eq = [left_side== right_side];

score= sum(eq(:))/length(left_side(:));
end

