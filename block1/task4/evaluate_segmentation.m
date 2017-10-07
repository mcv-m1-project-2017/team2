%
% Evaluate colour segmentation
%
function [] = evaluate_segmentation(all_data)

    
    if strcmp(colour, 'blue')
        createMaskForBlue
    elseif strcmp(colour, 'red')
        createMaskForRed
    end
end