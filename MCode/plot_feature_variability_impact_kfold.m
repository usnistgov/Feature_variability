

% [OUTPUT_kfold, CVP_kfold] = feature_variability_impact_kfold;
load OUTPUT_kfold
load Common_feature_type
k_fold = length(OUTPUT_kfold);
nb_features = size(OUTPUT_kfold{1},1);
feature_name_table = cell2table(OUTPUT_kfold{1,1}{:,1});
feature_name_table.Properties.VariableNames{'Var1'} = 'Feature_name';

% Plot histogram of feature range
TF = OUTPUT_kfold{1}.Feature_values;
figure, hist(TF{28}.CellProfiler_Texture_Contrast_3_0,70);
figure, hist(TF{32}.CellProfiler_Texture_AngularSecondMoment_3_0,70);
classifier_ind = 1;

Tools_to_plot = {'Python'; 'CellProfiler'; 'MaZda'; 'ImageJ'; 'Java'};
nb_tools = length(Tools_to_plot);

% Get the features that are computed for a given tool
feature_tool_indx = false(nb_features,nb_tools);
for t = 1:nb_tools
    tool = Tools_to_plot{t};
    for f = 1:nb_features
        % Find indexes of this tool name for every feature.
        find_indx_cell = cellfun(@(x)strfind(x,tool),OUTPUT_kfold{1}.Tool_name{f},'UniformOutput',0);
        feature_tool_indx(f,t) = sum(~cellfun(@isempty,find_indx_cell));
    end
end

% The common_feature_table shows the number of features in common between a pair of tools
common_feature_table = cell2table(cell(nb_tools,nb_tools), 'VariableNames', Tools_to_plot, 'RowNames', Tools_to_plot);
% The feature_variability_table shows the number of features that express differences in values larger than 0.1% between a pair of tools
feature_variability_table = array2table(cell(nb_tools,nb_tools), 'VariableNames', Tools_to_plot, 'RowNames', Tools_to_plot);
% The feature_impact_table shows the number of ROI (out of 70 total) that were classified differently between a pair of tools
feature_impact_table = array2table(cell(nb_tools,nb_tools), 'VariableNames', Tools_to_plot, 'RowNames', Tools_to_plot);
for t1 = 1:nb_tools-1
    tool1_name = Tools_to_plot{t1};
    for t2 = t1+1:nb_tools
        tool2_name = Tools_to_plot{t2};
        
        % find the features in common between these two tools
        common_features_2_tools = feature_tool_indx(:,t1) & feature_tool_indx(:,t2);
        common_feature_table{t1,t2} = {common_features_2_tools};
        
        % Initialize the difference between tools
        feature_diff = nan(nb_features,k_fold);
        feature_class_diff = nan(nb_features,k_fold);
        for f = 1:nb_features
            
            % if not common feature between the two tools, skip it
            if ~common_features_2_tools(f), continue, end
            
            % Get tool1 and tool2 index in the list of all available tools
            find_indx_cell = cellfun(@(x)strfind(x,tool1_name),OUTPUT_kfold{1}.Tool_name{f},'UniformOutput',0);
            tool1_ind = find(~cellfun(@isempty,find_indx_cell));
            find_indx_cell = cellfun(@(x)strfind(x,tool2_name),OUTPUT_kfold{1}.Tool_name{f},'UniformOutput',0);
            tool2_ind = find(~cellfun(@isempty,find_indx_cell));
            
            % Get feature values from both tools for all k_fold
            for g = 1:k_fold
                F1 = OUTPUT_kfold{g}.Feature_values{f}{:,tool1_ind(1)};
                F2 = OUTPUT_kfold{g}.Feature_values{f}{:,tool2_ind(1)};
                
                % Compute the number of features that differ more that 0.1%
                D = (F1-F2)./mean([F1,F2],2);
                feature_diff(f,g) = sum( D > 0.001);
                
                % Get classification for each tool
                C1 = OUTPUT_kfold{g}.Prediction{f,1}{1,classifier_ind}{1}{:,tool1_ind(1)};
                C2 = OUTPUT_kfold{g}.Prediction{f,1}{1,classifier_ind}{1}{:,tool2_ind(1)};
                feature_class_diff(f,g) = sum((C1-C2)~=0);
            end
        end
        
        % save results as average values computed from all k_fold runs
        feature_variability_table{t1,t2} = {mean(feature_diff,2)};
        feature_impact_table{t1,t2} = {mean(feature_class_diff,2)};
    end
end

% Get the number of common features between tools and the number of features that vary with more than 1%
common_features_matrix = cellfun(@(x)sum(x>0),table2cell(common_feature_table));
common_features_matrix = array2table(common_features_matrix, 'VariableNames', Tools_to_plot, 'RowNames', Tools_to_plot);
common_features_variability_matrix = cellfun(@(x)sum(x>0),table2cell(feature_variability_table));
common_features_variability_matrix = array2table(common_features_variability_matrix, 'VariableNames', Tools_to_plot, 'RowNames', Tools_to_plot);

% Get the common features numbers and the feature variability numbers by feature type: intensity, shape and texture
unique_feature_type_names = unique(Common_feature_type);
m = 1;
TT = cell(1,1);
for t1 = 1:nb_tools-1
    tool1_name = Tools_to_plot{t1};
    for t2 = t1+1:nb_tools
        tool2_name = Tools_to_plot{t2};
        cf = common_feature_table{t1,t2}{1}>0; % common feature index between t1 and t2
        fv = feature_variability_table{t1,t2}{1}>0; % feature variability value between t1 and t2
        for i = 1:length(unique_feature_type_names)
            feature_type_ind = strcmp(unique_feature_type_names(i),Common_feature_type);
            TT{m,1} = [tool1_name ' VS ' tool2_name];
            TT{m,i+1} = [num2str(sum(fv(feature_type_ind))) '/' num2str(sum(cf(feature_type_ind)))];
        end
        m = m+1;
    end
end
common_features_variability_matrix_feature_type = array2table(TT, 'VariableNames', [{'Software'}; unique_feature_type_names]);
writetable(common_features_variability_matrix_feature_type,'common_features_variability_matrix_feature_type.csv')

% Plot results for variability
figure, hold on
% plot_color = jet(nb_tools*(nb_tools-1)/2);
plot_color = linspecer(nb_tools*(nb_tools-1)/2);
legend_label = [];
m = 1;
TT = [];
marker_plot = '>ox^+*sd<v';
for t1 = 1:nb_tools-1
    tool1_name = Tools_to_plot{t1};
    for t2 = t1+1:nb_tools
        tool2_name = Tools_to_plot{t2};
        cf = common_feature_table{t1,t2}{1};
        h = plot(feature_variability_table{t1,t2}{1},1:nb_features);
        TT(:,m) = feature_variability_table{t1,t2}{1};
        h.Color = plot_color(m,:);
        h.LineStyle = 'none';
        h.LineWidth = 2;
        h.Marker = marker_plot(m);
        h.MarkerSize = 8;
        legend_label{m} = [tool1_name ' VS ' tool2_name];
        m = m+1;
    end
end
legend(legend_label)
set(gca,'FontSize',30)
for i = 1:length(legend_label), legend_label{i} = legend_label{i}(~isspace(legend_label{i})); end
TT = array2table(TT,'VariableNames',legend_label);
TT = [feature_name_table TT];
writetable(TT,'Feature_variability.csv')
a = gca;
a.YTick = 0:5:nb_features;
% a.XTickLabel = OUTPUT_kfold{1}{:,3};


% Get the number of features that impacted the stem cell colony classification
common_features_impact_matrix = cellfun(@(x)sum(x>0),table2cell(feature_impact_table));
common_features_impact_matrix = array2table(common_features_impact_matrix, 'VariableNames', Tools_to_plot, 'RowNames', Tools_to_plot);

% Plot results for impact
figure, hold on
plot_color = linspecer(nb_tools*(nb_tools-1)/2);
legend_label = [];
m = 1;
TT = [];
for t1 = 1:nb_tools-1
    tool1_name = Tools_to_plot{t1};
    for t2 = t1+1:nb_tools
        tool2_name = Tools_to_plot{t2};
        cf = common_feature_table{t1,t2}{1};
        h = plot(feature_impact_table{t1,t2}{1},1:nb_features);
        TT(:,m) = feature_impact_table{t1,t2}{1};
        h.Color = plot_color(m,:);
        h.LineStyle = 'none';
        h.LineWidth = 2;
        h.Marker = marker_plot(m);
        h.MarkerSize = 8;
        legend_label{m} = [tool1_name ' VS ' tool2_name];
        m = m+1;
    end
end
legend(legend_label)
set(gca,'FontSize',30)
for i = 1:length(legend_label), legend_label{i} = legend_label{i}(~isspace(legend_label{i})); end
TT = array2table(TT,'VariableNames',legend_label);
TT = [feature_name_table TT];
writetable(TT,'Feature_variability_impact.csv')
a = gca;
a.YTick = 0:5:nb_features;
% a.YTickLabel = table2cell(feature_name_table);
