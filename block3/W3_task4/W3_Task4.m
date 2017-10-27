function [precision, sensitivity, accuracy] = W3_Task4 (annotation_dir, detection_dir)%(Ground_Truth_Bbox, Candidate_detection_BBox )

% annotation_dir = C:\Users\MI-CUENTA\team2\train\gt
detection_file_list = dir(fullfile(detection_dir,'*.mat'));

detection_file_list = {detection_file_list.name};

   
   TP=0; FN=0; FP=0;
   for ii=1:length(detection_file_list)
       
       file_id = detection_file_list{ii}(1:9);
       gt_filename = ['gt.', file_id, '.txt'];
       gt_filename = fullfile(annotation_dir,gt_filename);
       
       load(fullfile(detection_dir,detection_file_list{ii}));
       
       
      [annotations, ~] = LoadAnnotations(gt_filename);
    if isempty(windowCandidates)
        TP2 = 0;
        FN2 = length(annotations);
        FP2 = 0;
    else
      [TP2,FN2,FP2] = PerformanceAccumulationWindow(windowCandidates, annotations);
    end
        % 'detections'        List of windows marking the candidate detections
        % 'annotations'       List of windows with the ground truth positions of the objects

         %correctDetection = BBoxDet ^ BBoxGT / BBoxDet U BBoxGT %>0.5
    %      TN=0;%(size image x num images) - (tp+fn+fp)
    %      correctDetection = ((TP +TN)/(FP+FN)) >0.5;
    
%         [precision, sensitivity, accuracy] = PerformanceEvaluationWindow(TP, FN, FP);

        TP=TP+TP2;
        FN=FN+FN2;
        FP=FP+FP2;
        
   end
   [precision, sensitivity, accuracy] = PerformanceEvaluationWindow(TP, FN, FP);
end