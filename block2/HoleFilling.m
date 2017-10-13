function BW2 = HoleFilling (im)
%      im='00.004928.jpg';
    I =imread(im);
    Igray= rgb2gray(I);
    BW= im2bw(Igray);

    BW2 = imfill(BW,'holes');
    imshow(BW);
end