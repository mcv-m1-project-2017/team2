function [ TP,TN,FP,FN ] = evaluate_segmentation( mask,clr,ground_truth,file_id, all_data )
% evaluate_segmentation 
%   this function evaluate the quality of the
%   segmentation . comparing the mask with the ground truth mask
% INPUT
%------
% 1. mask [NXM] uint8
%   0 - background
%   1 - a pixal with a "traffic sign"
%
% 2. clr - the clr of the mask (var #1)
%   can be 'blue' or 'red'
%
% 3. ground_truth  [NXM] uint8
%   0 - background
%   0< - a pixal with a "traffic sign"(each index represents a single
%   traffic sign)
%
% 4. file_id
%   the id of the mask- to know which patch (index in the ground truth) is
%   contain which color (red\blue)
%
% OUTPUT
%-------
%   (1) TP [number of pixels]
%       true positive 
%   (2) TPR[ 0,1]
%       true positie rate 
%   (3) TN [number of pixels]
%       true nagitive
%   (4) TNR[ 0,1]
%       true nagitive rate 
%   (5) FP [number of pixels]
%       false positie rate
%   (6) FPR[ 0,1]
%       false positie rate 
%   (7) FN [number of pixels]
%       false nagitive
%   (8) FNR[ 0,1]
%       false nagitive rate 

% STAGE I
%---------
% initializing varaibles

TP = -1;
TN = -1;
FP = -1;
FN = -1;
% STAGE II
% checking which kind of signals we have in the ground truth mask
current_im_data = all_data(strcmp({all_data.file_id},file_id));

for ii = 1: length(current_im_data)
    
% STAGE III
% comparing the ground truth of only sign type that contain clr 
%--------------------------------------------------------------
switch clr
    case 'red'
        % if this sign type suppose to have red but dont have- remove it
        % from the comparosion
        if current_im_data(ii).color_wrbk(2)==0
            ground_truth(ground_truth==current_im_data(ii).index) = 0;
        end
    case 'blue'
        % if this sign type suppose to have blue but dont have- remove it
        % from the comparosion
        if current_im_data(ii).color_wrbk(3)==0
            ground_truth(ground_truth==current_im_data(ii).index) = 0;
        end
    otherwise
        disp([clr , 'does not exist!']);
        return
end    
end

        
P_GT = [ ground_truth>0]; % positivie pixels in Ground Truth mask    
TP = [mask==1 & P_GT];
TP = sum(TP(:));



N_GT = [ground_truth==0]; % background pixels in Ground Truth mask    
TN = [mask==0 & N_GT];
TN = sum(TN(:));


FP = [mask==1 & N_GT];
FP = sum(FP(:));


FN = [mask==0 & P_GT];
FN = sum(FN(:));


end

