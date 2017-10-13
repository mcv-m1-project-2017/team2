function [ diff2, time ] = task2T( masks, se, plots )

mask = masks{1,floor(rand(1)*length(masks))+1}; %select a mask randomly

diff2=repmat(struct('erode',[],'dilate',[]),[length(se),1]); %diff is the difference between the results
%of imdilate/mydilate and imerode/myerode 

for ii=1:length(se)
    
    mask_erode = imerode(mask, se{1,ii});
    mask_dilate = imdilate(mask, se{1,ii});
    mymask_erode = myerode(mask, se{1,ii});
    mymask_dilate = mydilate2(mask, se{1,ii});
    
    diff2(ii).erode = mean(mean(mymask_erode - mask_erode));
    diff2(ii).dilate = mean(mean(mymask_dilate - mask_dilate));
    
    if strcmp(plots,'yes') == 1
        figure('Name',['imerode/imdilate and myerode/mydilate using se size ' num2str(length(se))],'NumberTitle','off');
        subplot(2,2,1);imshow(mask_erode);title('erode');subplot(2,2,2);imshow(mask_dilate);title('dilate');
        subplot(2,2,3);imshow(mymask_erode);title('myerode');subplot(2,2,4);imshow(mymask_dilate);title('mydilate');
        figure('Name',['difference using se size ' num2str(length(se))],'NumberTitle','off');
        subplot(1,2,1);imshow(mymask_erode-mask_erode);title('myerode-imerode');
        subplot(1,2,2);imshow(mymask_dilate-mask_dilate);title('mydilate-imdilate');
    end
    
end

time = repmat(struct('erode',[],'dilate',[],'myerode',[],'mydilate',[]),[1,1]);
tic
imerode(mask, se{1,ii});
time(1).erode = toc;
tic
imdilate(mask, se{1,ii});
time(1).dilate = toc;
tic
myerode(mask, se{1,ii});
time(1).myerode = toc;
tic
mydilate(mask, se{1,ii});
time(1).mydilate = toc;

end

