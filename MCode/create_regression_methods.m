

function methods_name_opts = create_regression_methods

m = 1; % Method counter

%% LSBoost Options
methods_name_opts_struc = [];
methods_name_opts_struc.name = 'LSBoost';
methods_name_opts_struc.NTree = 222;
methods_name_opts_struc.templateTree = templateTree('MaxNumSplits',22);
methods_name_opts_struc.LearnRate = 0.1;
methods_name_opts_struc.CategoricalPredictors = [];
methods_name_opts{m} = methods_name_opts_struc;
m = m+1;

%% Bag Options
methods_name_opts_struc = [];
methods_name_opts_struc.name = 'Bag';
methods_name_opts_struc.NTree = 222;
methods_name_opts_struc.templateTree = 'tree';
methods_name_opts_struc.type = 'regression';
methods_name_opts_struc.CategoricalPredictors = [];
methods_name_opts{m} = methods_name_opts_struc;
m = m+1;

%% Regress Options
methods_name_opts_struc = [];
methods_name_opts_struc.name = 'fitrtree';
methods_name_opts_struc.MinParentSize = 22;
methods_name_opts{m} = methods_name_opts_struc;
m = m+1;

%% linear regression models {'linear'; 'interactions'; 'purequadratic'; 'quadratic'}; 
% linear_name = {'linear'};
% RobustOpts_names = {'off'; 'andrews'; 'bisquare'; 'cauchy'; 'fair'; 'huber'; 'logistic'; 'ols'; 'talwar'; 'welsch'};
% methods_name_opts_struc = [];
% for i = 1:length(linear_name)
%     methods_name_opts_struc.name = linear_name{i};
%     nb_options = length(RobustOpts_names);
%     if strcmp(linear_name{i}, 'interactions') || strcmp(linear_name{i}, 'quadratic'), nb_options = 1; end
%     for j = 1:nb_options
%         methods_name_opts_struc.RobustOpts = RobustOpts_names{j};
%         methods_name_opts_struc.CategoricalPredictors = [];
%         methods_name_opts{m} = methods_name_opts_struc;
%         m = m+1;
%     end
% end

%% Make sure output is one column
methods_name_opts = methods_name_opts(:);



