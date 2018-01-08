
function [OUTPUT_kfold, CVP_kfold] = feature_variability_impact_kfold

% Input the tools name, this variable should include all the tools that exist in the outputed csv file
tools_name = {'Feature2DPython'; 'Feature2DMatlab'; 'CellProfiler'; 'MaZda'};

% Initialize machine learning methods
methods_name_opts = create_classification_methods;
methods_name = cellfun(@(x)x.name, methods_name_opts,'UniformOutput',0);
nb_methods = length(methods_name_opts);
for i = 1:nb_methods
    if strcmp(methods_name{i},'fitctree')
        methods_name{i} = [methods_name_opts{i}.name '_' methods_name_opts{i}.SplitCriterion];
    end
end
name_similarity_metric = 'RMSPE';
max_numTrees = 250;

% Read Original Feature Matrix and manual colony classification annotations
% T = readtable('Texture_feature_variability_impact_results.csv');
load T
nb_observations = size(T,1);
Y = readtable('manual_annotation.csv');
Y = Y{:,'Tags'};
% categorical column homogeneous, heterogeneous and dark
u = unique(Y);
v = 1:length(u);
Y = cellfun(@(x)v(strcmp(x,u)),Y);

% Load common features file. This file is manually derived and coresponds to table T
[~,~,Common_Features_cell] = xlsread('Common_Features_v3.xlsx');
% Keep info related only to texture features
% texture_feat_ind = cellfun(@(x)strcmp(x,'texture'), Common_Features_cell(:,3));
% Common_Features_cell = Common_Features_cell(texture_feat_ind,:);
% Keep only common texture features
not_common_feat = cellfun(@(x)strcmp(x,'[]'), Common_Features_cell(:,4));
Common_Features_cell = Common_Features_cell(~not_common_feat,:);
if strcmp(Common_Features_cell{1,4},'Clustered by Features'), Common_Features_cell(1,:) = []; end
group_ind = cell2mat(Common_Features_cell(:,4)); % the group index of each common feature
group_ind_binary = false(max(group_ind),1);
group_ind_binary(group_ind) = 1; % binary indicator to know when we get to a group number during for loop below
nb_common_features = sum(group_ind_binary);

% Create a train and test dataset
k_fold = 10;
CVP_kfold = cell(k_fold,1);
for i = 1:10
    cvp = cvpartition(nb_observations, 'kfold', 2); % split randomly into two sets
    CVP_kfold{i} = cvp;
end

% Initialize output and compute variability impact using one feature
OUTPUT_kfold = cell(k_fold,1);
for g = 1:k_fold
    output = cell(nb_common_features+1,8);
    n = 1;
    for i = 1:length(group_ind_binary)
        % if group doesn't exist skip it
        if ~group_ind_binary(i), continue, end
        ind = find(group_ind == i); % Index of tools that compute feature i
        nb_tools = length(ind);
        ind_name = strfind(Common_Features_cell{ind(1),1},'_');
        output{n,1} = Common_Features_cell{ind(1),1}(ind_name+1:end); % Feature name
        output{n,2} = Common_Features_cell(ind,1); % Feature name including tool name
        output{n,3} = i; % group ID
        output{n,4} = array2table(T{:,Common_Features_cell(ind,1)},'VariableNames',Common_Features_cell(ind,1)); % Feature values
        output{n,5} = array2table(corrcoef(T{:,Common_Features_cell(ind,1)}),...
            'VariableNames',Common_Features_cell(ind,1),'RowNames',Common_Features_cell(ind,1)); % correlation between features
        
        % train and predict the colony classes using each computed feature per tool
        predicted_Y = cell(1,nb_methods);
        for m = 1:nb_methods
            temp_Y = cell(1,nb_tools);
            for j = 1:nb_tools
                X = output{n,4}{:,j};
                [~,temp_Y(j)] = compute_k_fold_accuracy(X,Y,CVP_kfold{g},1,methods_name_opts{m},name_similarity_metric);
            end
            predicted_Y{1,m} = array2table(cell2mat(temp_Y),'VariableNames',Common_Features_cell(ind,1));
        end
        output{n,6} = cell2table(predicted_Y,'VariableNames',methods_name); % predicted values per method and tool
        
        % Compute differences between prediction for each pair of tools
        output{n,7} = cell(1,nb_methods);
        for m = 1:nb_methods
            output{n,7}{m} = zeros(nb_tools);
            for j = 1:nb_tools-1
                for h = j+1:nb_tools
                    output{n,7}{m}(j,h) = sum((output{n,6}{1,m}{1}{:,j} - output{n,6}{1,m}{1}{:,h}) ~= 0);
                end
            end
        end
        output{n,7} = cell2table(output{n,7},'VariableNames',methods_name);
        
        % indicator if there was an impact that affected classification by using multiple tools
        for m = 1:nb_methods
            output{n,8}{1}(m) = sum(output{n,7}{1,m}{1}(:))>0;
        end
        n = n+1;
    end
    
    % Convert output to table
    output = cell2table(output, ...
        'VariableNames', {'Feature_name', 'Tool_name', 'Group_ID', 'Feature_values', 'Feature_correlation', 'Prediction', 'Difference', 'impact'});
    
    % delete last row, it was used just to force Matlab to stick with cell arrays
    output(end,:) = [];
    
    % Add multiple features for classification
%     output = add_multiple_features_classification(output,tools_name,Y,CVP_kfold{g},methods_name,methods_name_opts,name_similarity_metric);
    
    % Save to output variable
    OUTPUT_kfold{g} = output;        
end
save OUTPUT_kfold OUTPUT_kfold
save CVP_kfold CVP_kfold

