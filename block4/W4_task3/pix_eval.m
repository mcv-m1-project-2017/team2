function [out] = pix_eval(our_mask_path,provided_mask_path)
TP=0;
FP=0;
FN=0;
TN=0;

list_our_masks = dir(fullfile(our_mask_path,'*.png'));
list_our_masks = {list_our_masks.name};
for ii = 1:length(list_our_masks)
    file_id = list_our_masks{ii}(1:9);
    maskProvided = imread(strcat(provided_mask_path,'\mask.',file_id, '.png'));

    maskResult = imread(strcat(our_mask_path,'\',list_our_masks{ii}));

    
    [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(maskResult, maskProvided);
    
    TP = pixelTP + TP;
    FP = pixelFP + FP;
    FN = pixelFN + FN;
    TN = pixelTN + TN;
end

[pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(TP, FP, FN, TN);


out.TP  = TP;
out.FN  = FN;
out.FP  = FP;
out.TN  = TN;

out.Recall      = TP/(TP+FN);
out.Precision   = pixelPrecision;
out.Accuracy    = pixelAccuracy;
out.Specificity = pixelSpecificity;
out.Sensitivity = pixelSensitivity;
out.F1 = 2*(out.Precision*out.Recall)/(out.Precision+out.Recall);

end
