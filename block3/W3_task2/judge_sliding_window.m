function score = judge_sliding_window(bounding_box)
% Give a score between 0 and 1 to a bounding box that might contain a
% traffic sign. The score is affected by the filling ratio
%imshow(bounding_box);

score = 0;

filling_ratio = sum(bounding_box(:)==1)/length(bounding_box(:));
score = score + filling_ratio;          % I wrote it like this because I'm guessing we'll use more factors (LORENZO)

end