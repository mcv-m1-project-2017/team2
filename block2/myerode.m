%THIS FUNCTION ERODES A BINARY IMAGE USING A SQUARE STRUCT ELEMENT

function [ mask2 ] = myerode( mask, se )

se = zeros(length(se));
%struct element of myerode is based on zeros, to paint the binary image black

[iimax, jjmax] = size(mask);

mask_aux = zeros(iimax+length(se)*2, jjmax+length(se)*2);
%auxiliar mask with boundaries to not to have problems with the borders of the image. 
%this boundaries have the wide of the structelement

mask_aux(length(se)+1:iimax+length(se), length(se)+1:jjmax+length(se)) = mask;
%the real mask is in the center of the auxiliar mask

mask2=mask_aux;
%mask2 is our output mask


for ii = 1+length(se):iimax+length(se) 
    for jj = 1+length(se):jjmax+length(se)
    %loop only for the center of the auxiliar mask, where is located the
    %real mask, that's the important information
    
        if mask_aux(ii,jj) == 0
            %if it is found a black pixel, we paint in black the
            %neighbors using the structelement ("the brush")
            mask2(ii-floor(length(se)/2):ii+floor(length(se)/2-0.1),jj-floor(length(se)/2):jj+floor(length(se)/2-0.1)) = se;
            
        end
    end
end

mask2 = mask2(length(se)+1:iimax+length(se), length(se)+1:jjmax+length(se));
%erase the auxiliar boundaries
end
