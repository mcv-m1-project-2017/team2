%
% Find the non-zero entry of a mask image and set each of
% its neighbours (found through a structuring element) to one.
%

function [mask_copy] = OurDilate(mask, se)
    
    se_matrix = se;
    [r,c] = size(se_matrix);
    centre = [ceil(r/2),ceil(c/2)];         % Coordinates of the centre of se
    [r_rel,c_rel] = find(se_matrix);        % Coordinates of non-zero entries in se
    
    % This matrix will contain the coordinates relative to the centre of
    % se for non-zero entries. They will be used when finding the
    % coordinates of the neighbours of each non-zero entry of the mask.
    coordinates = zeros(length(r_rel),2);
    
    for i=1:length(r_rel)
        coordinates(i,1) = r_rel(i)-centre(1);
        coordinates(i,2) = c_rel(i)-centre(2);
    end
    
    mask_copy = mask;
    [row,col] = find(mask);         % Coordinates of each non-zero entry in the mask
    
    for i=1:length(row)             % For every non-zero entry in the mask, set its neighbours to 1.
        x = row(i);
        y = col(i);
        
        for j=1:length(coordinates)                   % for every 1 in se
            
            temp_x = row(i)+coordinates(j,1);
            temp_y = col(i)+coordinates(j,2);
            
            % If any of the coordinates is outside the picture, ignore this
            % pair of coordinates
            if temp_x < 1 || temp_x > 1236 || temp_y < 1 || temp_y > 1628
                continue
            end
            mask_copy(temp_x,temp_y) = 1;

        end
        
    end
    
%     figure;
%     subplot(3,1,1);imshow(mask);title('Original Mask');
%     subplot(3,1,2);imshow(mask_copy);title('out dilate');
%     subplot(3,1,3);imshow(imdilate(mask, se));title('Matlabs dilate');
    
    difference = mask_copy-imdilate(mask, se);
    %figure;
    %imshow(difference);title('Difference');
    [row_diff,col_diff] = find(difference);
    %disp(row_diff);
    %disp(col_diff);
    disp(nnz(difference));             % Display number of non-zero elements in the difference. If 0, the two images are the same

end