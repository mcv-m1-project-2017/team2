function [precision, accuracy] = task4 (all_data)
    TP=0; 
    FP=0;
    FN=0; 
    TN=0;
    
   for ii = 1:size({all_data.file_id},2)
        maskResult = imread(strcat('block1\task3\masks\',all_data(ii).file_id, '_mask.png'));
        maskProvided = imread(strcat('train\train\mask\mask.',all_data(ii).file_id, '.png'));
            
        [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(maskResult, maskProvided);
      
        TP = pixelTP + TP;
        FP = pixelFP + FP;
        FN = pixelFN + FN;
        TN = pixelTN + TN;
   end

   [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFN, pixelFP, pixelTN);
   
   [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity]

   precision = TP / (TP+FN)
   accuracy = (TP+TN) / (TP+FN+FP+TN)
end
