function [selectedBbox, I2]= remove_duplicates(I, positive_bounding_boxes_coordinates,scores)
% This function takes in a list of bounding boxes and their coordinates
% with respect to the original image that returned a positive detection for
% the same object. The output is the bounding box that returns the highest
% confidence in the detection.

% new_list_of_pos_bound_boxes = [];
% new_list_of_pos_bound_boxes_coordinates = [];
% [ scores ] = Bbox_score( positive_bounding_boxes_coordinates, positive_bounding_boxes );
plot_flag =1;
[selectedBbox,selectedScore] = selectStrongestBbox(positive_bounding_boxes_coordinates,scores);

I2=insertObjectAnnotation(double(I),'rectangle',selectedBbox,cellstr(num2str(selectedScore)),'Color','r');
% for ii=1:(size(selectedBbox,1)-1)
%     overlapRatio = bboxOverlapRatio(selectedBbox(ii,:),selectedBbox(ii+1,:));
%     if overlapRatio>0
%         pause(1)
%     end
%     %positive_bounding_boxes_coordinates = positive_bounding_boxes_coordinates(:);
%     %similarity = positive_bounding_boxes_coordinates;
%     %if similarity > dunno_what
%     if plot_flag
%         
%      rectangle(selectedBbox(ii,:))
%         % could do: check for the highest filling ratio and drop the
%         % lowest. But what if a smaller sliding window has filling ratio=1
%         % but it doesn't contain all the sign? In this case the bigger
%         % sliding window should be preferred (better for shape
%         % recognition).
%         %
%         %   if something
%             %pop first element
%         %  else
%             %pop second element
%         % end
%     %end
%     
% end
 end