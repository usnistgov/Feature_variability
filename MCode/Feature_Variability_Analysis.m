

% This function computes the differences in feature values computed by multiple tools. The only parameter to adjust is the errot threshold on line 13.
% This function takes as input two tables: T1 is the output feature table from the online system http://129.6.18.147:8080/ computed on any user images
% The second table is the manually derived Common feature table between the four tools
% The output is the variable feature_diff_val. A cell array that contains all the necessary output to perform feature variability analysis.

% Read workflow table computed online at http://129.6.18.147:8080/
%  T = readtable('Workflow-Feature_variability_analysis_all-results.csv');
load T

% Load common features file. This file is manually derived and coresponds to table T1
[~,~,Common_Features_cell] = xlsread('Common_Features_v3.xlsx');
Common_Features_cell(1,:) = [];
a = cellfun(@(x)strcmp(x,'[]'),Common_Features_cell(:,4));
Common_Features_vec = Common_Features_cell(:,4);
Common_Features_vec(a) = {0};
Common_Features_vec = cell2mat(Common_Features_vec);

% Error Threshold in percent
ET = 1;

% Loop over the features and compute the differences in values between tools
nb_common_features = max(Common_Features_vec);
Output_feature_diff_val = cell(nb_common_features,8);
for i = 1:nb_common_features
    ind = find(Common_Features_vec == i); % Index of tools that compute feature i
    ind_name = strfind(Common_Features_cell{ind(1),1},'_');
    Output_feature_diff_val{i,1} = Common_Features_cell{ind(1),1}(ind_name+1:end); % Feature name
    Output_feature_diff_val{i,2} = Common_Features_cell(ind,1); % Feature name including tool name
    Output_feature_diff_val{i,3} = T{:,Common_Features_cell(ind,1)}; % Feature values
    Output_feature_diff_val{i,3}(isnan(Output_feature_diff_val{i,3}(:,1)),:) = []; % Feature values
    Output_feature_diff_val{i,4} = zeros(length(ind)); % differences between feature values combinations
    m = mean(Output_feature_diff_val{i,3}(:)); % Global mean value across all tools
    for j = 1:length(ind)
        for k = j+1:length(ind)
            Output_feature_diff_val{i,4}(j,k) = sqrt(mean(Output_feature_diff_val{i,3}(:,j) - Output_feature_diff_val{i,3}(:,k)).^2); % Euclidean distance between tools outputs
            Output_feature_diff_val{i,5} = Output_feature_diff_val{i,4}/m; % Normalized feature values differences with respect to the mean
            Output_feature_diff_val{i,6} = Output_feature_diff_val{i,5} > (ET/100); % Are the differences significant? no = 0, yes = 1
            temp = (Output_feature_diff_val{i,3}(:,j) - Output_feature_diff_val{i,3}(:,k)) ./ min(Output_feature_diff_val{i,3}(:,j), Output_feature_diff_val{i,3}(:,k));
            Output_feature_diff_val{i,7}{j,k} = temp; % How many ROIs had an error larger than ET% between the tools
            Output_feature_diff_val{i,8}(j,k) = sum(abs(temp) > ET/100); % How many ROIs had an error larger than ET% between the tools
        end
    end
end

% Compute two metrics. The sum(m1>0) and sum(m2>0) will give the number if featues that express differences between tools
m1 = cellfun(@(x) sum(x(:)), Output_feature_diff_val(:,8));
m2 = cellfun(@(x) sum(x(:)), Output_feature_diff_val(:,6));

% PLot feature distribution on 3T3 images
for i = [7,24]%1:nb_common_features
    A = Output_feature_diff_val{i,3}(:,1);
    figure, histogram(A,100)
    str_name = Output_feature_diff_val{i,1};
    if strcmp(str_name,'Circ'), str_name = 'Circularity'; end
    title(str_name)
    if strcmp(str_name,'Area'), str_name = 'Area [pixels]'; end
    xlabel(str_name)
    ylabel('Count')
end

% a = T1.Properties.VariableNames;
% k = find(~cellfun(@isempty,strfind(a, 'Extent')));

% A = feature_diff_val{9,3};
% figure, plot(A,'.')




