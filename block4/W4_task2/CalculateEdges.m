function [] = CalculateEdges (img, bw)
    close all;

    %GRAY
    sobel_grey = edge(img,'Sobel');
    canny_grey = edge(img,'Canny');
    prewitt_grey = edge(img,'Prewitt');
    roberts_grey = edge(img,'Roberts');
    laplacianOfGausian_grey = edge(img,'log');
    zerocross_grey = edge(img,'zerocross');
    
    % BW
    sobel_bw = edge(bw,'Sobel');
    canny_bw = edge(bw,'Canny');
    prewitt_bw = edge(bw,'Prewitt');
    roberts_bw = edge(bw,'Roberts');
    laplacianOfGausian_bw = edge(bw,'log');
    zerocross_bw = edge(bw,'zerocross');
    
    subplot(4,3,1), imshow(sobel_grey); title('Grey Sobel');
    subplot(4,3,2), imshow(canny_grey); title('Grey Canny');
    subplot(4,3,3), imshow(prewitt_grey); title('Grey Prewitt');
    subplot(4,3,4), imshow(roberts_grey); title('Grey Roberts');
    subplot(4,3,5), imshow(laplacianOfGausian_grey); title('Grey Laplacian of Gausian');
    subplot(4,3,6), imshow(zerocross_grey); title('Grey Zerocross');
    
    
    subplot(4,3,7), imshow(sobel_bw); title('Binary Sobel');
    subplot(4,3,8), imshow(canny_bw); title('Binary Canny');
    subplot(4,3,9), imshow(prewitt_bw); title('Binary Prewitt');
    subplot(4,3,10), imshow(roberts_bw); title('Binary Roberts');
    subplot(4,3,11), imshow(laplacianOfGausian_bw); title('Binary Laplacian of Gausian');
    subplot(4,3,12), imshow(zerocross_bw); title('Binary Zerocross');
end 