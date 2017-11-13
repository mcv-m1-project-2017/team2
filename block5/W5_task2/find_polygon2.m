% ------------------------------------------------------------------------- %
%                          f i n d _ p o l y g o n                          %
% ------------------------------------------------------------------------- %
% Function "find_polygon"  find    %
% shape using the given masks and annotation of the training data-set.      %
%  Method
%  ------
%   Hough lines transform
%
%
%  Input parameters                                                         %
%   ----------------                                                        %
%        Im:  given Image (after emphasizing the contours using LoG\Canny) %
%             NxMx1 , binary image                                          %
%        tol:  tolerance for the shape angles. for exp: rectangle is 90+-tol%
%              units [ angle- deg  ]                                        %
%
%        num_sides:   number of sides for the polygon.                      %
%                           for exp: triangle : num_sides=3                 %
%        initial_angle:   the first angle for one of the sides of the
%                         polygon relative to the horizon clockwise         %
%                           for exp: ------- ,    initial_angle = 0         %
%        tol_rot:   tolerance for the rotation , intial_angle +-tol_rot     %
%                   tol_rot can't exceed 180/num_sides.
%                       tol_rot<180/num_sides
%                                                                           %
%        plot_flag:(Optional) plotting a subplot with 4 images with the Bbox %
%                  default : false                                          %
%                                                                           %
%   Output variables
%   ----------------                                                        %
%        bbox : Window canidates for traffic sign. struct(x,y,w,h)          %
%        binary_mask : true are all the pixels inside of the polygon        %
% -----------------------------------------------------------------------   %

% ----------------------------------------------------------------------- %


function [ bbox,binary_mask ] = find_polygon2( BW,num_sides,tol,initial_angle,tol_rot,plot_flag)
if nargin<6
    plot_flag = true;
end
if nargin<5
    tol_rot = 7;
end
if nargin < 4
    initial_angle = 0;
end
if nargin<3
    % default is 5 deg;
    tol = 5;
end
if nargin<2
    % default is triangle;
    num_sides = 4;
end
min_dist = 30; % half of the size of min side

if nargin<1 | isempty(BW)
    % trial
    %Image = imread('..\train\00.003179.jpg'); % circle
    Image = imread('..\train\01.001962.jpg');
    % YCbCr : the Luminance (Y==Ycbcr_im(:,:,1)) capture the best diff between object
    % (cause each object in my head has diff luminanace)
    Ycbcr_im = rgb2ycbcr(Image);
    
    % After manual picking
    %---------------------
    min_th = 0.05:00.05:0.2;
    max_th = 0.25:0.05:0.5;
    %for kk = 1: length(min_th)
    %   for qq = 1: length(max_th)
    %             if min_th(kk)>=max_th(qq)
    %                 continue
    %             end
    %     thresh = [min_th(kk),max_th(qq)] ; %0.2:0.02:0.3;
    %     sigma = 2.5;% 2:0.5:8;
    thresh = [0.15,0.27];
    sigma = 2.5;
    [BW] = edge(Ycbcr_im(:,:,1), 'canny',thresh,sigma) ;
    labels = label2rgb(bwlabel(BW, 8));

    if plot_flag
        figure(1)
        subplot(1,4,1)
        title('Original Image')
        imshow(Image);
        subplot(1,4,2)
        title('Y space in YCbCr')
        imshow(Ycbcr_im(:,:,1))
        subplot(1,4,3)
        title('Edge detection - "Canny"')
        imshow(BW)
        subplot(1,4,4)
        imshow(labels);
        title('label')
%         figure(2)
%         imshow(BW)
%         suptitle(['Sigma: ', num2str(sigma),',Th: ', num2str(thresh)]);
        
    end

    
end
% calc all the theta we want to find lines in
% tange of theta is -90:90, the angle is from [1,1] - top left corner of
% the image - the angle of the line will be theta+90;
% setting res_theta  = 0.5;
original_angle = initial_angle+360/num_sides*[0:num_sides-1];
angles = mod(original_angle,180);
angles = angles - 90;
% colors of each side
clr_side = hsv(num_sides);

[H,T,R] = hough(BW);%,'ThetaResolution',tol);


if plot_flag
    

    figure(3)
    
    imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
        'InitialMagnification','fit');
    title('Hough transform');
    xlabel('\theta'), ylabel('\rho');
    axis on, axis normal, hold on;
    colormap(gca,hot);
end
tol_vec = [-tol:0.5:tol];

%all_points = [0,0];
for ii = 1: num_sides
    current_angle = tol_vec(:)+repmat(angles(ii)+[-tol_rot:0.5:tol_rot],length(tol_vec),1);
    current_angle = unique(current_angle(:));
    % 0 is vertical
    % -90 is horizontal
    
    current_angle(current_angle>=90|current_angle<-90) = 180-abs(current_angle(current_angle>=90|current_angle<-90));
    current_H = H(:,(ismember(T,current_angle)));
    current_T = T(ismember(T,current_angle));
    %[H,T,R] = hough(BW,'theta',wrapTo180(current_angle));
    P  = houghpeaks(current_H,200,'threshold',ceil(0.02*max(current_H(:))));
    x = current_T(P(:,2)); y = R(P(:,1));
    % min-length ==16 , because min size of traffic sign is 900== 30X30 ,
    % tolerance of 10 pix
    gap = 6;
    lines = houghlines(BW,current_T,R,P,'fillgap',gap,'MinLength',22);
    siz_im = size(BW);
    max_len = 0;
    C = 0;
            if plot_flag
            figure(2)
            subplot(1,num_sides,ii);
            imshow(BW);hold on
            end
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        if all(xy(:,1)==1) |all(xy(:,1)==siz_im(2))|all(xy(:,2)==1) |all(xy(:,2)==siz_im(1))
            continue
            
            
        else
            C=C+1;
            new_line(C) = lines(k);
            
        end
       
        % Determine the endpoints of the longest line segment
        %         len = norm(lines(k).point1 - lines(k).point2);
        %         if ( len > max_len)
        %             max_len = len;
        %             xy_long = xy;
        %         end
    end
    % save line in struct
    %all_sides(ii).lines = new_line;
    
    % All points in the lines
    p1 = reshape([new_line.point1],2,[]);
    p1 = p1';
    p2 = reshape([new_line.point2],2,[]);
    p2 = p2';
    theta = [new_line.theta];
    theta = theta(:);
    %theta = wrapTo180(theta(:));
    % conc if there is a small gap
    D = pdist2(p2,p1);
    thetaD = pdist2(theta,theta);
    thetaD(thetaD>90) = 180-thetaD(thetaD>90);
    
   % dist_current_lines = D(diag(ones(size(p1,1))));
    
   %dist_current_lines = repmat(dist_current_lines,size(D,1),1,1);
   D(diag(ones(size(p1,1)))) = -1 ; 

    [idx2,idx1]=find(D<min_dist & D>=0 & abs(thetaD)<=tol);
    % create addition lines
    if plot_flag
        tmp(ii).p1 = p1(idx2,:);
        tmp(ii).p2 = p2(idx1,:);
%         plot_line_on_image(BW,tmp);
%         title(['Additional lines #', num2str(ii)]);
    end
    p1 = [p1; p1(idx2,:)];
    p2 = [p2; p2(idx1,:)];
 
%     dummy = p2;
%     p2(theta>0) = p1(theta>0);
%     p1(theta>0) = dummy(theta>0);
    
    if original_angle(ii)>=-45 & original_angle(ii)<45
        Idx = find(p2(:,1)<p1(:,1)); % oppisite direction
       
 
        
    elseif original_angle(ii)>=45 & original_angle(ii)<135
         Idx = find(p2(:,2)<p1(:,2)); % oppisite direction
 
        elseif original_angle(ii)>=135 & original_angle(ii)<225
          Idx = find(p1(:,1)<p2(:,1)); % oppisite direction  

    else
        Idx = find(p1(:,2)<p2(:,2)); % oppisite direction
    end
     dummy = p2;
        p2(Idx,:) = p1(Idx,:);
        p1(Idx,:) = dummy(Idx,:);
        all_points(ii).p1 = p1;
        all_points(ii).p2 = p2;
 if plot_flag
     for kk = 1: size(p1,1)
         xy = [p1(kk,:); p2(kk,:)];
            figure(2)
            subplot(1,num_sides,ii);
            
            
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color',clr_side(ii,:));hold on
            
            % Plot beginnings and ends of lines
            plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');hold on
            plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red'); hold on
     end
            title(num2str(ii));
        end
end
    if plot_flag

        plot_line_on_image(BW,tmp);
        title(['Additional lines ']);
    end
if plot_flag
    plot_line_on_image(BW,all_points);
    title('All lines detected by hough');
end
% circular shape

%all_sides(num_sides+1) = all_sides(1);
% % Collect all the lines that together can create a rectangle
% R=pdist(all_points);
% Z = linkage(all_points,'ward','euclidean','savememory','on');
% c = cluster(Z,'maxclust',length(all_points(:,1))/2);
% figure
% scatter(all_points(:,1),all_points(:,2),10,c)
%link_list_for the first line group
new_all_points(1).link = [1:size(all_points(1).p1,1)]';
%new_all_points(1).link_forward = [1:size(all_points(1).p1,1)]';
for ii = 1: num_sides
    % find match points
    %     X = randn(100, 5);
    %     Y = randn(25, 5);
    % match clock wise!
    if ii== num_sides
        sec_grp = 1;
    else
        sec_grp = ii+1;
    end
    D = pdist2(all_points(ii).p2 ,all_points(sec_grp).p1 ,'euclidean');

    if 0%plot_flag
        figure
        plot(D(:),'.'); hold on
        
        plot([1,length(D(:))],[min_dist,min_dist],'LineWidth',2,'Color',[1,0,0]);hold on
        
        
        title('dist between corners');
        if 0
            subplot(1,2,1)
            imagesc(D);
            title('dist between corners');
            subplot(1,2,2)
            tmp = D;
            tmp(D~=min_D) = nan;
            imagesc(tmp);
            title('min distance for each corner');
        end
    end
    %D(D~=min_D) = min_dist+1;
    [idx_p2,idx_p1]  = find(D<min_dist);

    new_all_points(sec_grp).p2 = all_points(sec_grp).p2(idx_p1,:);
    new_all_points(sec_grp).p1 = all_points(sec_grp).p1(idx_p1,:);
    new_all_points(sec_grp).link = new_all_points(ii).link(idx_p2);
    new_all_points(ii).link     = new_all_points(ii).link(idx_p2);
    new_all_points(ii).p2 = all_points(ii).p2(idx_p2,:);
    new_all_points(ii).p1 = all_points(ii).p1(idx_p2,:);
%     if ii ==1
%         new_all_points(ii).link = all_points(ii).link(idx_p2);
%         
%     else
%         new_all_points(ii).link = new_all_points(ii).link(idx_p2);
%     end
    %new_all_points(sec_grp).link = new_all_points(ii).link(idx_p2);
    %new_all_points(ii).p2 = all_points(ii).p2(idx_p2,:);
    %new_all_points(ii).p1 = all_points(ii).p1(idx_p2,:);
%     all_points(ii).p1 = all_points(ii).p1(unique(idx_p2),:);
%     all_points(ii).p2 = all_points(ii).p2(unique(idx_p2),:);
    
    all_points(sec_grp).p1 = all_points(sec_grp).p1(unique(idx_p1),:);
    
    all_points(sec_grp).p2 = all_points(sec_grp).p2(unique(idx_p1),:);
    
    
    
    
end

% only keep the linked groups

% the only "num_sides" sides that are linked - completly

% linking the shapes
 C = 0;
 
% for ii = 1: length(new_all_points(1).link_forward)
%     poly_canidates(1,[1:4],C) = [new_all_points(1).p1(ii,:),new_all_points(1).p2(ii,:)];
%     for ss = 1:num_sides-1
%         % each row is a line
%         % col : [xy(p1),xy(p2)]
%         % 3D is the link polygon
%         C = C+1;
%         idx = find(new_all_points(ss+1).link_back == new_all_points(ss).link_forward
%         poly_canidates(ss,[1:4],C) = [new_all_points(ss).p1(ii,:),new_all_points(ss).p2(ii,:)];
%         
%     idx = ismember(new_all_points(ii).link,C);
%     new_all_points(ii).p1= new_all_points(ii).p1(idx,:);
%     new_all_points(ii).p2= new_all_points(ii).p2(idx,:);
%     new_all_points(ii).link =new_all_points(ii).link(idx);
%     end
% end
if plot_flag
    if isempty(new_all_points(1).p1)
        disp('No lines were found')
    else
        plot_line_on_image(BW,new_all_points);
        title('All lines detected by hough after linking the lines');
    end
end

end

function plot_line_on_image(BW,all_points)
figure
imshow(BW); hold on
clr_side = hsv(length(all_points));
if isfield(all_points,'link')
    clr_side = hsv(max(all_points(1).link));
end
for ii = 1: length(all_points)
    cur_lines = all_points(ii);
    for k = 1:size(cur_lines.p1,1)
        xy = [cur_lines.p1(k,:); cur_lines.p2(k,:)];
        if isfield(all_points,'link')
            C = cur_lines.link(k);
        else
            C= ii;
        end
        
        
        
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color',clr_side(C,:));hold on
        
        % Plot beginnings and ends of lines
        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color',clr_side(C,:));hold on
        plot(xy(2,1),xy(2,2),'>','LineWidth',2,'Color',clr_side(C,:)); hold on
        
    end
end

end