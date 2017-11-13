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


function [ bbox_out,mask_out ] = find_rectangle( BW,tol,tol_rot,windowCandidates,plot_flag)
if nargin<5
    plot_flag = true;
end
if nargin<3
    tol_rot = 10;
end
if nargin<2
    tol = 8;
end
close all
min_dist = 30; % half of the size of min side

if nargin<1 | isempty(BW)
    % trial
    %Image = imread('..\train\00.003179.jpg'); % circle
    % Image = imread('..\train\01.001962.jpg');
    Image = imread('C:\Users\noamor\Documents\GitHub\team2\team2\block3\Results_test_submit\CCL\01.002270_mask.png');
    %  Image = imread('C:\Users\noamor\Documents\GitHub\team2\team2\block4\W4_task1\Results_test_submit\CORR_CCL\01.001330_mask.png');
    % YCbCr : the Luminance (Y==Ycbcr_im(:,:,1)) capture the best diff between object
    % (cause each object in my head has diff luminanace)
    %Ycbcr_im = rgb2ycbcr(Image);
    Ycbcr_im = Image;
    load('C:\Users\noamor\Documents\GitHub\team2\team2\block3\Results_test_submit\CCL\01.002270_mask.mat');
    % windowCandidates = [];
    % After manual picking
    %---------------------
    %     min_th = 0.05:00.05:0.2;
    %     max_th = 0.25:0.05:0.5;
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
bbox_out  = [];
angles = [-90 , 0,-90 , 0];

% colors of each side
num_sides = 3;
clr_side = hsv(num_sides);
if isempty(windowCandidates)
    windowCandidates.x = -1;
end
for  ww = 1: length( windowCandidates)
    win_flag = 0;
    if all([windowCandidates(:).x] == -1)
        cur_BW = BW;
    else
        x = max([(windowCandidates(ww).x -10),1]);
        y = max([(windowCandidates(ww).y -10),1]);
        w = min([windowCandidates(ww).w+20,size(BW,2)-windowCandidates(ww).x]);
        h = min([windowCandidates(ww).h+20,size(BW,1)-windowCandidates(ww).y]);
        
        rectd_cor = [floor(x) ,floor(y) ,w,h];
        cur_BW = imcrop(BW,rectd_cor);
    end
    [H,T,R] = hough(cur_BW);%,'ThetaResolution',tol);
    
    
    if plot_flag
        
        figure;
        imshow(cur_BW);
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
    bad_flag = 0;
    % for ii = 1: num_sides
    % First Line
    %===========
    current_angle = tol_vec(:)+repmat(angles(1)+[-tol_rot:0.5:tol_rot],length(tol_vec),1);
    current_angle = unique(current_angle(:));
    all_points1 = get_lines_from_Hough(cur_BW,H,T,R,current_angle,tol,min_dist,'p2(:,1)<p1(:,1)');
    if isempty(all_points1.p1)
        break
    end
    % add - the big line
    %P-1
    %===
    I = find(all_points1.p1(:,1)==min(all_points1.p1(:,1)));
    p1 = all_points1.p1(I(1),:);
    all_points1.p1 = p1;%[all_points1.p1;p1];
    I = find(all_points1.p2(:,1)==max(all_points1.p2(:,1)));
    p2 = all_points1.p2(I(1),:);
    all_points1.p2 = p2;%[all_points1.p2;p2];
    
    %Angle = atan2d(p2(1,2) - p1(1,2))./(p2(1,1) - p1(1,1))-90;
    
    
    %=====
    current_angle = tol_vec(:)+repmat(angles(2)+[-tol_rot:0.5:tol_rot],length(tol_vec),1);
    current_angle = unique(current_angle(:));
    all_points2 = get_lines_from_Hough(cur_BW,H,T,R,current_angle,tol,min_dist,'p1(:,2)<p2(:,2)');
    if isempty(all_points2.p1)
        break
    end
    %P-2
    %===
    I = find(all_points2.p1(:,2)==max(all_points2.p1(:,2)));
    p1 = all_points2.p1(I(1),:);
    all_points2.p1 = p1;%[all_points2.p1;p1];
    I = find(all_points2.p2(:,2)==min(all_points2.p2(:,2)));
    p2 = all_points2.p2(I(1),:);
    
    %Angle = atan2d(p2(1,2) - p1(1,2))./(p2(1,1) - p1(1,1))-90;
    
    
    all_points2.p2 = p2;%[all_points2.p2;p2];
    
    
    %====
    current_angle = tol_vec(:)+repmat(angles(3)+[-tol_rot:0.5:tol_rot],length(tol_vec),1);
    current_angle = unique(current_angle(:));
    all_points3 = get_lines_from_Hough(cur_BW,H,T,R,current_angle,tol,min_dist,'p1(:,1)<p2(:,1)');
    if isempty(all_points3.p1)
        break
    end
    %P-3
    %===
    I = find(all_points3.p1(:,1)==max(all_points3.p1(:,1)));
    p1 = all_points3.p1(I(1),:);
    all_points3.p1 = p1;%[all_points3.p1;p1];
    
    I = find(all_points3.p2(:,1)==min(all_points3.p2(:,1)));
    p2 = all_points3.p2(I(1),:);
    all_points3.p2 = p2;%[all_points3.p2;p2];
    %P-4
    %===
    current_angle = tol_vec(:)+repmat(angles(4)+[-tol_rot:0.5:tol_rot],length(tol_vec),1);
    current_angle = unique(current_angle(:));
    all_points4 = get_lines_from_Hough(cur_BW,H,T,R,current_angle,tol,min_dist,'p2(:,2)<p1(:,2)');
    if isempty(all_points4.p1)
        break
    end
    %P-4
    %===
    I = find(all_points4.p1(:,2)==min(all_points4.p1(:,2)));
    p1 = all_points4.p1(I(1),:);
    all_points4.p1 = p1;%[all_points3.p1;p1];
    I = find(all_points4.p2(:,2)==max(all_points4.p2(:,2)));
    p2 = all_points4.p2(I(1),:);
    all_points4.p2 = p2;%[all_points3.p2;p2];
    %===
    
    min_deg = 60+[-tol,tol];
    c = 0;
    figure(40);
    imshow(cur_BW); hold on;
    figure(50);
    all_points(1) = all_points1;
    all_points(2) = all_points2;
    all_points(3) = all_points3;
    all_points(4) = all_points4;
    
    plot_line_on_image(cur_BW,all_points)
    
    
    for pp =1: size(all_points1.p2,1)
        current_p.p2 = all_points1.p2(pp,:);
        current_p.p1 = all_points1.p1(pp,:);
        current_p.theta = all_points1.theta(pp,:);
        lines_out = find_match_lines(current_p, all_points2,min_dist,min_deg);
        if ~isempty(lines_out.p1)
            
            figure(40);
            xy = [current_p.p1(1,:); current_p.p2(1,:)];
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color',[1,0,0]);hold on
            for pp2 = 1: size(lines_out.p1,1)
                current_p2.p2 = lines_out.p2(pp2,:);
                current_p2.p1 = lines_out.p1(pp2,:);
                current_p2.theta = lines_out.theta(pp2,:);
                figure(40);
                xy = [current_p2.p1(1,:); current_p2.p2(1,:)];
                plot(xy(:,1),xy(:,2),'LineWidth',2,'Color',[0,1,0]);hold on
                
                lines_out2 = find_match_lines(current_p2, all_points3,min_dist,min_deg);
                if ~isempty(lines_out2.p1)
                    for pp3 = 1: size(lines_out2.p1,1)
                        cur_p3.p1 = lines_out2.p1(pp3,:);
                        cur_p3.p2 = lines_out2.p2(pp3,:);
                        cur_p3.theta = lines_out2.theta(pp3,:);
                        lines_out3 = find_match_lines(cur_p3, all_points4,min_dist,min_deg);
                        if ~isempty(lines_out3.p1)
                            for pp4 = 1: size(lines_out2.p1,1)
                                cur_p4.p1 = lines_out3.p1(pp4,:);
                                cur_p4.p2 = lines_out3.p2(pp4,:);
                                cur_p4.theta = lines_out3.theta(pp4,:);
                                lines_out4 = find_match_lines(cur_p4, current_p,min_dist,min_deg);
                                if ~isempty(lines_out4.p1)
                                    % WE HAVE A WINNER!!
                                    % WE HAVE A WINNER!!
                                    c=c+1;
                                    rect_canidates(c).side1 = current_p;
                                    rect_canidates(c).side2 = current_p2;
                                    rect_canidates(c).side3 = cur_p3;
                                    rect_canidates(c).side4 = cur_p4;
                                    if ~all([windowCandidates.x]==-1)
                                        bbox_out = [bbox_out;windowCandidates(ww)];
                                    end
                                    win_flag = 1;
                                    break
                                end
                                if win_flag
                                    break
                                end
                            end
                        end
                        if win_flag
                            break
                        end
                    end
                end
                if win_flag
                    break
                end
            end
            
        end
        
        
        if win_flag
            break
        end
    end
    
    % only keep the linked groups
    
    % the only "num_sides" sides that are linked - completly
    
    % linking the shapes
    %     C = 0;
    %     if isempty(all_points(1).p1)
    %         bbox_out= [];
    %         binary_mask = zeros(size(BW));
    %         return
    %     end
    %     all_points = get_uniqueshapes(all_points);
    %
    %     if plot_flag
    %         if isempty(all_points(1).p1)
    %             disp('No lines were found')
    %         else
    %             plot_line_on_image(cur_BW,all_points);
    %             title('All lines detected by hough after linking the lines');
    %         end
    %     end
    %
end
if isempty(bbox_out)
    mask_out = false(size(BW));
else
    [ mask_out ] = mask_bbox( BW,bbox_out );
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

function all_points = get_lines_from_Hough(BW,H,T,R,current_angle,tol,min_dist,condition_string)
current_angle(current_angle>=90|current_angle<-90) = 180-abs(current_angle(current_angle>=90|current_angle<-90));
current_H = H(:,(ismember(T,current_angle)));
current_T = T(ismember(T,current_angle));
%[H,T,R] = hough(BW,'theta',wrapTo180(current_angle));
P  = houghpeaks(current_H,5,'threshold',ceil(0.05*max(current_H(:))));

% min-length ==16 , because min size of traffic sign is 900== 30X30 ,
% tolerance of 10 pix
gap = 12;
lines = houghlines(BW,current_T,R,P,'fillgap',gap,'MinLength',20);
p1 = reshape([lines.point1],2,[]);
p1 = p1';
p2 = reshape([lines.point2],2,[]);
p2 = p2';
theta = [lines.theta];
theta = theta(:);
%theta = wrapTo180(theta(:));
% conc if there is a small gap
D = pdist2(p2,p1);
thetaD = pdist2(theta,theta);
thetaD(thetaD>90) = 180-thetaD(thetaD>90);

% dist_current_lines = D(diag(ones(size(p1,1))));

%dist_current_lines = repmat(dist_current_lines,size(D,1),1,1);
D(diag(ones(size(p1,1)))) = -1 ;

[idx2,idx1]=find(D<min_dist & D>=0);% & abs(thetaD)<=tol);
% create addition lines
%     if plot_flag
%         tmp(ii).p1 = p1(idx2,:);
%         tmp(ii).p2 = p2(idx1,:);
%         %         plot_line_on_image(BW,tmp);
%         %         title(['Additional lines #', num2str(ii)]);
%     end
p1 = [p1; p1(idx2,:)];
p2 = [p2; p2(idx1,:)];
Angle = atand(p2(idx2,2) - p1(idx1,2))./(p2(idx2,1) - p1(idx1,1))-90;
Angle(Angle>=90|Angle<-90) = 180-abs(Angle(Angle>=90|Angle<-90));

theta = [theta;Angle];
%Idx = find(p2(:,1)<p1(:,1));
Idx = find(eval(condition_string));
dummy = p2;
p2(Idx,:) = p1(Idx,:);
p1(Idx,:) = dummy(Idx,:);
all_points(1).p1 = p1;
all_points(1).p2 = p2;
all_points(1).theta = theta;
end

function all_points = get_uniqueshapes(all_points)
for ii = 1: length(all_points)
    
    rect_cand(:,[ii*4-3,ii*4-2]) = all_points(ii).p1;
    rect_cand(:,[ii*4-1,ii*4]) = all_points(ii).p2;
end
[~,I] = unique(rect_cand,'rows');
for ii = 1: num_sides
    all_points(ii).p1 = all_points(ii).p1(I,:);
    all_points(ii).p2 = all_points(ii).p2(I,:);
    all_points(ii).link = [1:size(all_points(ii).p2 ,1)]';
end
end

function lines_out = find_match_lines(p, lines,min_dist,min_ang)
D = pdist2(p.p2 ,lines.p1 ,'euclidean');
u = [p.p2-p.p1,0];
v = [(lines.p2)-(lines.p1),zeros(size((lines.p1),1),1)];
Angle = atan2d(norm(cross(u,v)),dot(u,v));
Angle(Angle>90) = 180- Angle(Angle>90);
% D_ang = pdist2(p.theta ,lines.theta ,'euclidean');
[~,idx_p1]  = find(D<min_dist & Angle>=min_ang(1)&Angle<=min_ang(2));
lines_out.p1 = lines.p1(idx_p1,:);
lines_out.p2 = lines.p2(idx_p1,:);
lines_out.theta = lines.theta(idx_p1);
end
