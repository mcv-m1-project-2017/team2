function [diff] = task1(masks, se, plots)

masks_erode=masks;masks_dilate=masks;masks_open=masks;masks_close=masks;masks_tophat=masks;
masks_bothat=masks;masks_open2=masks;masks_close2=masks;masks_tophat2=masks;masks_bothat2=masks;
% initialization of the different morphological operators

diff=repmat(struct('open',[],'close',[],'tophat',[],'bothat',[]),[length(masks),1]);

for n = 1:length(masks)
    
    masks_erode{1,n} = imerode(masks{1,n},se);
    masks_dilate{1,n} = imdilate(masks{1,n},se);
    
    masks_open{1,n} = imopen(masks{1,n},se);
    masks_close{1,n} = imclose(masks{1,n},se);
    masks_tophat{1,n} = imtophat(masks{1,n},se);
    masks_bothat{1,n} = imbothat(masks{1,n},se);
    
    %create the different morphological operators using dilate and erosion
    
    masks_open2{1,n} = imdilate(imerode(masks{1,n},se),se);               %open = erode then dilate
    masks_close2{1,n} = imerode(imdilate(masks{1,n},se),se);              %close = dilate then erode
    masks_tophat2{1,n} = masks{1,n}-imdilate(imerode(masks{1,n},se),se);  %tophat = erode then dilate then substract it from the mask
    masks_bothat2{1,n} = imerode(imdilate(masks{1,n},se),se)-masks{1,n};  %bothat = dilate then erode then substract the mask from it
    
    %compute the difference between them
    
    diff(n).open = mean(mean(masks_open{1,n} - masks_open2{1,n}));
    diff(n).close = mean(mean(masks_close{1,n} - masks_close2{1,n}));
    diff(n).tophat = mean(mean(masks_tophat{1,n} - masks_tophat2{1,n}));
    diff(n).bothat = mean(mean(masks_bothat{1,n} - masks_bothat2{1,n}));
    
    %plot the results
    
    if strcmp(plots,'yes') == 1
        
        figure('Name',['mask ' num2str(n)],'NumberTitle','off');
        subplot(1,3,1);imshow(masks{1,n});title('mask');
        subplot(1,3,2);imshow(masks_erode{1,n});title('erode');
        subplot(1,3,3);imshow(masks_dilate{1,n});title('dilate');
        
        figure('Name',['mask ' num2str(n)],'NumberTitle','off');
        subplot(2,5,1);imshow(masks{1,n});title('mask');
        subplot(2,5,2);imshow(masks_open{1,n});title('open');
        subplot(2,5,3);imshow(masks_close{1,n});title('close');
        subplot(2,5,4);imshow(masks_tophat{1,n});title('tophat');
        subplot(2,5,5);imshow(masks_bothat{1,n});title('bothat');
        subplot(2,5,6);imshow(masks{1,n});title('mask');
        subplot(2,5,7);imshow(masks_open2{1,n});title('open2');
        subplot(2,5,8);imshow(masks_close2{1,n});title('close2');
        subplot(2,5,9);imshow(masks_tophat2{1,n});title('tophat2');
        subplot(2,5,10);imshow(masks_bothat2{1,n});title('bothat2');
    end
    
end

%diff=diff(1:5); %CHANGE WHEN COMPUTING ALL MASKS

end

