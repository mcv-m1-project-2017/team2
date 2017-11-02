function [] = CalculateEdges (I)
    close all;

    sobel = edge(I,'Sobel');
    canny = edge(I,'Canny');
    prewitt = edge(I,'Prewitt');
    roberts = edge(I,'Roberts');
    laplacianOfGausian = edge(I,'log');
    zerocross = edge(I,'zerocross');
    
    subplot(2,3,1), subimage(sobel); title('Sobel');
    subplot(2,3,2), subimage(canny); title('Canny');
    subplot(2,3,3), subimage(prewitt); title('Prewitt');
    subplot(2,3,4), subimage(roberts); title('Roberts');
    subplot(2,3,5), subimage(laplacianOfGausian); title('Laplacian of Gausian');
    subplot(2,3,6), subimage(zerocross); title('zerocross');
    
end 