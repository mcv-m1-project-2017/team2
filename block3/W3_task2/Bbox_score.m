% ------------------------------------------------------------------------- %
%                          B b o x _ s c o r e                              %
% ------------------------------------------------------------------------- %
% Function "Bbox_score" gives a score from [0,1] for a BBox according to it %
% proximity to the median values of the characterist from the statistic     %
% analysis on the training data set.                                        %
% the weighted combination of the scores for each feature is after used as  %
% a key to choose the most fitted Bbox , in case there is over lapping      %
%                                                                           %
%  Input parameters                                                         %
%   ----------------                                                        %
%        bbox_rect:  [x,y,w,h]                                              %
%                                                                           %
%        bbox_mask:  binary mask , "true" - mark a detection, [h X w]       %
%                                                                           %
%        weights  :  [3 X 1] , vector of weights for the 3 method           %
%                   (described bellow). sum is 1                            %
%                                                                           %
%        plot_flag:(Optional) ploting a subplot with 4 images with the Bbox %
%                  default : false                                          %
%        origin_im,main_idx:  (Optional) are only needed if you wish to     %
%                   create a plot                                           %
%                                                                           %
%   Output variables                                                        %
%   ----------------                                                        %
%        score: [0,1] , 1 is the best score
%
%   Method
%   ------
%       Combining 3 score The weights for each one as a defult are equal    %
%       (1/3)
%       (1) K means for the proximity to Clusteer center of the Shape,      %
%       using Fill-factor vs Mass Center (Vertical)                         %
%           Spliting the Data into 4 shapes:                                %
%               -Triangle Up,                                               %
%               -Triangle Down,                                             %
%               -Circle ,                                                   %
%               -Rectangle                                                  %
%                                                                           %
%       (2) Mass Center (Horizontal), Shapes are symmertic, higer score to  %
%           a symmetric shape.                                              %
%       (3) Aspect ratio, Higher score to 1:1 ratio between h:w             %
% -----------------------------------------------------------------------   %

% -----------------------------------------------------------------------   %


function [ score,sign ] = Bbox_score( bbox_rect_all, bbox_mask_all,weights )

if nargin<3
    weights = [1/4,1/4,1/4,1/4];
end
load('score_maps.mat');

for ii = 1: size(bbox_rect_all,1)
    bbox_mask = bbox_mask_all{ii};
    bbox_rect = bbox_rect_all(ii,:);
    % Calc ff
    ff_i = sum(bbox_mask(:))/length(bbox_mask(:));
    
    % Calc mc
    mc_i = centerOfMass(bbox_mask);
    mc_i = mc_i./size(bbox_mask);
    % vertical
    vmc_i = mc_i(1);
    % horizontal
    hmc_i = mc_i(2);
    
    % Calc ratio
    ratio = bbox_rect(4)/bbox_rect(3);
    
    sym_score = symmetric_test(bbox_mask);
    
    % SCORING
    %========
    % (1) ratio score
    if ratio<min(fr.C_fr) | ratio > max(fr.C_fr)
        ratio_score = 0;
    else
        ratio_score = interp1(fr.C_fr,fr.Weight,ratio,'nearest');
    end
    
    % (2) Horizintal score
    if hmc_i<min(hmc.C_hmc) | hmc_i > max(hmc.C_hmc)
        hmc_score = 0;
    else
        hmc_score = interp1(hmc.C_hmc,hmc.Weight,hmc_i,'nearest');
    end
    
    % (3) Horizintal score
    % loop on each shape
    %-------------------
    strct_names = {'TD','TU','Ci','R'};
    type_name = {'A','B','CDE','F'};
    for tt = 1: 4
        curent_map = eval(['ff_vmc_',strct_names{tt}]);
        
        if vmc_i<min(curent_map.C_vmc(:)) | vmc_i > max(curent_map.C_vmc(:)) | ff_i<min(curent_map.C_ff(:)) | ff_i > max(curent_map.C_ff(:))
            ff_vmc_score(tt) = 0;
        else
            ff_vmc_score(tt) = interp2(curent_map.C_vmc,curent_map.C_ff,curent_map.Weight,vmc_i,ff_i,'nearest');
        end
    end
    % Choosing the best score
    [ff_vmc_best_score ,imax]= max(ff_vmc_score);
    sign{ii} = type_name{imax};
    score(ii) = weights(1)*ff_vmc_best_score+weights(2)*hmc_score+weights(3)*ratio_score+weights(4)*sym_score;
end

end

