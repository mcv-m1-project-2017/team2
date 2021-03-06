function [ all_data_struct_out ] = split_data( statistic_table,all_data_struct )
    Types = {'A','B','C','D','E','F'};
    % ==================================================================================
    % We want samples from 3 different criterias in each group (the training & the validation dataset):
    % 1. Area
    %   from far and near distance
    % 2. Form-Factor
    %   variance of deformations
    % 3. Multi-sign images
    %   images that have more than 1 traffic sign.
    % ===================================================================================
    % Will give each sign 2 types of grade
    % -------------------------------------
    % Distributed uniformally
    % 1. Area
    %       1- Small
    %       2- Large
    % 2. Form-Factor
    %       1- High
    %       2- Normal
    %       3- Wide



    % Deviation indeces
    form_vec = [1:3];
    area_vec = [1:2];


    Acomb = combvec(form_vec,area_vec);
    Acomb = Acomb';


    % List of all images
    [~,idx,id_idx_grp] = unique({all_data_struct.file_id});
    % Area and form will be only of the first sign
    all_image_data = all_data_struct(idx);
    Group_list = id_idx_grp(idx);
    % Number of repetition in each image

    R = histc(id_idx_grp,Group_list);



    % Loop on Each combination
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
        % Only the signs in this type
        ty_idx = strcmp({all_image_data.type},Types{ty});
        type_block =  all_image_data(ty_idx);
        mid_A       = median([type_block.A]);

        % Form Deviation


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
            tmp_ii = 1;
            tmp_val_id = {};
            tmp_val_R = [];
            while Count>0 && ~isempty(tmp_block)
                logic_idx = false(size(tmp_block));
                I_block = randperm(length(tmp_block),1);
                logic_idx(I_block) = true;
                validation_id{total_count} = tmp_block(I_block).file_id;
                all_data_struct_out=update_validation_field(all_data_struct_out,tmp_block(I_block).file_id,1);
                %             in_list_idx = find([strcmp({all_data_struct_out.file_id},tmp_block(I_block).file_id)]);
                %             for ss =1: tmp_R(I_block)
                %                 all_data_struct_out(in_list_idx(ss)).validation = 1;
                %             end
                tmp_val_id{tmp_ii} = tmp_block(I_block).file_id;
                tmp_val_R(tmp_ii) = tmp_R(I_block);
                tmp_ii = tmp_ii+1;
                total_count = total_count+1;
                % count down the number of picks
                Count       = Count-tmp_R(I_block);
                tmp_block   = tmp_block(~logic_idx);
                tmp_R       = tmp_R(~logic_idx);
            end

            % if we choose to much for the validation group
            if Count<0
                % Number of un-wanted signs
                [tmp_val_R,tmpI] = sort(tmp_val_R,'descend');
                tmp_val_id = tmp_val_id(tmpI);


                while 1

                    if all(tmp_val_R > (-Count))
                        break
                    end
                    tmpI = find(tmp_val_R <= (-Count),1,'first');
                    [all_data_struct_out] = update_validation_field(all_data_struct_out,tmp_val_id{tmpI},0);
                    if tmp_val_R(tmpI) == (-Count)
                        break
                    end
                    % not going to be choosen

                    Count = Count+tmp_val_R(tmpI);
                    tmp_val_R(tmpI) = 1-Count;

                end
                % remove the image from the list
            end

        end
    end

end



function [all_data] = update_validation_field(all_data,file_id,val_flag)
    in_list_idx = find([strcmp({all_data.file_id},file_id)]);

    for ss =1: length(in_list_idx)
        all_data(in_list_idx(ss)).validation = val_flag;
end
end