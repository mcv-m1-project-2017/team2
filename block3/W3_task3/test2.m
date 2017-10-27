
close all;

%image = magic(20);
image= imread('C:\Users\MI-CUENTA\team2\test4bestThresholdWB\test0\00.000978_maskFinal.png');
figure;
imshow(image);


ii =  integralImage(image);
figure;
imagesc(ii);

x1=270;
y1= 250;
w = 1000;
h = 1000;

s= rectangleWindow(ii, x1, y1, w, h);


fillfactor= s/(w*h);

%mass center

stats = regionprops(ii, 'Centroid');
centroids = cat(1, stats.Centroid); 
figure;
imshow(ii)
hold on
plot(centroids(:,1),centroids(:,2), 'b*')
hold off

