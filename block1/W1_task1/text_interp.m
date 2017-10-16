function [ tl,br,type,w,h ] = text_interp( file_name )
%text_interp extract the features in the txt file  
% I.INPUT- CHECK
%===============

if ~exist(file_name,'file')
    tl=-1;br=-1;type=-1;w=-1;h=-1;
    disp([file_name,' -not exist']);
    return
end
%II. OUTPUT
%=========
% 1. tl ( top-left, [line,col])
% 2. br ( buttom-right, [line,col])
% 3. type (A/B/C/D/E/F)
% 4. w = width (column diffrence)
% 5. h = height (lines diffrence)

fid = fopen(file_name);
A = fscanf(fid,'%f %f %f %f %c');
if length(A)>5
    pause(2);
end

A= reshape(A,5,length(A)/5);
fclose(fid);
tl = [A(1,:)',A(2,:)']; % line- col
br = [A(3,:)',A(4,:)'];
type = char(A(5,:)');
box_size = br-tl;
% units [pixel] -- the coordinates are given in float
h = round(box_size(:,1));
w = round(box_size(:,2));

end

