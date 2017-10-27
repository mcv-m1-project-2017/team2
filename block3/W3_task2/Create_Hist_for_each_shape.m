% ------------------------------------------------------------------------- %
%                      Create_Hist_for_each_shape                           %
% ------------------------------------------------------------------------- %
% Function "Create_Hist_for_each_shape" given the training data set features%
% create a key map to give a score to a potantial Bbox                      %
%                                                                           %
%  Input parameters                                                         %
%   ----------------                                                        %
%        all_data:  struct with data for each traffic sign                  %
%                                                                           %
%        type:  {'A':'F'} can be more than 1 type                           %
%                                                                           %
%        plot_flag(Optional): ploting the 3 maps for this specific cluster  %
%                 default : false                                           %
%        plot_flag:(Optional) ploting a subplot with 4 images with the Bbox %
%                  default : false                                          %
%                                                                           %
%   Output variables                                                        %
%   ----------------                                                        %
%        ff_vmc: [10x10] , 1 is the best score
%
%   Method
%   ------
%       Combining 3 score The weights for each one as a defult are equal    %
%       (1/3)
%       (1) K means for the proximity to Clusteer center of the Shape,      %
%       using Fill-factor vs Mass Center (Vertical)                         %
%           Spliting the Data into 4 shapes:                                %
%               -Triangle Up,                                               %
%               -Triangle Down,                                             %
%               -Circle ,                                                   %
%               -Rectangle                                                  %
%                                                                           %
%       (2) Mass Center (Horizontal), Shapes are symmertic, higer score to  %
%           a symmetric shape.                                              %
%       (3) Aspect ratio, Higher score to 1:1 ratio between h:w             %
% -----------------------------------------------------------------------   %

% -----------------------------------------------------------------------   %
function [ ff_vmc,hmc,fr ] = Create_Hist_for_each_shape( all_data,type,bins, plot_flag )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if nargin<2 || isempty(type)
    type = {'A','B','C','D','E','F'};
end
if nargin<4
    plot_flag = false;
end

if nargin<3
    bins =10;
end
shape_data = all_data(ismember({all_data.type},type));
mc  =reshape([shape_data.mass_center],2,[])';
min_val_mc = 0.1;
max_val_mc = 0.9;

vmc = mc(:,1);

hmc_data = mc(:,2);
fr_data  = [shape_data.form_factor];
ff_data  = [shape_data.fill_factor];

% Form-Ratio
%----------
[fr.Weight,C] = hist(fr_data(:),bins);

fr.Weight = fr.Weight./max(fr.Weight);
fr.C_fr = C;

% zero padding
fr.C_fr = [0,C,2];
fr.Weight = [0,fr.Weight,0];

% HMC
%----------
[hmc.Weight,C] = hist(hmc_data(:),bins);

hmc.Weight = hmc.Weight./max(hmc.Weight);
% zero padding
hmc.C_hmc = [min_val_mc,C,max_val_mc];
hmc.Weight = [0,hmc.Weight,0];
% FF vs VMC
%----------

[ff_vmc.Weight,C] = hist3([ff_data(:),vmc],[bins,bins]);
close gcf
% zero padding
%ff 
C{1} = [0.2,C{1}];
C{2} = [min_val_mc,C{2} ,max_val_mc];
[C_ff,C_vmc]= meshgrid(C{1},C{2});


ff_vmc.Weight   = ff_vmc.Weight./max(ff_vmc.Weight(:));
tmp = zeros(size(C_vmc));
tmp(2:size(ff_vmc.Weight,1)+1,2:size(ff_vmc.Weight,2)+1) = ff_vmc.Weight;
ff_vmc.Weight = tmp;
ff_vmc.C_vmc    = C_vmc;
ff_vmc.C_ff     = C_ff;

% assuming linear behaviar between 2 values
% because the data is limited
% replacing zero score with a linear interp if its between score>0

Iff_vmc = find(ff_vmc.Weight==0);
[lff_vmc,cff_vmc]= ind2sub(size(ff_vmc.Weight),Iff_vmc);
% remove 1st last lines and col
idx = lff_vmc>1 & cff_vmc>1 &lff_vmc<size(ff_vmc.Weight,1) & cff_vmc<size(ff_vmc.Weight,2);
lff_vmc = lff_vmc(idx); 
cff_vmc = cff_vmc(idx); 
for kk = 1:length(cff_vmc)
    L_up = find(ff_vmc.Weight(1:lff_vmc(kk)-1,cff_vmc(kk))>0,1,'last');
    L_dn = find(ff_vmc.Weight(lff_vmc(kk)+1:end,cff_vmc(kk))>0,1,'first');
    
    C_left = find(ff_vmc.Weight(lff_vmc(kk),1:cff_vmc(kk)-1)>0,1,'last');
    C_right = find(ff_vmc.Weight(lff_vmc(kk),cff_vmc(kk)+1:end)>0,1,'first');
    
    if  ~isempty(L_up) && ~isempty(L_dn) && ~isempty(C_left) && ~isempty(C_right)
        C_right= C_right+cff_vmc(kk);
        x = [ff_vmc.C_ff(lff_vmc(kk),C_left),ff_vmc.C_ff(lff_vmc(kk),C_right)];
        y = [ff_vmc.Weight(lff_vmc(kk),C_left),ff_vmc.Weight(lff_vmc(kk),C_right)];
        
        z1 = interp1(x,y,ff_vmc.C_ff(lff_vmc(kk),cff_vmc(kk)));
         L_dn= L_dn+lff_vmc(kk);
        x = [ff_vmc.C_vmc(L_up,cff_vmc(kk)),ff_vmc.C_vmc(L_dn,cff_vmc(kk))];
        y = [ff_vmc.Weight(L_up,cff_vmc(kk)),ff_vmc.Weight(L_dn,cff_vmc(kk))];
        
        z2 = interp1(x,y,ff_vmc.C_vmc(lff_vmc(kk),cff_vmc(kk)));
       
        ff_vmc.Weight(lff_vmc(kk),cff_vmc(kk)) = (z1+z2)/2;
    elseif  ~isempty(C_left) && ~isempty(C_right)
        C_right= C_right+cff_vmc(kk);
        x = [ff_vmc.C_ff(lff_vmc(kk),C_left),ff_vmc.C_ff(lff_vmc(kk),C_right)];
        y = [ff_vmc.Weight(lff_vmc(kk),C_left),ff_vmc.Weight(lff_vmc(kk),C_right)];
        
        ff_vmc.Weight(lff_vmc(kk),cff_vmc(kk)) = interp1(x,y,ff_vmc.C_ff(lff_vmc(kk),cff_vmc(kk)));
%         ff_vmc.Weight(lff_vmc(kk),cff_vmc(kk)) = (ff_vmc.Weight(lff_vmc(kk),C_left)+ff_vmc.Weight(lff_vmc(kk),C_right))/2;
    elseif ~isempty(L_up) && ~isempty(L_dn)
        L_dn= L_dn+lff_vmc(kk);
        x = [ff_vmc.C_vmc(L_up,cff_vmc(kk)),ff_vmc.C_vmc(L_dn,cff_vmc(kk))];
        y = [ff_vmc.Weight(L_up,cff_vmc(kk)),ff_vmc.Weight(L_dn,cff_vmc(kk))];
        
        ff_vmc.Weight(lff_vmc(kk),cff_vmc(kk)) = interp1(x,y,ff_vmc.C_vmc(lff_vmc(kk),cff_vmc(kk)));
        
    end
        % it between 2 values
end
Ihmc = find(hmc.Weight==0);

% remove 1st last lines and col
idx = Ihmc>1 & Ihmc<length(hmc.Weight);
Ihmc = Ihmc(idx); 

for kk = 1:length(Ihmc)

    
    C_left = find(hmc.Weight(1:Ihmc(kk)-1)>0,1,'last');
    C_right = find(hmc.Weight(Ihmc(kk)+1:end)>0,1,'first');
    
  if  ~isempty(C_left) && ~isempty(C_right)
      C_right= C_right+Ihmc(kk);
        x = [hmc.C_hmc(C_left),hmc.C_hmc(C_right)];
        y = [hmc.Weight(C_left),hmc.Weight(C_right)];
        
        hmc.Weight(Ihmc(kk)) = interp1(x,y,hmc.C_hmc(Ihmc(kk)));
   end
        % it between 2 values
end

Ifr = find(fr.Weight==0);
idx = Ifr>1 & Ifr<length(fr.Weight);
Ifr = Ifr(idx); 

for kk = 1:length(Ifr)

    
    C_left = find(fr.Weight(1:Ifr(kk)-1)>0,1,'last');
    C_right = find(fr.Weight(Ifr(kk)+1:end)>0,1,'first');
    
  if  ~isempty(C_left) && ~isempty(C_right)
        C_right= C_right+Ifr(kk);
        x = [fr.C_fr(C_left),fr.C_fr(C_right)];
        y = [fr.Weight(C_left),fr.Weight(C_right)];
        
        fr.Weight(Ifr(kk)) = interp1(x,y,fr.C_fr(Ifr(kk)));
        
   end
        % it between 2 values
end
if plot_flag
    
    figure;
    imagesc(C{1},C{2},ff_vmc.Weight);
    
    colormap(hot);
    xlabel('Vertical Mass-Center[%]'); % [ % from height counting from up -> down]
    ylabel('Fill-factor');
    title ({'FF vs V MC :';['types: ',type{:}]});
    figure;
    bar(fr.C_fr,fr.Weight);
    xlabel('form - ratio [h/w]');
    title ({'RATIO';['types: ',type{:}]});
    figure;
    bar(hmc.C_hmc,hmc.Weight);
    xlabel('Horizontal Mass-Center[%]');
    title ({'H MC';['types: ',type{:}]});
else
    close all;
end

