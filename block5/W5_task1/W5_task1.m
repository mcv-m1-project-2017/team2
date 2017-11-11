
% https://es.mathworks.com/help/images/examples/color-based-segmentation-using-k-means-clustering.html?prodcode=IP&language=en

function output = W5_task1(image)
    clc;
%     close all;
    % Read Image
    %image = imread('C:\Users\MI-CUENTA\team2\train\Images\01.003074.jpg');
   
   % figure; imshow(image), title('H&E image');

    % Convert Image from RGB Color Space to L*a*b* Color Space
    cform = makecform('srgb2lab');
    lab_he = applycform(image,cform);

    % Classify the Colors in 'a*b*' Space Using K-Means Clustering
    ab = double(lab_he(:,:,2:3));
    nrows = size(ab,1);
    ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,2);

    % -->#3 colours not good results, 4 a bit just,5 perfect results
    nColors = 5;


    % repeat the clustering 3 times to avoid local minima
    [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', 'Replicates',3);


    % Label Every Pixel in the Image Using the Results from KMEANS
    pixel_labels = reshape(cluster_idx,nrows,ncols);
    % imshow(pixel_labels,[]), title('image labeled by cluster index');

    % Create Images that Segment the H&E Image by Color.
    segmented_images = cell(1,3);
    rgb_label = repmat(pixel_labels,[1 1 3]);

    for k = 1:nColors
        color = image;
        color(rgb_label ~= k) = 0;
        segmented_images{k} = color;
    end
    % 

    %% 
    % guess with segmented images is closer to R and with is closer to B
    %cluster_center
    [szX,szY]=size(segmented_images{1});
    finalRed =zeros(szX,szY/3);
    finalBlue=finalRed;
    for segment = 1:nColors
%         [BW_red,~] = createMaskForRed(segmented_images{segment}, 0.9,0.13);
%         [BW_blue,~] = createMaskForBlue(segmented_images{segment}, 0.5,0.73);
        r=segmented_images{segment}(:,:,1);
        g=segmented_images{segment}(:,:,2);
        b=segmented_images{segment}(:,:,3);
        
        extra_blue = max(b-max(r,g),0);
        BW_blue = im2bw(extra_blue,0.1);
     
        extra_red = max(r-max(b,g),0);
        BW_red = im2bw(extra_red,0.1);
    
        
        se = strel('disk',3);
        BW_red = imerode(BW_red,se);
        BW_blue = imerode(BW_blue,se);
        figure;
subplot(1,3,1);imshow(segmented_images{segment});
subplot(1,3,2);imshow(BW_red);
subplot(1,3,3);imshow(BW_blue);

        sumRed =sum(BW_red(:));
        sumBlue= sum(BW_blue(:));
        maxR = sum(finalRed(:));
        maxB = sum(finalBlue(:));
        
        if (sumRed>maxR)
            finalRed=BW_red;
        end
        if (sumBlue>maxB)
            finalBlue=BW_blue;
        end
       
           
    end
figure;
subplot(1,3,1);imshow(image);
subplot(1,3,2);imshow(finalRed);
subplot(1,3,3);imshow(finalBlue);

output= or(finalRed, finalBlue);
    
   

    %%
    % pick :,:,1 for R and :,:,3 for B (mask)

    %%
    % add  masks (R+B)
    %%
%     figure;
%     subplot(2,2,1); imshow(segmented_images{1}), title('objects in cluster 1');
%     subplot(2,2,2); imshow(segmented_images{1}(:,:,1)>100), title('objects in cluster 1-1');
%     subplot(2,2,3); imshow(segmented_images{1}(:,:,2)>100), title('objects in cluster 1-2');
%     subplot(2,2,4); imshow(segmented_images{1}(:,:,3)>100), title('objects in cluster 1-3');
%     figure;
%     subplot(2,2,1); imshow(segmented_images{2}), title('objects in cluster 2');
%     subplot(2,2,2); imshow(segmented_images{2}(:,:,1)>100), title('objects in cluster 2-1');
%     subplot(2,2,3); imshow(segmented_images{2}(:,:,2)>100), title('objects in cluster 2-2');
%     subplot(2,2,4); imshow(segmented_images{2}(:,:,3)>100), title('objects in cluster 2-3');
%     figure;
%     subplot(2,2,1); imshow(segmented_images{3}), title('objects in cluster 3');
%     subplot(2,2,2); imshow(segmented_images{3}(:,:,1)>100), title('objects in cluster 3-1');
%     subplot(2,2,3); imshow(segmented_images{3}(:,:,2)>100), title('objects in cluster 3-2');
%     subplot(2,2,4); imshow(segmented_images{3}(:,:,3)>100), title('objects in cluster 3-3');
%     figure;
%     subplot(2,2,1); imshow(segmented_images{4}), title('objects in cluster 4');
%     subplot(2,2,2); imshow(segmented_images{4}(:,:,1)>100), title('objects in cluster 4-1');
%     subplot(2,2,3); imshow(segmented_images{4}(:,:,2)>100), title('objects in cluster 4-2');
%     subplot(2,2,4); imshow(segmented_images{4}(:,:,3)>100), title('objects in cluster 4-3');
%     figure;
%     subplot(2,2,1); imshow(segmented_images{5}), title('objects in cluster 5');
%     subplot(2,2,2); imshow(segmented_images{5}(:,:,1)>100), title('objects in cluster 5-1');
%     subplot(2,2,3); imshow(segmented_images{5}(:,:,2)>100), title('objects in cluster 5-2');
%     subplot(2,2,4); imshow(segmented_images{5}(:,:,3)>100), title('objects in cluster 5-3');
%     output =1;
end