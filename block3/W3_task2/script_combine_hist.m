% creating th Hists for the scores

%(1) Triangle Up ('B')
%(2) Triangle Down('A')
%(3) Circle ('C','D','E')
%(4) Rectangle ('F');
load('C:\Users\noamor\Google Drive\studies\Computer_vision\M1_IHCV\statistic_of_all_types.mat');
plot_flag = 1;
[ ff_vmc_TD,hmc_TD,fr_TD ] = Create_Hist_for_each_shape( all_data,{'B'},10,plot_flag );

[ ff_vmc_TU,hmc_TU,fr_TDU ] = Create_Hist_for_each_shape( all_data,{'A'},10,plot_flag );
[ ff_vmc_Ci,hmc_Ci,fr_Ci ] = Create_Hist_for_each_shape( all_data,{'C','D','E'},6,plot_flag );
[ ff_vmc_R,hmc_R,fr_R ] = Create_Hist_for_each_shape( all_data,{'F'},10,plot_flag );

[ ff_vmc,hmc,fr ] = Create_Hist_for_each_shape( all_data,[],20,plot_flag );

save('W3_task2\score_maps2.mat','ff_vmc_TD','hmc_TD','fr_TD','ff_vmc_TU','hmc_TU','fr_TDU' ,'ff_vmc_Ci','hmc_Ci','fr_Ci','ff_vmc','hmc','fr','ff_vmc_R','hmc_R','fr_R')