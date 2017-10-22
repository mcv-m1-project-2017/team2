function output= task3_eval (method)
    TP=0; 
    FP=0;
    FN=0; 
    TN=0;
    folder = strcat('W2_task3/',method);

    test_files_names = dir(folder);

    for ii = 3:(size(test_files_names)-1)
        im_full_path = test_files_names(ii).name;
        maskResult = imread(strcat('W2_task3/',method,'/',im_full_path));
        maskProvided = imread(strcat('../train/mask/mask.',im_full_path(1:9),'.png'));

        [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(maskResult, maskProvided);

        TP = pixelTP + TP;
        FP = pixelFP + FP;
        FN = pixelFN + FN;
        TN = pixelTN + TN;
    end
    [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFN, pixelFP, pixelTN);

    % [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity]

    precision = TP / (TP+FP);
    accuracy = (TP+TN) / (TP+FN+FP+TN);

    recall= TP/(TP+FN);



    methods = repmat(struct('pixelPrecision',[],'pixelAccuracy',[],'pixelSpecificity',[],'pixelSensitivity',[],...
        'TruePositives', [], 'TrueNegatives', [], 'FalsePositives', [], 'FalseNegatives', [], ...
        'Precision', [], 'Accuracy', [], 'Recall', [], 'F1', []),[1,1]);

    methods(1).pixelPrecision = pixelPrecision ;
    methods(1).pixelAccuracy  = pixelAccuracy;
    methods(1).pixelSpecificity = pixelSpecificity;
    methods(1).pixelSensitivity = pixelSensitivity;

    methods(1).TruePositives = TP ;
    methods(1).TrueNegatives  = TN;
    methods(1).FalsePositives = FP;
    methods(1).FalseNegatives = FN;

    methods(1).Precision  = precision;
    methods(1).Accuracy = accuracy;
    methods(1).Recall = recall;
    methods(1).F1 = 2*(precision*recall)/(precision+recall);

    Evaluation = struct2table(methods);
    display(Evaluation);
end

