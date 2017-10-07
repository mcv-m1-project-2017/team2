function [ all_data_struct_out ] = split_data( statistic_table,all_data_struct )
Types = {'A','B','C','D','E','F'};
%split_data
%   ?????
% trial
%==================================================================================
% We want samples from 3 different criterias in each group (the training & the test data-set):
% 1. Area
%   from far and near distance
% 2. Form_ractor
%   variance of deformations
% 3. multi- sign images
%   images that have more than 1 sign.
%===================================================================================
% Will give each sign 2 types of grade
%-------------------------------------
% distributed uniformlly
% 1. Area
%       1- Small
%       2- large
% 2. Form- Factor
%       1- high
%       2- Norml
%       3- wide



% Deviation indexs
form_vec = [1:3];
area_vec = [1:2];


Acomb = combvec(form_vec,area_vec);
Acomb = Acomb';


% list of all images
[~,idx,id_idx_grp] = unique({all_data_struct.file_id});
% Area and form will be only of the first sign
all_image_data = all_data_struct(idx);
Group_list = id_idx_grp(idx);
% number of repetition in each image

R = histc(id_idx_grp,Group_list);



% loop on Each combination
%--------------------------
% count_A = statistic_table(1).number;
% count_B = statistic_table(2).number;
% count_C = statistic_table(3).number;
% count_D = statistic_table(4).number;
% count_E = statistic_table(5).number;
% count_F = statistic_table(6).number;

validation_id = '';
total_count = 1;
all_data_struct_out = all_data_struct;
for ty = 1: length(statistic_table)
    % only the signs in this type
    ty_idx = strcmp({all_image_data.type},Types{ty});
    type_block =  all_image_data(ty_idx);
    mid_A       = median([type_block.A]);
    
    % Form Devition
    
    
    form_values = sort([type_block.form_factor]);
    mid_form_low    = form_values(round(length(form_values)/3));
    mid_form_high   = form_values(2*round(length(form_values)/3));
    Area_block= ones(size(type_block));
    
    Area_block([type_block.A]>mid_A)=2;
    
    form_block = ones(size(type_block));
    form_block([type_block.form_factor]>mid_form_low)=2;
    form_block([type_block.form_factor]>mid_form_high)=3;
    
    
    R_block     = R(ty_idx);
    % the number of sign for this type for the validation
    type_count = round(0.3*statistic_table(ty).number);
    
    
    for ii= 1: size(Acomb,1)
        
        
        tmp_block = type_block([Area_block(:)==Acomb(ii,2) & form_block(:)==Acomb(ii,1)]);
        tmp_R   =   R_block([Area_block(:)==Acomb(ii,2) & form_block(:)==Acomb(ii,1)]);
        % random pick
        Count = round(type_count/size(Acomb,1));
        
        while Count>0 && ~isempty(tmp_block)
            logic_idx = false(size(tmp_block));
            I_block = randperm(length(tmp_block),1);
            logic_idx(I_block) = true;
            validation_id{total_count} = tmp_block(I_block).file_id;
            
            in_list_idx = find([strcmp({all_data_struct_out.file_id},tmp_block(I_block).file_id)]);
            for ss =1: tmp_R(I_block)
                all_data_struct_out(in_list_idx(ss)).validation = 1;
            end
            total_count = total_count+1;
            % count down the number of picks
            Count       = Count-tmp_R(I_block);
            tmp_block   = tmp_block(~logic_idx);
            tmp_R       = tmp_R(~logic_idx);
        end
        
    end
    
end

end

