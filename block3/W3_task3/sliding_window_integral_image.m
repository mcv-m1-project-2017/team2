function [ output_args ] = sliding_window_integral_image(img, Win_size,step, out_dir,plot_flag,threshold_score,weights)

% This function takes an image, minimum and maximum values for each side of the
% sliding window and returns a list of bounding boxes that returned a positive
% detection. Multiple bounding boxes for the same object are avoided with the
% call to 'bb_decider()'.
dbstop if error
% positive_bounding_boxes = [];
bbox_candidates = [];

% Read image
% img = imread(img_path);
[height, width] = size(img);

% window size - according to the statistics analysis in the data set
% Area size options [ max,median,min];
% if nargin < 3
%     A = [56000,12000];
% end
if nargin<4
    % Ratio optios [min,median,max]
    
    step = 10;%[1.3,1,0.33];
end
if nargin<5
    out_dir = fullfile(pwd,'Sliding_window');
end
if ~isdir(out_dir)
    mkdir(out_dir);
end
if nargin<6
    plot_flag = false;
end
if nargin<7 
    threshold_score = 0.2;
end
if nargin<8
    
weights = [1/4,1/4,1/4,1/4];
end
% % all options
% %-----------
% alloptions = combvec(A,ratio)';
% Win_size = zeros(size(alloptions));
% Win_size(:,1) = sqrt(alloptions(:,1)./alloptions(:,2));
% Win_size(:,2) = Win_size(:,1).*alloptions(:,2);
% Win_size = round(Win_size);
% [~,I] = sort(alloptions(:,1),'descend');
% Win_size = Win_size(I,:);
clr = hsv(size(Win_size,1));
% for side_length=[size_min, floor((size_min+size_max)/2), size_max]          % Three different sliding window sizes
% suspicious_bBox = [];
counter = 1;


if plot_flag
    imshow(img); hold on
    axis equal
    h_cur_win = rectangle('Position',[0,0,1,1],'EdgeColor','b','LineWidth',1);
    
end


for side_length=1:size(Win_size,1)%[size_max,size_min ]                        % For testing, only two sizes of sliding window
    %     disp(side_length);
    for y=1:step:(height-Win_size(side_length,2))         % Slide vertically
        
        for x=1:step:(width-Win_size(side_length,1))      % Slide horizontally
           
            w = Win_size(side_length,1);
            h = Win_size(side_length,2);
            if plot_flag
                
                set(h_cur_win,'Position',[x,y,w,h])
                
                pause(0.005);
            end
            bounding_box = imcrop(img,[x,y,w,h]);
            %imshow(bounding_box);
            [score, bbox_relative]= judge_sliding_window_int(bounding_box,weights);
            
            if score > threshold_score     % If the confidence is high, save the bounding box
                x_tmp =x+bbox_relative(1)-1;
                y_tmp =y+bbox_relative(2)-1;
                w_tmp =bbox_relative(3);
                h_tmp =bbox_relative(4);
                if plot_flag
                    rectangle('Position',[x_tmp,y_tmp,w_tmp,h_tmp],'EdgeColor',clr(side_length,:),'LineWidth',1); hold on
                end
                %                 positive_bounding_boxes{counter} = bounding_box;
                % Need to create a struct containing file_id también
                bbox_candidates(counter,:) = [x_tmp,y_tmp,w_tmp,h_tmp];
                suspicious_scores(counter,:) = score;
                counter = counter +1;
            end
            
            
        end
    end
end

% Detect which bounding boxes refer to the same object
if isempty(bbox_candidates)
  

%     out_mask_name = fullfile(out_dir,[file_id,'_mask.png']);
%     imwrite(false(size(img)),out_mask_name);
%     out_mat_name = fullfile(out_dir,[file_id,'.mat']);
    windowCandidates = [];
%     save(out_mat_name,'windowCandidates');
else
    [bbox_candidates,ia,~ ]= unique(bbox_candidates,'rows');
    suspicious_scores = suspicious_scores(ia);
    % positive_bounding_boxes = positive_bounding_boxes(ia);
    [bbox_candidates,I2] = remove_duplicates(img, bbox_candidates,suspicious_scores);
    windowCandidates = [];
    for ss = 1: size(bbox_candidates,1)
        windowCandidates = [windowCandidates,struct('x',bbox_candidates(ss,1),'y',bbox_candidates(ss,2),'w',bbox_candidates(ss,3),'h',bbox_candidates(ss,4))];
    end
%     [ mask_out ] = mask_bbox( img,windowCandidates );
%     out_mask_name = fullfile(out_dir,[file_id,'_mask.png']);
%     imwrite(mask_out,out_mask_name);
%     out_mat_name = fullfile(out_dir,[file_id,'.mat']);
%     save(out_mat_name,'windowCandidates');
    if plot_flag
        close all
        imagesc(I2);
    end
end

end

