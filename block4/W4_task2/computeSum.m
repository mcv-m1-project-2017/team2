function [sum] = computeSum(cropped_sign, circle, square, triangleup, triangledown)

template={circle, square, triangleup, triangledown};
sum=zeros(1,length(template));

%cropped_sign=cropped_sign(:,:,1)/255;
[x,y]=size(cropped_sign);

for aa=1:length(template)
    
    template{aa}=imerode(imfill(imdilate(template{aa},ones(3)),'holes'),ones(3));
    
    template{aa}=imresize(template{aa}, [x y]);
    
    template{aa}(1,:)=0;template{aa}(:,1)=0;template{aa}(end,:)=0;template{aa}(:,end)=0;
    
    template{aa}=template{aa}-imerode(template{aa},ones(3));%-I8;
    
    template{aa}=bwdist(template{aa});
    [a,b]=find(cropped_sign);
    for ii=1:length(a)
        sum(aa)=sum(aa)+template{aa}(a(ii),b(ii));
    end
    
end
end