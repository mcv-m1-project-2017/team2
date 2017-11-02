function [] = DistanceTransform(img, bw)

    %GRAY
    % https://es.mathworks.com/help/images/ref/graydist.html
    cityblock_grey = graydist(img,bw,'cityblock');
    chessboard_grey = graydist(img,bw,'chessboard');
    quasiEuclidean_grey = graydist(img,bw,'quasi-euclidean');
    %BW
    % https://es.mathworks.com/help/images/ref/bwdist.html
    % https://es.mathworks.com/help/images/distance-transform-of-a-binary-image.html
    chessboard_bw = bwdist(bw,'chessboard');
    cityblock_bw = bwdist(bw,'cityblock');
    euclidean_bw = bwdist(bw,'euclidean');
    quasiEuclidean_bw = bwdist(bw,'quasi-euclidean');
    
    subplot(2,4,1), imshow(img); title('Grey scale image');
    subplot(2,4,2), imshow(cityblock_grey); title('Grey Cityblock');
    subplot(2,4,3), imshow(chessboard_grey); title('Grey Shessboard');
    subplot(2,4,4), imshow(quasiEuclidean_grey); title('Grey Quasi Euclidean');    
    
    subplot(2,4,5), imshow(chessboard_bw); title('Binary Chessboard');
    subplot(2,4,6), imshow(cityblock_bw); title('Binary Cityblock');
    subplot(2,4,7), imshow(euclidean_bw); title('Binary Euclidean');
    subplot(2,4,8), imshow(quasiEuclidean_bw); title('Binary Quasi Euclidean');
   

end