function [diff2, time] = task2(masks, se, plots)

mask = masks{1,floor(rand(1)*length(masks))+1}; %select a mask randomly

diff2=repmat(struct('erode',[],'dilate',[]),[length(se),1]); %diff is the difference between the results
%of imdilate/dilate_lorenzo and imerode/erode_lorenzo 

for ii=1:length(se)
    
    mask_erode = imerode(mask, se{1,ii});
    mask_dilate = imdilate(mask, se{1,ii});
    mymask_erode = erode_lorenzo(mask, se{1,ii});
    mymask_dilate = dilate_lorenzo(mask, se{1,ii});
    
    diff2(ii).erode = mean(mean(mymask_erode - mask_erode));
    diff2(ii).dilate = mean(mean(mymask_dilate - mask_dilate));
    
    if strcmp(plots,'yes') == 1
        figure('Name',['imerode/imdilate and erode_lorenzo/dilate_lorenzo using se size ' num2str(length(se))],'NumberTitle','off');
        subplot(2,2,1);imshow(mask_erode);title('erode');subplot(2,2,2);imshow(mask_dilate);title('dilate');
        subplot(2,2,3);imshow(mymask_erode);title('erode_lorenzo');subplot(2,2,4);imshow(mymask_dilate);title('dilate_lorenzo');
        figure('Name',['difference using se size ' num2str(length(se))],'NumberTitle','off');
        subplot(1,2,1);imshow(mymask_erode-mask_erode);title('erode_lorenzo-imerode');
        subplot(1,2,2);imshow(mymask_dilate-mask_dilate);title('dilate_lorenzo-imdilate');
    end
    
end

time = repmat(struct('erode',[],'dilate',[],'erode_lorenzo',[],'dilate_lorenzo',[]),[1,1]);
tic
imerode(mask, se{1,ii});
time(1).erode = toc;
tic
imdilate(mask, se{1,ii});
time(1).dilate = toc;
tic
erode_lorenzo(mask, se{1,ii});
time(1).erode_lorenzo = toc;
tic
dilate_lorenzo(mask, se{1,ii});
time(1).dilate_lorenzo = toc;

end