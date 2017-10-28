% creating ROC
%=============
ReCallp = [pix_out.Recall];
Precisionp = [pix_out.Precision];

% plot(ReCall,Precision)
% plot(ReCall,Precision,'ob')
plot(ReCallp,Precisionp,':ob');
hold on
ReCallr = [region_out.Recall];
Precisionr = [region_out.precision];
plot(ReCallr,Precisionr,':om')
hold on

xlabel('Re-Call');
ylabel('Precision');
title({'CCL';'Recall vs Precision';'symmetric-score threshold'});
legend('pixel evaluation','region evaluation');
axis equal

xlim([0,1]);
ylim([0,1]);



% plot(ReCall,Precision)
% plot(ReCall,Precision,'ob')






win_idx = 16;

% plot(ReCall(win_idx),Precision(win_idx),'xg')
% plot(ReCall(win_idx),Precision(win_idx),'xg')
hold on
plot(ReCallp(win_idx),Precisionp(win_idx),'xr','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor',[0.5,0.5,0.5]);
annotation('textarrow',[ReCallp(win_idx)-0.2,ReCallp(win_idx)],[Precisionp(win_idx)-0.2,Precisionp(win_idx)],'String',['Work-point: 0.75'])