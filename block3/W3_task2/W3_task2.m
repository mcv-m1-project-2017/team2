function [positive_bounding_boxes] = W3_task2(img_path, size_min, size_max)

% This function takes an image, minimum and maximum values for each side of the 
% sliding window and returns a list of bounding boxes that returned a positive
% detection. Multiple bounding boxes for the same object are avoided with the
% call to 'bb_decider()'.

positive_bounding_boxes = [];
counter = 1;

% Read image
img = imread(img_path);
[height, width] = size(img);

for side_length=[size_min, floor((size_min+size_max)/2), size_max]          % Three different sliding window sizes
    disp(side_length);
    for y=[1:floor(side_length/3):height]          % Slide vertically
        for x=[1:floor(side_length/3):width]       % Slide horizontally
            
            bounding_box = imcrop(img,[x,y,side_length,side_length]);
            %imshow(bounding_box);
            score = judge_sliding_window(bounding_box);
            
            if score > 0.80     % If the confidence is high, save the bounding box
                positive_bounding_boxes(counter) = bounding_box;
                counter = counter +1;
            end
            
            
        end
    end
end

% Detect which bounding boxes refer to the same object
[positive_bounding_boxes] = remove_duplicates(positive_bounding_boxes);

end

