

function output = add_multiple_features_classification(output,tools_name,Y,CVP_kfold,methods_name,methods_name_opts,name_similarity_metric)

% number of single features
nb_sing_feat = size(output,1);
total_nb_tools = length(tools_name);
nb_machine_learning_methods = length(methods_name_opts);

for c = 2:3 % number of combined features
    tic
    comb_mat = combnk(1:nb_sing_feat,c); % total combinations for c features
    [nb_comb, nb_feat_comb] = size(comb_mat); % Get the number of combinations and the number of features to combine
    output_temp = cell(nb_comb,8); % THIS INITIALIZATION MUST FOLLOW THE ONE IN "feature_variability_impact_kfold.m" FUNCTION
    for i = 1:nb_comb
        % Find tools that are in common with this combination of features
        tools_feat_mat = zeros(total_nb_tools,nb_feat_comb);
        for h = 1:nb_feat_comb
            for j = 1:total_nb_tools
                str_comp = strfind(output.Tool_name{comb_mat(i,h)},tools_name{j});
                str_comp = cellfun(@isempty,str_comp);
                tools_feat_mat(j,h) = sum(~str_comp);
            end
        end
        
        % tools_ind is an indicator that a tool i (row i) computes all features in this combination
        tools_ind = all(tools_feat_mat,2);
                
        % THIS CODE MUST FOLLOW THE ONE IN "feature_variability_impact_kfold.m" FUNCTION
        output_temp{i,1} = output.Feature_name(comb_mat(i,:)); % Feature name
        % if only one or less tools are in common for this combination, skip it
        if sum(tools_ind) < 2, continue, end
        output_temp{i,2} = tools_name(tools_ind); % tool name
        nb_tools = length(output_temp{i,2});
        
        % train and predict the colony classes using a combination of features
        predicted_Y = cell(1,nb_machine_learning_methods);
        for m = 1:nb_machine_learning_methods
            temp_Y = cell(1,nb_tools);
            for j = 1:nb_tools
                single_tool_name = output_temp{i,2}{j};
                single_tool_ind = strfind(output.Tool_name{comb_mat(i,1)},single_tool_name);
                single_tool_ind = ~cellfun(@isempty,single_tool_ind);
                X = output.Feature_values{comb_mat(i,1)}{:,single_tool_ind};
                for h = 2:nb_feat_comb
                    single_tool_ind = strfind(output.Tool_name{comb_mat(i,h)},single_tool_name);
                    single_tool_ind = ~cellfun(@isempty,single_tool_ind);
                    X = [X output.Feature_values{comb_mat(i,h)}{:,single_tool_ind}]; %#ok<AGROW>
                end
                [~,temp_Y(j)] = compute_k_fold_accuracy(X,Y,CVP_kfold,1,methods_name_opts{m},name_similarity_metric);
            end
            predicted_Y{1,m} = array2table(cell2mat(temp_Y),'VariableNames',output_temp{i,2});
        end
        output_temp{i,6} = cell2table(predicted_Y,'VariableNames',methods_name); % predicted values per method and tool
        
        % Compute differences between prediction for each pair of tools
        output_temp{i,7} = cell(1,nb_machine_learning_methods);
        for m = 1:nb_machine_learning_methods
            output_temp{i,7}{m} = zeros(nb_tools);
            for j = 1:nb_tools-1
                for h = j+1:nb_tools
                    output_temp{i,7}{m}(j,h) = sum((output_temp{i,6}{1,m}{1}{:,j} - output_temp{i,6}{1,m}{1}{:,h}) ~= 0);
                end
            end
        end
        output_temp{i,7} = cell2table(output_temp{i,7},'VariableNames',methods_name);
        
        % indicator if there was an impact that affected classification by using multiple tools
        output_temp{i,8} = zeros(1,nb_machine_learning_methods);
        for m = 1:nb_machine_learning_methods
            output_temp{i,8}(m) = sum(output_temp{i,7}{1,m}{1}(:))>0;
        end
    end
    output_temp = cell2table(output_temp, ...
        'VariableNames', {'Feature_name', 'Tool_name', 'Group_ID', 'Feature_values', 'Feature_correlation', 'Prediction', 'Difference', 'impact'});
    toc
    output = [output;output_temp];
end

