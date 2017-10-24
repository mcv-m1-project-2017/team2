function [positive_bounding_boxes, counter] = W3_task2(img_path, img_name, A, ratio, counter)

% This function takes an image, minimum and maximum values for each side of the
% sliding window and returns a list of bounding boxes that returned a positive
% detection. Multiple bounding boxes for the same object are avoided with the
% call to 'bb_decider()'.
dbstop if error
positive_bounding_boxes = [];
positive_bounding_boxes_coordinates = [];

% Read image
img = imread(img_path);
[height, width] = size(img);

% window size - according to the statistics analysis in the data set
% Area size options [ max,median,min];
if nargin < 3 
A = [56000,12000];
end
if nargin<4
% Ratio optios [min,median,max]

ratio = 1;%[1.3,1,0.33];
end
% all options
%-----------
alloptions = combvec(A,ratio)';
Win_size = zeros(size(alloptions));
Win_size(:,1) = sqrt(alloptions(:,1)./alloptions(:,2));
Win_size(:,2) = Win_size(:,1).*alloptions(:,2);
Win_size = round(Win_size);
[~,I] = sort(alloptions(:,1),'descend');
Win_size = Win_size(I,:);
clr = hsv(size(Win_size,1));
% for side_length=[size_min, floor((size_min+size_max)/2), size_max]          % Three different sliding window sizes
suspicious_bBox = [];
counter = 1;
plot_flag = true;

if plot_flag
    imshow(img); hold on
    axis equal
     h_cur_win = rectangle('Position',[0,0,1,1],'EdgeColor','b','LineWidth',1);

end
step = 10;

for side_length=1:size(Win_size,1)%[size_max,size_min ]                        % For testing, only two sizes of sliding window
    %     disp(side_length);
    for y=1:step:(height-Win_size(side_length,2))         % Slide vertically
        
        for x=1:step:(width-Win_size(side_length,1))      % Slide horizontally
             number_of_non_zeroes = sum(img(y:y+Win_size(side_length,2),x:end)>0);
             if number_of_non_zeroes == 0
                 break
             end
            w = Win_size(side_length,1);
            h = Win_size(side_length,2);
            if plot_flag

                    set(h_cur_win,'Position',[x,y,w,h])

                pause(0.005);
            end
            bounding_box = imcrop(img,[x,y,w,h]);
            %imshow(bounding_box);
            [score, bbox_relative]= judge_sliding_window(bounding_box);
            
            if score > 0.5     % If the confidence is high, save the bounding box
                x_tmp =x+bbox_relative(1);
                y_tmp =y+bbox_relative(2);
                w_tmp =bbox_relative(3);
                h_tmp =bbox_relative(4);
                if plot_flag
                    rectangle('Position',[x_tmp,y_tmp,w_tmp,h_tmp],'EdgeColor',clr(side_length,:),'LineWidth',1); hold on
                end
                positive_bounding_boxes{counter} = bounding_box;
                % Need to create a struct containing img_name también
                suspicious_bBox = [suspicious_bBox,struct('x',x_tmp,'y',y_tmp,'w',w_tmp,'h',h_tmp)];
                positive_bounding_boxes_coordinates(counter,:) = [x_tmp,y_tmp,w_tmp,h_tmp];
                suspicious_scores(counter,:) = score;
                counter = counter +1;
            end
            
            
        end
    end
end

% Detect which bounding boxes refer to the same object
[positive_bounding_boxes_coordinates,ia,ic ]= unique(positive_bounding_boxes_coordinates,'rows');
suspicious_scores = suspicious_scores(ia);
 [positive_bounding_boxes] = remove_duplicates(positive_bounding_boxes, positive_bounding_boxes_coordinates,suspicious_scores);

 A=1;
end

