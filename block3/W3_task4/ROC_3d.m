clrr= hsv(size(pix_out,2));



    for jj= 1: size(pix_out,2)
        for ii= 1: size(pix_out,1)
            
        if isempty(th(ii,jj).score)
            th_score(ii,jj)  = nan;
            
        else
            %weights(ii,jj)  = th(ii,jj).weights;
            th_score(ii,jj) = th(ii,jj).score;
        end
        if isempty(region_out(ii,jj).Recall)
            Recallreg(ii,jj) = nan;
        else
            Recallreg(ii,jj) = region_out(ii,jj).Recall;
        end
        if isempty(pix_out(ii,jj).Recall)
            Recallpix(ii,jj) = nan;
        else
            Recallpix(ii,jj) = pix_out(ii,jj).Recall;
        end
        if isempty(pix_out(ii,jj).Precision)
            Precisionpix(ii,jj) = nan;
        else
            Precisionpix(ii,jj) = pix_out(ii,jj).Precision;
        end
        if isempty(region_out(ii,jj).precision)
            Precisionreg(ii,jj) = nan;
        else
            Precisionreg(ii,jj) = region_out(ii,jj).precision;
        end
        
    end
    subplot(1,2,1)
    plot(Recallreg(:,jj),Precisionreg(:,jj),':o','Color',clrr(jj,:)) ; hold on
    subplot(1,2,2)
    plot(Recallpix(:,jj),Precisionpix(:,jj),':o','Color',clrr(jj,:)); hold on
end
subplot(1,2,1)

xlabel('Re-Call');
ylabel('Precision');

title('Region base evaluation');

axis equal

xlim([0,1]);
ylim([0,1]);

subplot(1,2,2)

xlabel('Re-Call');
ylabel('Precision');

title('Pixel base evaluation');

axis equal

xlim([0,1]);
ylim([0,1]);


suptitle({'Sliding window - Recall vs Precision';'weights and score threshold'});
W = repmat([1:18],9,1);
figure(2)
subplot(1,2,1)
surf(th_score,W,(Precisionpix.^2+Recallpix.^2).^0.5);
ylabel('weights comination');
xlabel('Threshold');
zlabel('sqrt(Recall^2+Precison^2)');

title('Pixel based Evaluation');
subplot(1,2,2)
surf(th_score,W,(Precisionreg.^2+Recallreg.^2).^0.5);
ylabel('weights comination');
xlabel('Threshold');
zlabel('sqrt(Recall^2+Precison^2)');
title('Region based Evaluation');