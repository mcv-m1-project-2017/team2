function positive_bounding_boxes = remove_duplicates(positive_bounding_boxes, positive_bounding_boxes_coordinates)
% This function takes in a list of bounding boxes and their coordinates
% with respect to the original image that returned a positive detection for
% the same object. The output is the bounding box that returns the highest
% confidence in the detection.

% new_list_of_pos_bound_boxes = [];
% new_list_of_pos_bound_boxes_coordinates = [];

for i=1:(length(positive_bounding_boxes)-1)
    %positive_bounding_boxes_coordinates = positive_bounding_boxes_coordinates(:);
    %similarity = positive_bounding_boxes_coordinates;
    %if similarity > dunno_what
    
        % could do: check for the highest filling ratio and drop the
        % lowest. But what if a smaller sliding window has filling ratio=1
        % but it doesn't contain all the sign? In this case the bigger
        % sliding window should be preferred (better for shape
        % recognition).
        %
        %   if something
            %pop first element
        %  else
            %pop second element
        % end
    %end
    
end
end