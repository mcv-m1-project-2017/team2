function [ Im_prob_map ] = backprojection_prob( clr_map,Im )
%backprojection_prob Summary of this function goes here
%   Detailed explanation goes here
% I.INPUT
%========
%   (1) clr_map : a probability map
%       clr_map.N  an integer representing the number of dimenisions
%       clr_map.prob   =  a map of the probabilties [N1 X N2 X...],
%                       sum(clr_map.prob)==1;
%       clr_map.x_edge = is the edges values of the 1st Dimention ([N1+1 X 1])
%       clr_map.y_edge = is the edges of the 2nd Dimention ([N2+1 X 1])
%       and so on.... untill N dim
%           +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%           ** very importent! this field has to be sorted in ascending
%           order!!
%           +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%   (2) Im      : an image [l x c x N] (the 3 dim size is according to the
%   clr map)
%       for example :
%           # HSV color space   : we use only the HUE , so the N = 1.
%           # YCbCr             : we use only Cr,Cb , so the N = 2.
%
% II.OUTPUT
%==========
%   (1) Im_prob_map = [l x c]
%       -----------
%   each pixel will get a probability value [0,1] , His chance to belong to
%   the group the map represented

% Input check
%-------------

Im_prob_map = zeros(size(Im(:,:,1)));
if size(Im,3) ~= clr_map.N
    disp('The Number of layers in the Image does not fit the given map');
    return
end

for xx = 1: (length(clr_map.x_edge) -1)
    
    % if there is another dim
    if clr_map.N > 1
        for yy = 1: (length(clr_map.y_edge) -1)
            if clr_map.N > 2
                for zz = 1: (length(clr_map.z_edge) -1)
                    % This function doesnt support more than 3 dim
                       Idx = Im(:,:,1)>=clr_map.x_edge(xx) & Im(:,:,1)<clr_map.x_edge(xx+1) & Im(:,:,2)>=clr_map.y_edge(yy) & Im(:,:,2)<clr_map.y_edge(yy+1)& Im(:,:,3)>=clr_map.z_edge(zz) & Im(:,:,3)<clr_map.z_edge(zz+1);
                       Im_prob_map( Idx) = clr_map.prob(zz,yy,xx);
                end
            else
                Idx = Im(:,:,1)>=clr_map.x_edge(xx) & Im(:,:,1)<clr_map.x_edge(xx+1) & Im(:,:,2)>=clr_map.y_edge(yy) & Im(:,:,2)<clr_map.y_edge(yy+1);
                       Im_prob_map( Idx) = clr_map.prob(yy,xx);
 
            end
        end
    else
        % Only 1 Dimenision
        Idx = Im>=clr_map.x_edge(xx) & Im<clr_map.x_edge(xx+1) ;
        Im_prob_map(Idx) = clr_map.prob(xx);
        
    end
end
end

