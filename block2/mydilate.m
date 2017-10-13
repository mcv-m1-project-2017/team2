%THIS FUNCTION DILATES A BINARY IMAGE USING A SQUARE STRUCT ELEMENT

function [ mask2 ] = mydilate( mask, se )


%struct element of mydilate is based on ones, to paint the binary image white

[iimax, jjmax] = size(mask);

mask_aux = zeros(iimax+length(se)*2, jjmax+length(se)*2);
%auxiliar mask with boundaries to not to have problems with the borders of the image. 
%this boundaries have the wide of the structelement

mask_aux(length(se)+1:iimax+length(se), length(se)+1:jjmax+length(se)) = mask;
%the real mask is in the center of the auxiliar mask

mask2 = mask_aux;
%mask2 is our output mask


for ii = 1+length(se):iimax+length(se)
    for jj = 1+length(se):jjmax+length(se)
    %loop only for the center of the auxiliar mask, where is located the
    %real mask, that's the important information
    
        if mask_aux(ii,jj) == 1
            %if it is found a white pixel, we paint in white the
            %neighbors using the structelement ("the brush")
            temp=mask_aux(ii-floor(length(se)/2):ii+floor(length(se)/2-0.1),jj-floor(length(se)/2):jj+floor(length(se)/2-0.1));
            
            temp(se==1)=1;
            
            mask2(ii-floor(length(se)/2):ii+floor(length(se)/2-0.1),jj-floor(length(se)/2):jj+floor(length(se)/2-0.1))=temp;
            
            %mask2(ii-floor(length(se)/2):ii+floor(length(se)/2-0.1),jj-floor(length(se)/2):jj+floor(length(se)/2-0.1)) = se;
            
            
            
        end
    end
end

mask2 = mask2(length(se)+1:iimax+length(se), length(se)+1:jjmax+length(se));
%erase the auxiliar boundaries
end

