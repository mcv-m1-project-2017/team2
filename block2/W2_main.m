
%---------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------
%                       M1 BLOCK 2: IMPLEMENTATION OF MORPHOLOGICAL OPERATORS
%---------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------


%---------------------------------------------------------------------------------------------------
% Initialization and necessary data

clear all;close all;
addpath(genpath(fileparts(mfilename('fullpath'))));

%image_folder = fullfile(fileparts(mfilename('fullpath')),'masks');
image_folder = '../block5/W5_task1/new_masks';
%folder where the masks are

filenames = dir(fullfile(image_folder, '*.jpg'));
%read all images with specified extention, its png in our case

nmasks = numel(filenames);
%count total number of photos present in that folder

masks= cell(1,nmasks);
%initialize masks cell

for n = 1:nmasks
    masks{1,n} = imfill(imread([filenames(n).name]),'holes');
end
% 
% 
% %---------------------------------------------------------------------------------------------------
% % TASK 1:   Implement morphological operators Erosion/Dilation. Compose new operators from
% %           Dilation/Erosion: Opening, Closing, TopHat and TopHat dual


form = 'square';    % we apply two types of struct element forms to simplify: 'circle' or 'square'
thickness = 5;      % wide of the struct element
plots = 'no';       % show plots?

switch form
    case 'circle'
        se = strel('disk',floor(thickness/2),0);
        se = se.getnhood;
    case 'square'
        se = strel('square',thickness);
        se = se.getnhood;
end

[diff] = W2_task1(masks,se,plots);

diff_table = struct2table(diff);

% display(diff_table);
% display('difference between the MO and the same MO composed from dilation/erosion in all the different masks');


% 
% 
% %---------------------------------------------------------------------------------------------------
% % TASK 2:   Measure the computational efficiency of your programed operators Erosion/Dilation

form = {'circle'};              % we apply two types of struct element forms to simplify: 'circle' or 'square'
thickness = 10;                  % wide of the struct element. We can compute an array of se to compare it.
plots = 'no';

%we can put more than one se to compare it, but it really doesn't change
%the results or the computational efficiency.

%NOTE: it's on that way because it is implemented in task 3, where the se
%matters to choice a good way to reduce the noise in the masks

se = cell(1,length(form));

for ii=1:length(se)
    if strcmp(form(ii),'circle') == 1
        se_aux = strel('disk',floor(thickness(ii)/2),0);
        se{1,ii} = se_aux.getnhood;
        
    elseif strcmp(form(ii),'square') == 1
        se_aux = strel('square',thickness(ii));
        se{1,ii} = se_aux.getnhood;
    end
end

[diff2, time] = W2_task2(masks,se,plots);

diff_table2 = struct2table(diff2);
time_table2 = struct2table(time);

% display(diff_table2);
% display('difference between the imerode/imdilate and myerode/mydilate');
% display(time_table2);
% display('operation time of the MO');


%
% 
% %---------------------------------------------------------------------------------------------------
% % TASK 3:   Use operators to improve results in sign detection
 

%We apply the MO on that way: first erode, then dilate.
%we can use imfill() to fill the forms before or after the erode. 

%Method 1: hole filling + opening
tic
files_names = dir('../block5/W5_task1/new_masks');
for ii = 3:(size(files_names)-1)
    
    im_full_path = files_names(ii).name;
    original_mask = imread(strcat('../block1/masks/',im_full_path));
    writing_path = strcat('W2_task3/m1_new/',files_names(ii).name(1:end-4),'.png');
    new_mask = imdilate(original_mask, strel('square',4));
    new_mask = imfill(new_mask,'holes');
    new_mask = imopen(new_mask, se{1,1});
    imwrite(new_mask, writing_path);

end
disp('M1:');
toc
W2_task3_eval('m1_new');

%Method 2: hole filling + closing
files_names = dir('../block1/masks');
tic
for ii = 3:(size(files_names)-1)
    
    im_full_path = files_names(ii).name;
    original_mask = imread(strcat('../block1/masks/',im_full_path));
    writing_path = strcat('W2_task3/m2/',files_names(ii).name(1:end-4),'.png');
    new_mask = imfill(original_mask,'holes');
    new_mask = imclose(new_mask, se{1,1});
    imwrite(new_mask, writing_path);

end
disp('M2:');
toc
W2_task3_eval('m2');


%Method 3: hole filling + erode
files_names = dir('../block1/masks');
tic
for ii = 3:(size(files_names)-1)
    
    im_full_path = files_names(ii).name;
    original_mask = imread(strcat('../block1/masks/',im_full_path));
    writing_path = strcat('W2_task3/m3/',files_names(ii).name(1:end-4),'.png');
    new_mask = imfill(original_mask,'holes');
    new_mask = imerode(new_mask, se{1,1});
    imwrite(new_mask, writing_path);

end
disp('M3:');
toc
W2_task3_eval('m3');

%{
%Method 4: opening
files_names = dir('../block1/masks');
tic
for ii = 3:(size(files_names)-1)
    
    im_full_path = files_names(ii).name;
    original_mask = imread(strcat('../block1/masks/',im_full_path));
    writing_path = strcat('W2_task3/m4/',files_names(ii).name(1:end-4),'.png');
    new_mask = imopen(original_mask, se{1,1});
    imwrite(new_mask, writing_path);

end
disp('M4:');
toc
W2_task3_eval('m4');

%Method 5: closing
files_names = dir('../block1/masks');
tic
for ii = 3:(size(files_names)-1)
    
    im_full_path = files_names(ii).name;
    original_mask = imread(strcat('../block1/masks/',im_full_path));
    writing_path = strcat('W2_task3/m5/',files_names(ii).name(1:end-4),'.png');
    new_mask = imclose(original_mask, se{1,1});
    imwrite(new_mask, writing_path);

end
disp('M5:');
toc
W2_task3_eval('m5');

%Method 6: erode
files_names = dir('../block1/masks');
tic
for ii = 3:(size(files_names)-1)
    
    im_full_path = files_names(ii).name;
    original_mask = imread(strcat('../block1/masks/',im_full_path));
    writing_path = strcat('W2_task3/m6/',files_names(ii).name(1:end-4),'.png');
    new_mask = imerode(original_mask, se{1,1});
    imwrite(new_mask, writing_path);

end
disp('M6:');
toc
W2_task3_eval('m6');
%}


%CONCLUSIONS:

%1. the smaller the sign is, a smaller brush it needs.
%   so smaller signs are harder to isolate.

%2. it is approximately the same to use the circular brush or the
%   square one. maybe the circular is a little bit better in the signs
%   that are not circular and the square ones are better in the
%   circular ones. (NOT DEMOSTRATED, but i'm pretty sure)

%3. the numerical analysis of the morphological operators and the
%   computation of our morphological operators will be done soon

%4. the best way to improve this tasks is improving the masks of
%   block1, with the WB, with a narrower range of the Hue, using
%   histograms or other things.


