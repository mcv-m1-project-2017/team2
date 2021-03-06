function [out] = W1_task4 (all_data,our_mask_path,provided_mask_path)
    TP=0; 
    FP=0;
    FN=0; 
    TN=0;
    
   for ii = 1:size({all_data.file_id},2)
        maskResult = imread(strcat(our_mask_path,'\',all_data(ii).file_id, '_maskFinal.png'));
        maskProvided = imread(strcat(provided_mask_path,'\mask.',all_data(ii).file_id, '.png'));
            
        [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(maskResult, maskProvided);
      
        TP = pixelTP + TP;
        FP = pixelFP + FP;
        FN = pixelFN + FN;
        TN = pixelTN + TN;
   end

   [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(TP, FP, FN, TN);
   
   

   
out.Recall      = TP/(TP+FN);
out.Precision   = pixelPrecision;
out.Accuracy    = pixelAccuracy;
out.Specificity = pixelSpecificity;
out.Sensitivity = pixelSensitivity;
   
end
