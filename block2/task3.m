function [masks_improved] = task3(masks,se,plots)

masks_filled = cell(length(se),length(masks));
masks_erode = cell(length(se),length(masks));
masks_improved = cell(length(se),length(masks));

for n = 1:length(masks)
    
    figure;
    
    for ii=1:length(se)
        
        masks_filled{ii,n} = imfill(masks{1,n},'holes');
        masks_erode{ii,n}=imerode(masks_filled{1,n},se{1,ii});
        
        %erode the mask with the different "brushes"
        
        masks_improved{ii,n}=imdilate(masks_erode{ii,n},se{1,ii});
        
        %dilate the eroded mask with the different "brushes"
        
        if strcmp(plots,'yes') == 1
            
            subplot(length(se),3,ii+ii*2-2);imshow(masks{1,n});title('mask');
            subplot(length(se),3,ii+ii*2-1);imshow(masks_erode{ii,n});title(['eroded ' num2str(length(se{1,ii}))]);
            subplot(length(se),3,ii+ii*2);imshow(masks_improved{ii,n});title(['eroded + dilated ' num2str(length(se{1,ii}))]);
            %dilate the eroded mask with the same "brushes" used before
        end
    end
end

end

