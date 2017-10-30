function [ windowCandidates ] = sliding_window_integral_image(img, Win_size,step, out_dir,plot_flag,threshold_score,weights,mask)

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
if nargin<3
    % Ratio optios [min,median,max]
    
    step = 10;%[1.3,1,0.33];
end
if nargin<4
    out_dir = fullfile(pwd,'Sliding_window');
end
if ~isdir(out_dir)
    mkdir(out_dir);
end
if nargin<5
    plot_flag = false;
end
if nargin<6
    threshold_score = 0.2;
end
if nargin<7
    
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
    figure(200)
    subplot(1,2,1)
    imshow(mask); hold on
    h_cur_win1 = rectangle('Position',[0,0,1,1],'EdgeColor','b','LineWidth',1);
    subplot(1,2,2)
    imagesc(img); colormap gray;

    hold on
    axis equal
    xlim([1,size(img,2)]);
    ylim([1,size(img,1)]);
    h_cur_win = rectangle('Position',[0,0,1,1],'EdgeColor','b','LineWidth',1);
    
end


for side_length=1:size(Win_size,1)%[size_max,size_min ]                        % For testing, only two sizes of sliding window
    %     disp(side_length);
    w_win = Win_size(side_length,1);
    h_win  = Win_size(side_length,2);
    for y=1:step:(height-Win_size(side_length,2))         % Slide vertically
        
        for x=1:step:(width-Win_size(side_length,1))      % Slide horizontally
           if rectangleWindow(img,x,y,h_win+y-1,width) < 350 % the minimum number of pix in a shape = min(ff) in the min(box size)
               
               break
           end

            if plot_flag
                
                set(h_cur_win,'Position',[x,y,w_win,h_win])
                set(h_cur_win1,'Position',[x,y,w_win,h_win])
                
                pause(0.005);
            end
             bounding_box  = crop_int_img( img,[x,y,w_win,h_win] );


            [score, bbox_relative]= judge_sliding_window_Int(bounding_box,weights);
            
            if score > threshold_score     % If the confidence is high, save the bounding box
                x_tmp =x+bbox_relative(1)-1;
                y_tmp =y+bbox_relative(2)-1;
                w_tmp =bbox_relative(3);
                h_tmp =bbox_relative(4);
                if plot_flag
                    figure(200)
                    subplot(1,2,1)
                    rectangle('Position',[x_tmp,y_tmp,w_tmp,h_tmp],'EdgeColor',clr(side_length,:),'LineWidth',1); hold on
                    subplot(1,2,2)
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
  


    windowCandidates = [];

else
    [bbox_candidates,ia,~ ]= unique(bbox_candidates,'rows');
    suspicious_scores = suspicious_scores(ia);
    % positive_bounding_boxes = positive_bounding_boxes(ia);
    [bbox_candidates,I2] = remove_duplicates(img, bbox_candidates,suspicious_scores);
    windowCandidates = [];
    for ss = 1: size(bbox_candidates,1)
        windowCandidates = [windowCandidates,struct('x',bbox_candidates(ss,1),'y',bbox_candidates(ss,2),'w',bbox_candidates(ss,3),'h',bbox_candidates(ss,4))];
    end

    if plot_flag
        close all
        imagesc(I2);
    end
end

end

