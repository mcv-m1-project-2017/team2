function [region_out, pix_out] = W3_Task4 (annotation_dir, detection_dir,provided_masks_dir,our_mask_dir)%(Ground_Truth_Bbox, Candidate_detection_BBox )
% region Evaluation

[ region_out] = region_eval( annotation_dir, detection_dir );
% pixal Evaluation

[pix_out] = pix_eval(our_mask_dir,provided_masks_dir);
end