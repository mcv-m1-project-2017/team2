function [ results ] = ROC_test_set( image_path,mask_path,all_data,type,hist_mapR,hist_mapB,hist_mapLR,hist_mapLB)
%ROC_test_set Summary of this function goes here
%   Detailed explanation goes here
% probability threshold
%----------------------
th = [0:0.05:1];
% results struct
%---------------
template = struct('red_th',0,'blue_th',0,'lum_th',[],'precision',0, 'recall',0);
% run it separtlly on RED and BULE
%---------------------------------


% only on test dataset
all_data = all_data([all_data.validation]==1);
if strcmp(type,'Ycbcr')
    
    for ii = 1: length(hist_mapL.prob)
        Norm_factorR(ii) = sum(hist_mapLR.prob(ii)*hist_mapR.prob(:));
        hist_mapLR.prob(ii) = Norm_factorR(ii)*hist_mapLR.prob(ii);
        
        Norm_factorB(ii) = sum(hist_mapLB.prob(ii)*hist_mapB.prob(:));
        hist_mapLB.prob(ii) = Norm_factorB(ii)*hist_mapLB.prob(ii);
    end
end
wbar = waitbar(0,'please wait while assessing the segmentation...');
AllOpt = length(th)^2*length(all_data);
Count = 0;
TP = zeros(length(th),length(th));
FP = TP;
FN = TP;
TN = TP;
for ii = 1: length(all_data)
    maskProvided = imread(fullfile(mask_path,['mask.',all_data(ii).file_id,'.png']));
    ImRGB = imread(fullfile(image_path,[all_data(ii).file_id,'.jpg']));
    [ ImRGB_wb ] = simple_WB( ImRGB );
    if strcmp(type,'hue')
        Im = rgb2hsv(ImRGB_wb);
        [ cur_maskR] = backprojection_prob( hist_mapR,Im(:,:,1) );
        
        [ cur_maskB] = backprojection_prob( hist_mapB,Im(:,:,1) );
        
    elseif strcmp(type,'YCrCb')
        Im = rgb2ycbcr(ImRGB_wb);
        [ cur_maskB] = backprojection_prob( hist_mapB,Im(:,:,2:3) );
        
        
        [ cur_maskR] = backprojection_prob( hist_mapR,Im(:,:,2:3) );
        [ cur_maskLR] = backprojection_prob( hist_mapLR,Im(:,:,1) );
        [ cur_maskLB] = backprojection_prob( hist_mapLB,Im(:,:,1) );
        
        
        cur_maskB = cur_maskB.*cur_maskLB;
        cur_maskR = cur_maskR.*cur_maskLR;
        
    end
    for rr = 1: length(th)
        for bb = 1: length(th)
            
            
            Count = Count+1;
            waitbar(Count/AllOpt);
            
            
            
            %             ImRGB_wb =ImRGB;
          
                
          
                
                maskResult = [cur_maskB>th(bb) | cur_maskR>th(rr)];
      
            % load Gold standart map - and compare
            
            [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(maskResult, maskProvided);
            
            TP(rr,bb) = pixelTP + TP(rr,bb);
            FP(rr,bb) = pixelFP + FP(rr,bb);
            FN(rr,bb) = pixelFN + FN(rr,bb);
            TN(rr,bb) = pixelTN + TN(rr,bb);
        end
        
        
    end
    
end
close (wbar);
for kk =1:length(th)
    for pp = 1:length(th)
        results(kk,pp) = template;
        results(kk,pp).red_th = th(kk);
        results(kk,pp).blue_th = th(pp);
        results(kk,pp).precision = TP(kk,pp) / (TP(kk,pp)+FP(kk,pp));
        
        
        results(kk,pp).recall= TP(kk,pp)/(TP(kk,pp)+FN(kk,pp));
    end
end
