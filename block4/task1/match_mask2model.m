% ------------------------------------------------------------------------- %
%                   m a t c h _ m a s k 2 m o d e l                         %
% ------------------------------------------------------------------------- %
% Function "match_mask2model"  create 1 model for a specific   %
% shape using the given masks and annotation of the training data-set.      %
%  Method
%  ------
% We will take the most common size - and it will be the output model size
% Each traffic sign will be rescales to fit the standart.
% The rescaling/resampelling will be using "???" algorithem, to preserve
% the contour behavier.
%
%
%  Input parameters                                                         %
%   ----------------                                                        %
%        given_mask_path:  a path to the folder that contain                %
%             mask.*.png    [string]                                        %
%        given_gt_path:  a path to the folder that contain the annotations  %
%             gt.*.txt      [string]                                        %
%                                                                           %
%        all_data:   struct containg the data of all the signs in the given %
%                   data-set. for this task the importent fields are:       %
%                       .file_id                                            %
%                                                                           %
%                       .shape  (4 options)                                 %
%                           circle                                          %
%                           down_tri                                        %
%                           up_tri                                          %
%                           cube                                            %
%                                                                           %
%                       .validation                                         %
%                          split between the training and the testing
%                          groups
%        shape : one from the list aabove [string]
%
%        model_size: (Optional) [1 x 2]
%                  size of output model matrix. default will be the median
%                  size of the training data- set.
%                                                                           %
%        plot_flag:(Optional) ploting a subplot with 4 images with the Bbox %
%                  default : false                                          %
%                                                                           %
%   Output variables
%   ----------------                                                        %
%        model_out: MxN Greyscale model , back ground is set as 0               %
% -----------------------------------------------------------------------   %

% ----------------------------------------------------------------------- %


function [ sign_type ] = match_mask2model( mask,bbox,models,threshold,method,plot_flag)

% Crop mask according to the bbox
current_mask = imcrop(mask,[bbox.x,bbox.y,bbox.w,bbox.h]);
siz_model  = size(models(1).mask);
siz = size(current_mask);

% Option 1 : resize the current mask to fit the size of the models
%       faster. 1 operation instead of 4
current_mask = imresize(current_mask,siz_model); % cubic algorithem
% Option 2 : resize the the model to fit the current mask
N = numel(current_mask);
    if plot_flag
        figure
        if method==1
            method_name = 'MAE';
        else
            method_name = 'Correlation';
        end
        suptitle (method_name);
        subplot(2,3,1)
        imshow(current_mask);
        title('mask (resized)');
    end
for ii = 1: length(models)
    
    if method ==1 % MSE
        tmp = abs(current_mask-models(ii).mask);
        mae(ii) = sum(tmp(:))/N;

    elseif method ==2 % Correlation
         tmp = normxcorr2(models(ii).mask,current_mask);
    end
    
    if plot_flag
        subplot(2,3,ii+1)
        imshow(tmp);
        title(['with ',models(ii).shape,': ',num2str(mae(ii))]);
    end
end

% Check if one of the mae is under the error_threshold (in case of mae)
    if method ==1 % MSE
        [M,I] = min(mae); % min error
        if M<threshold
            sign_type = models(I).shape;
        else
            sign_type = ''; % return empty;
            return
        end
        

    elseif method ==2 % Correlation
        
    end
    
        if plot_flag
        subplot(2,3,6)
        imshow(models(I).mask);
        title(['winning model : ',models(I).shape]);
    end
end