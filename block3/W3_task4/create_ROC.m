% creating ROC
%=============
function create_ROC(pix_out,region_out,txt,th)
ReCallp = [pix_out.Recall];
Precisionp = [pix_out.Precision];

% plot(ReCall,Precision)
% plot(ReCall,Precision,'ob')
plot(ReCallp,Precisionp,':ob');
hold on
% plot(ReCallp(1),Precisionp(1),'xb');hold on

ReCallr = [region_out.Recall];
Precisionr = [region_out.Precision];
plot(ReCallr,Precisionr,':om')
plot(ReCallr(end),Precisionr(end),'xm');hold on
plot(ReCallp(end),Precisionp(end),'xb');hold on

hold on

xlabel('Re-Call');
ylabel('Precision');
title({'Recall vs Precision';txt});
legend('pixel evaluation','region evaluation');
axis equal

xlim([0,1]);
ylim([0,1]);



% plot(ReCall,Precision)
% plot(ReCall,Precision,'ob')


% calc best point 

[~,win_idx] = max([[region_out.F1].^2+[pix_out.F1].^2]);



%win_idx = 16;

% plot(ReCall(win_idx),Precision(win_idx),'xg')
% plot(ReCall(win_idx),Precision(win_idx),'xg')
% hold on
plot(ReCallp(win_idx),Precisionp(win_idx),'xr','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor',[0.5,0.5,0.5]);
annotation('textarrow',[ReCallp(win_idx)-0.2,ReCallp(win_idx)],[Precisionp(win_idx)-0.2,Precisionp(win_idx)],'String',['Work-point: ',num2str(th(win_idx))])