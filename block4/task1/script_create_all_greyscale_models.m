% script to create grey scale model
team2path=fileparts(fileparts(fileparts(mfilename('fullpath'))));
plot_flag = false;
load([team2path,'\block1\W1_task2\statistic_of_all_types.mat']);
given_mask_path = [team2path,'\train\mask'];
given_gt_path = [team2path,'\train\gt'];
addpath([team2path,'\evaluation'])
resample_method = 'bicubic';
model_size = [84,84];
% trriangle up
[ model_tri_up ] = create_shape_grey_scale_model( given_mask_path,given_gt_path,all_data,'up_tri',model_size,resample_method,plot_flag);
greyscale_model(1).mask = model_tri_up;
greyscale_model(1).shape = 'triangle_up';
[ model_tri_down ] = create_shape_grey_scale_model( given_mask_path,given_gt_path,all_data,'down_tri',model_size,resample_method,plot_flag);
greyscale_model(2).mask = model_tri_down;
greyscale_model(2).shape = 'triangle_down';
[ model_circle ] = create_shape_grey_scale_model( given_mask_path,given_gt_path,all_data,'circle',model_size,resample_method,plot_flag);
greyscale_model(3).mask = model_circle;
greyscale_model(3).shape = 'circle';
[ model_rect ] = create_shape_grey_scale_model( given_mask_path,given_gt_path,all_data,'cube',model_size,resample_method,plot_flag);
greyscale_model(4).mask = model_rect;
greyscale_model(4).shape = 'rectangle';

figure
subplot(2,2,1)
imshow(model_tri_up)
title('Tringle-Up');
subplot(2,2,2)
imshow(model_tri_down)
title('Tringle-Down');
subplot(2,2,3)
imshow(model_circle)
title('Circle');
subplot(2,2,4)
imshow(model_rect)
title('Rectangle');
suptitle({'Grey scale models';'based on training set mean value'})
save('grey_scale_models.mat','greyscale_model','model_tri_up','model_tri_down','model_circle','model_rect');