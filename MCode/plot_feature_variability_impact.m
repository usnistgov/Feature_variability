

[output, cvp] = feature_variability_impact;
nb_features = size(output,1);

% Plot histogram of feature range
TF = output.Feature_values;
figure, hist(TF{1}.CellProfiler_Texture_Contrast_3_0,70);
figure, hist(TF{5}.CellProfiler_Texture_AngularSecondMoment_3_0,70);

Tools_to_plot = {'Python'; 'CellProfiler'; 'MaZda'};
nb_tools = length(Tools_to_plot);

% Get the features that are computed for a given tool
feature_tool_indx = false(nb_features,nb_tools);
for t = 1:nb_tools
    tool = Tools_to_plot{t};
    for f = 1:nb_features
        % Find indexes of this tool name for every feature.
        find_indx_cell = cellfun(@(x)strfind(x,tool),output.Tool_name{f},'UniformOutput',0);
        feature_tool_indx(f,t) = sum(~cellfun(@isempty,find_indx_cell));
    end
end


common_feature_table = cell2table(cell(nb_tools,nb_tools), 'VariableNames', Tools_to_plot, 'RowNames', Tools_to_plot);
feature_variability_table = array2table(cell(nb_tools,nb_tools), 'VariableNames', Tools_to_plot, 'RowNames', Tools_to_plot);
feature_impact_table = array2table(cell(nb_tools,nb_tools), 'VariableNames', Tools_to_plot, 'RowNames', Tools_to_plot);
for t1 = 1:nb_tools-1
    tool1_name = Tools_to_plot{t1};
    for t2 = t1+1:nb_tools
        tool2_name = Tools_to_plot{t2};
        
        % find the features in common between these two tools
        common_features_2_tools = feature_tool_indx(:,t1) & feature_tool_indx(:,t2);
        common_feature_table{t1,t2} = {common_features_2_tools};
        
        % Initialize the difference between tools
        feature_diff = zeros(nb_features,1);
        feature_class_diff = zeros(nb_features,1);
        for f = 1:nb_features
            
            % if not common feature between the two tools, skip it
            if ~common_features_2_tools(f), continue, end
            
            % Get tool1 and tool2 index in the list of all available tools
            find_indx_cell = cellfun(@(x)strfind(x,tool1_name),output.Tool_name{f},'UniformOutput',0);
            tool1_ind = find(~cellfun(@isempty,find_indx_cell));
            find_indx_cell = cellfun(@(x)strfind(x,tool2_name),output.Tool_name{f},'UniformOutput',0);
            tool2_ind = find(~cellfun(@isempty,find_indx_cell));
            
            % Get feature values from both tools
            F1 = output.Feature_values{f}{:,tool1_ind};
            F2 = output.Feature_values{f}{:,tool2_ind};
            
            % Compute the number of features that differ more that 1%
            D = (F1-F2)./mean([F1,F2],2);
            feature_diff(f) = sum( D > 0.001);
            
            % Get classification for each tool
            C1 = output.Prediction{f,1}{1}{:,tool1_ind};
            C2 = output.Prediction{f,1}{1}{:,tool2_ind};
            feature_class_diff(f) = sum((C1-C2)~=0);
        end
        
        % save results
        feature_variability_table{t1,t2} = {feature_diff};
        feature_impact_table{t1,t2} = {feature_class_diff};
    end
end

% Get the number of common features between tools and the number of features that vary with more than 1%
common_features_matrix = cellfun(@(x)sum(x>0),table2cell(common_feature_table));
common_features_matrix = array2table(common_features_matrix, 'VariableNames', Tools_to_plot, 'RowNames', Tools_to_plot);
common_features_variability_matrix = cellfun(@(x)sum(x>0),table2cell(feature_variability_table));
common_features_variability_matrix = array2table(common_features_variability_matrix, 'VariableNames', Tools_to_plot, 'RowNames', Tools_to_plot);

% Plot results for variability
figure, hold on
plot_color = jet(nb_tools*(nb_tools-1)/2);
legend_label = [];
m = 1;
for t1 = 1:nb_tools-1
    tool1_name = Tools_to_plot{t1};
    for t2 = t1+1:nb_tools
        tool2_name = Tools_to_plot{t2};
        cf = common_feature_table{t1,t2}{1};
        h = plot(feature_variability_table{t1,t2}{1});
        h.Color = plot_color(m,:);
        legend_label{m} = [tool1_name ' vs ' tool2_name];
        m = m+1;
    end
end
legend(legend_label)


% Get the number of features that impacted the stem cell colony classification
common_features_impact_matrix = cellfun(@(x)sum(x>0),table2cell(feature_impact_table));
common_features_impact_matrix = array2table(common_features_impact_matrix, 'VariableNames', Tools_to_plot, 'RowNames', Tools_to_plot);

% Plot results for impact
figure, hold on
plot_color = jet(nb_tools*(nb_tools-1)/2);
legend_label = [];
m = 1;
for t1 = 1:nb_tools-1
    tool1_name = Tools_to_plot{t1};
    for t2 = t1+1:nb_tools
        tool2_name = Tools_to_plot{t2};
        cf = common_feature_table{t1,t2}{1};
        h = plot(feature_impact_table{t1,t2}{1});
        h.Color = plot_color(m,:);
        legend_label{m} = [tool1_name ' vs ' tool2_name];
        m = m+1;
    end
end
legend(legend_label)


