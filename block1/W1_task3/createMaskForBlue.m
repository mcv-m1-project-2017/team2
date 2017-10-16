function [BW,maskedRGBImage] = createMaskForBlue(RGB, channel1Min, channel1Max)
    % Convert RGB image to HSV image
    I = rgb2hsv(RGB);
    % Define thresholds for 'Hue'. Modify these values to filter out different range of colors.

    % Define thresholds for 'Saturation'
    channel2Min = 0;
    channel2Max = 1;

    % Define thresholds for 'Value'
    channel3Min = 0;
    channel3Max = 1;

    % Create mask based on chosen histogram thresholds
    BW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    % Initialize output masked image based on input image.
    maskedRGBImage = RGB;
    % Set background pixels where BW is false to zero.
    %%%BLUE%%%%
    maskedRGBImage(repmat(BW,[1 1 3])) = 0;
end