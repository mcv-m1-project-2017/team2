% ------------------------------------------------------------------------- %
%        c r e a t e _ s h a p e _ g r e y _ s c a l e _ m o d e l          %
% ------------------------------------------------------------------------- %
% Function "create_shape_grey_scale_model"  create 1 model for a specific   %
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


function [ model_out ] = create_shape_grey_scale_model( given_mask_path,given_gt_path,all_data,shape,model_size,resample_method,plot_flag)

switch shape
    case 'up_tri'
        type = 'A';
    case 'down_tri'
        type = 'B';
    case 'circle'
        type = {'C','D','E'};
    case 'cube'
        type = 'F';
end
if nargin<5
    model_size = [125,125]; % need to finish
end
if nargin <6
    resample_method = 'bicubic';
end
if nargin <7
    plot_flag = false;
end
model_out = zeros(model_size);

% I. List according to shape
all_data_shape = all_data([strcmp({all_data.shape},shape)] & [([all_data.validation]==0)]);

% Apperently the numeric index dont have an expected behaviar
% So we have can trust it
    [~,idx,~] = unique({all_data_shape.file_id});
    % Area and form will be only of the first sign
    all_data_shape = all_data_shape(idx);
% II. Loop on all Traffic signs masks
count = 0;
for ii = 1: length(all_data_shape)
    curent_mask_file    = fullfile(given_mask_path,['mask.',all_data_shape(ii).file_id,'.png']);
    current_gt          = fullfile(given_gt_path,['gt.',all_data_shape(ii).file_id,'.txt']);
    [annotations, sign_type] = LoadAnnotations(current_gt);
    
    for tt = 1: length(annotations)
        if ~any(strcmp(type,sign_type{tt}))
            continue
        end
       curent_bbox = annotations(tt); 
       current_mask = imread(curent_mask_file);
    current_traffic = imcrop(current_mask,[curent_bbox.x,curent_bbox.y,curent_bbox.w,curent_bbox.h]);
    % creating a logic map (ignoring the traffic index)
    current_traffic = current_traffic>0;
     % resize it according to [MxN]
    current_traffic_fit = imresize(current_traffic,model_size,resample_method);
    
    % adding to the model
    model_out = model_out + current_traffic_fit;
    count = count+1;
    end
    
    % assuming index correspond with the order of the list
%     if all_data_shape(ii).index>length(annotations)
%         disp(all_data_shape(ii).file_id);
%         curent_bbox = annotations(length(annotations));
%         if ~any(strcmp(type,sign_type{length(annotations)}))
%             disp(['Mismatch type to shape: ', shape ,'-',sign_type{length(annotations)}])
%         end
%     else
%         curent_bbox = annotations(all_data_shape(ii).index);
%         if ~any(strcmp(type,sign_type{all_data_shape(ii).index}))
%             disp(['Mismatch type to shape: ', shape ,'-',sign_type{all_data_shape(ii).index}]);
%             
%         end
%     end
    
%     current_mask = imread(curent_mask_file);
%     current_traffic = imcrop(current_mask,[curent_bbox.x,curent_bbox.y,curent_bbox.w,curent_bbox.h]);
%     % creating a logic map (ignoring the traffic index)
%     current_traffic = current_traffic>0;
%     
%     % resize it according to [MxN]
%     current_traffic_fit = imresize(current_traffic,model_size,resample_method);
%     
%     % adding to the model
%     model_out = model_out + current_traffic_fit;
end

% we calc the mean value
model_out = model_out./count;
disp(['"',shape,'"',' (Grey-scale Model) is based on ',num2str(count),' signs']);

end