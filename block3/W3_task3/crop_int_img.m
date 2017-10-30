function [ int_out ] = crop_int_img( img,rect )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
x = rect(1);
y = rect(2);
w_win = rect(3);
h_win = rect(4);
img_out1 = imcrop(img,[x,y,w_win-1,h_win-1]);

if y>1
    
    upper_val = imcrop(img,[x,y-1,w_win-1,0]);
    upper_val = repmat(upper_val,h_win,1);
    tmp = img_out1 - upper_val;
    img_out1 = tmp;

end
if x>1
    left_val = imcrop(img,[x-1,y,0,h_win-1]);
    left_val = repmat(left_val,1,w_win);
    tmp = img_out1 - left_val;
    img_out1 = tmp;
end
if x>1 & y>1
    tmp = img_out1+img(y-1,x-1);
    img_out1 = tmp;
end
int_out = img_out1;

if any(int_out(:)<0)
    A=1;
end
end

