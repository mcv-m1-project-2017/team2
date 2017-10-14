function [masks_improved, maskResult] = task3(masks, se, plots, method,fillFlag)

masks_filled = cell(length(se),length(masks));
masks_erode = cell(length(se),length(masks));
masks_improved = cell(length(se),length(masks));


    if (method ==1) %imfill+opening (erode+dilate)
        for n = 1:length(masks)

            figure;

            for ii=1:length(se)

                if(fillFlag==0)
                        masks_filled{ii,n} = masks{1,n};
                else
                       masks_filled{ii,n} = imfill(masks{1,n},'holes');
                end

                masks_erode{ii,n}=imerode(masks_filled{1,n},se{1,ii});

                %erode the mask with the different "brushes"

                masks_improved{ii,n}=imdilate(masks_erode{ii,n},se{1,ii});

                %dilate the eroded mask with the different "brushes"

                if strcmp(plots,'yes') == 1

                    subplot(length(se),3,ii+ii*2-2);imshow(masks{1,n});title('mask');
                    subplot(length(se),3,ii+ii*2);imshow(masks_improved{ii,n});title(['eroded + dilated ' num2str(length(se{1,ii}))]);
                    %dilate the eroded mask with the same "brushes" used before
                end
                maskResult = masks_improved{ii,n};
            end
        end
    elseif (method==2) % imfill+closing(dilate+erode)
            for n = 1:length(masks)

                figure;

                for ii=1:length(se)

                    if(fillFlag==0)
                        masks_filled{ii,n} = masks{1,n};
                    else
                        masks_filled{ii,n} = imfill(masks{1,n},'holes');
                    end

                    masks_erode{ii,n}=imdilate(masks_filled{1,n},se{1,ii});

                    %erode the mask with the different "brushes"

                    masks_improved{ii,n}=imerode(masks_erode{ii,n},se{1,ii});

                    %dilate the eroded mask with the different "brushes"

                    if strcmp(plots,'yes') == 1

                        subplot(length(se),3,ii+ii*2-2);imshow(masks{1,n});title('mask');
                        subplot(length(se),3,ii+ii*2);imshow(masks_improved{ii,n});title(['dilated + erode' num2str(length(se{1,ii}))]);
                        %dilate the eroded mask with the same "brushes" used before
                    end
                    maskResult = masks_improved{ii,n};
                end
            end
    else %imfill+erode
        for n = 1:length(masks)

                figure;

                for ii=1:length(se)

                    %masks_filled{ii,n} = imfill(masks{1,n},'holes');
                    if(fillFlag==0)
                        masks_filled{ii,n} = masks{1,n};
                    else
                        masks_filled{ii,n} = imfill(masks{1,n},'holes');
                    end
                    %erode the mask with the different "brushes"
                    masks_filled{ii,n}=imerode(masks_filled{1,n},se{1,ii});

                    if strcmp(plots,'yes') == 1

                        subplot(length(se),3,ii+ii*2-2);imshow(masks{1,n});title('mask');
                        subplot(length(se),3,ii+ii*2-1);imshow(masks_filled{ii,n});title(['eroded ' num2str(length(se{1,ii}))]);
                        %dilate the eroded mask with the same "brushes" used before
                    end
                    maskResult =  masks_improved{ii,n};
                end
        end
        %whitebalancing+ imfill+opening
       % mask_temp = task3(masks, se, plots, 1);
    end
    
   
end

