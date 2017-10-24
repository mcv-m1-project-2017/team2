% I.Function Description : dataset_analysis
%==========================================
% II. INPUT:
%==========
%   1. data_dir
%       The directory of the raw training data, it has to contain 2 folders:
%       (1) gt:     *.txt files
%       (2) mask :  *.png
%       and the .jpg images
%
%   2. plot_flag: 
%       To create histograms of the statistical analysis.
%
% III. OUTPUT:
%=============
%   1.statistic_table
%       class: struct
%       fields:
%           'type'          : char   [1X1]
%               A/B/C/D/E/F
%           'number'        : double [1X1]
%               Number of appearances of each sign type.
%
%           'form_factor'   : double [1X2]
%               Min-max values of the form_factor for each type
%
%           'fill_factor'   : double [1X2]
%               Min-max values of the fill_factor for each type
%
%           'A'             : double [1X2]
%               Min-max values of the square area according to the gt file 
%               coordinates for each type
%
%   2.all_data
%       class: struct
%       fields:
%           'file_id'       : char   [1X9]
%              Image id - example: 01.013256 
%           'type'          : char   [1X1]
%               A/B/C/D/E/F
%           'A'             : double [1X1]
%               The square area according to the gt file 
%               coordinates for each type
%           'form_factor'   : double [1X1]
%               Mask/A
%           'fill_factor'   : double [1X1]
%
%           'color_wrbk'    : char   [1X4]
%           [white-red-blue-black]
%           'shape'
%
%           'index'         : double [1X1]
%               The index for the specific sign in the mask file
function [statistic_table,all_data] = dataset_analysis(data_dir,plot_flag)

% Input check
if nargin<2
    plot_flag = false;
end

type_legend = {'A','B','C','D','E','F'};
shape_legend = {'up_tri','down_tri','circle','cube'};

mask_dir = fullfile(data_dir,'mask');
gt_dir  = fullfile(data_dir,'gt');

all_gt_file = dir(fullfile(gt_dir,'*.txt'));
all_gt_file = {all_gt_file.name};
% data template struct - to save each shape
data_tamplate = struct('file_id','','type','','A',0,'form_factor',0, 'fill_factor',0,'color_wrbk',false(1,4),'shape','','mass_center',[0,0],'index',0,'validation',0);
all_data = data_tamplate;
valid_i = 0;

for ii =1:length(all_gt_file)
    [tl,br,type,w,h] = text_interp(fullfile(gt_dir,all_gt_file{ii}));
    % If the file doesn't exist - continue
    if tl==-1
        continue
    end
    
    % loop on the number of patch(traffic signs) in the same file\mask
    for jj =1:size(tl,1)
        id_file = strrep(all_gt_file{ii},'.txt','');
        id_file = strrep(id_file,'gt.','');
        [mask_area, mass_center,mask_index] = mask_interp(fullfile(mask_dir, ['mask.',id_file,'.png']), tl(jj,:), br(jj,:));
        % If the file doesn't exist - continue
        if mask_area==-1
            continue
        end
        
        if mask_area==0
            disp([id_file,' - is empty!']);
            continue
        end
        % If there are : gt & mask
        % classify them, according to their type
        %--------------------------------
        valid_i = valid_i+1;
        all_data(valid_i) = data_tamplate;
        all_data(valid_i).file_id = id_file;
        all_data(valid_i).A = w(jj)*h(jj);
        %     all_data(valid_i).h = h(jj);
        all_data(valid_i).type = type(jj);
        % Shape according to given legend
        switch type(jj)
            case 'A'
                all_data(valid_i).shape = shape_legend{1};%'up_tri';
            case 'B'
                all_data(valid_i).shape = shape_legend{2};%'down_tri';
            case {'C','D','E'}
                all_data(valid_i).shape = shape_legend{3};%'circle';
            case {'F'}
                all_data(valid_i).shape = shape_legend{4};%'cube';
        end
        % Colour according to given legend
        % WHITE
        %-----
        if any(strcmpi( type(jj),{'A','B','C','D','F'}))
            all_data(valid_i).color_wrbk(1,1) = true;
        end
        % RED
        %-----
        if any(strcmpi( type(jj),{'A','B','C','E'}))
            all_data(valid_i).color_wrbk(1,2) = true;
        end
        % BLUE
        %-----
        if any(strcmpi( type(jj),{'D','E','F'}))
            all_data(valid_i).color_wrbk(1,3) = true;
        end
        % BLACK
        %-----
        if any(strcmpi( type(jj),{'A','F'}))
            all_data(valid_i).color_wrbk(1,4) = true;
        end
        
        all_data(valid_i).form_factor = w(jj)/h(jj);
        all_data(valid_i).fill_factor = mask_area/(w(jj)*h(jj));
        all_data(valid_i).index = mask_index;
         all_data(valid_i).mass_center = mass_center;
        % Adding shape and color according to ground
    end
end



% Statistics
% ===========
% I. basic - statistic
% form_factor and fill factor are [min,max]
statistic_table = struct('type','','number',0,'form_factor',[0,0],'fill_factor',[0,0],'A',[0,0],'MC_row',[0,0],'MC_col',[0,0]);


for ii = 1: length(type_legend)
    tmp = all_data(strcmp({all_data.type},type_legend{ii}));
    statistic_table(ii).type = type_legend{ii};
    statistic_table(ii).number = numel(tmp);
    statistic_table(ii).form_factor = [min([tmp.form_factor]),max([tmp.form_factor])];
    statistic_table(ii).fill_factor = [min([tmp.fill_factor]),max([tmp.fill_factor])];
    statistic_table(ii).A = [min([tmp.A]),max([tmp.A])];
    B = [tmp.mass_center];
    B = reshape(B,2,[])';
    statistic_table(ii).MC_row = [min([B(:,1)]),max([B(:,1)])];
    statistic_table(ii).MC_col = [min([B(:,2)]),max([B(:,2)])];
    % statistic plots
    %------------------
    Type_number_str{ii} = [type_legend{ii},'- #',num2str(statistic_table(ii).number)];
    
end
% For Each shape
% choosing the bin according to the absolute min-max
% --------------------------------------------------
n=10; % not enought data
num_bin_form = linspace(min([statistic_table.form_factor]),max([statistic_table.form_factor]),n);%[0:0.1:1];
% num_bin_fill = [0:0.1:1];
num_bin_fill = linspace(min([statistic_table.fill_factor]),max([statistic_table.fill_factor]),n);%[0:0.1:1];
num_bin_area = linspace(min([all_data.A]),max([all_data.A]),n);%[0:0.1:1];
num_bin_mass_c = linspace(min([all_data.mass_center]),max([all_data.mass_center]),n);
for ii = 1: length(type_legend)
    tmp = all_data(strcmp({all_data.type},type_legend{ii}));
    
    % fill factor
    [tmp_hist1] = hist([tmp.fill_factor],num_bin_fill);
    Y1(:,ii) = tmp_hist1/statistic_table(ii).number;
    
    % form factor
    [tmp_hist2] = hist([tmp.form_factor],num_bin_form);
    Y2(:,ii) = tmp_hist2/statistic_table(ii).number;
    % Area
    [tmp_hist3] = hist([tmp.A],num_bin_area);
    Y3(:,ii) = tmp_hist3/statistic_table(ii).number;
    
    % Mass Center
    B = [tmp.mass_center];
    B = reshape(B,2,[])';
    [tmp_hist4] = hist(B(:,1),num_bin_mass_c);
    Y4(:,ii) = tmp_hist4/statistic_table(ii).number;
   [tmp_hist5] = hist(B(:,2),num_bin_mass_c);
    Y5(:,ii) = tmp_hist5/statistic_table(ii).number;
end
if plot_flag
    figure(1);
    bar3(num_bin_fill,Y1)
    gca
    set(gca,'XTickLabel',type_legend);
    %set(gca,'YLim', [-0.05,1.05]);
    title({'Fill-Factor histogram'; 'Normalized by the number of object per type'})
    legend(Type_number_str)
    figure(2);
    bar3(num_bin_form,Y2);
    set(gca,'XTickLabel',type_legend);
    %set(gca,'YLim', [-0.05,1.05]);
    title({'Form-Factor histogram'; 'Normalized by the number of object per type'})
    legend(Type_number_str);
    
    % ploting the patch histogram of the patch Area ( number of pix)
    %
    figure(3);
    bar3(num_bin_area,Y3);
    set(gca,'XTickLabel',type_legend);
    %set(gca,'YLim', [-0.05,1.05]);
    title({'Area size [pix] histogram'; 'Normalized by the number of object per type'})
    legend(Type_number_str);
    
        figure(4);
        subplot(2,1,1)
    bar3(num_bin_mass_c,Y4);
    set(gca,'XTickLabel',type_legend);
    title('Row[%]');
            subplot(2,1,2)
    bar3(num_bin_mass_c,Y5);
    set(gca,'XTickLabel',type_legend);
    title('Col[%]');
    %set(gca,'YLim', [-0.05,1.05]);
    suptitle({'Mass-Center (% from tl)'; 'Normalized by the number of object per type'})
    legend(Type_number_str);
end
% Explanation to the data analysis
%==================================
% Fill Factor
%============
% Using Classic Geometric shapes
%
% Triangle will have a fill-factor of 0.5 [wh /(wh/2)]
% Type A & B
%
% Circle Will have a fill factor of 2/pi=~0.6366 [wh/(pi*(w/2)^2)]
% Type C , D, E
%
% Cubic will have a perfect fill-factor of 1
% Type F
%
% Form Factor
%-------------
% Form Factor is subjective according to the camera's view angle and the
% traffic sign angle
%
% If the Form factor is <1 (w > h)
% there is an horizontal angle between the viewer and the traffic sign
% plane ( side-ways)-- the
%
% If the Form factor is >1 (w < h)
% there is an vertical angle between the viewer and the traffic sign
% plane (up-down)
%
% Area
%-----
% The distance from the Camera-
% it will be harder to detact a traffic sign from far distance because it contain
% less data (pixels) to Analyze- for exp: it will be harder to detrmine the
% shape because of the quntization.
end