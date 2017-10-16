% main 
data_set_path ='C:\Users\noamor\Google Drive\UPC_M1\Project\M1_BLOCK1\task2\Training_2017\train';
image_processing_flag = 0;
load('C:\Users\noamor\Documents\GitHub\team2\statistic_of_all_types.mat');

[ce, nRB,nB,nR ] =colors_signs_statatistics( data_set_path, all_data,image_processing_flag );

[ ce1, nRB1,nB1,nR1 ]= colors_signs_statatistics( data_set_path, all_data,1 );

[ce2,  nRB2,nB2,nR2 ] =colors_signs_statatistics( data_set_path, all_data,2 );

figure

bar3(ce,[nRB,nRB1,nRB2,nB,nB1,nB2,nR,nR1,nR2]);
title('Hue Comparision');
legend('mix','mix-WB','mix-WB-Lum balace','Blue','Blue-WB','Blue-WB-Lum balace','Red','Red-WB','Red-WB-Lum balace')