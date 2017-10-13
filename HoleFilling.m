function BW2 = HoleFilling (im)
%      im='00.004928.jpg';
    BW2 = imfill(im,'holes');
end