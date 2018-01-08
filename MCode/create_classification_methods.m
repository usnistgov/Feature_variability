

function methods_name_opts = create_classification_methods

m = 1; % Method counter


%% AdaBoostM1 Options
% methods_name_opts_struc = [];
% methods_name_opts_struc.name = 'AdaBoostM1';
% methods_name_opts_struc.NTree = 222;
% methods_name_opts_struc.templateTree = templateTree('MaxNumSplits',22);
% methods_name_opts_struc.LearnRate = 0.1;
% methods_name_opts_struc.CategoricalPredictors = [];
% methods_name_opts{m} = methods_name_opts_struc;
% m = m+1;


%% LogitBoost Options
% methods_name_opts_struc = [];
% methods_name_opts_struc.name = 'LogitBoost';
% methods_name_opts_struc.NTree = 222;
% methods_name_opts_struc.templateTree = templateTree('MaxNumSplits',22);
% methods_name_opts_struc.LearnRate = 0.1;
% methods_name_opts_struc.CategoricalPredictors = [];
% methods_name_opts{m} = methods_name_opts_struc;
% m = m+1;


%% GentleBoost Options
% methods_name_opts_struc = [];
% methods_name_opts_struc.name = 'GentleBoost';
% methods_name_opts_struc.NTree = 222;
% methods_name_opts_struc.templateTree = templateTree('MaxNumSplits',22);
% methods_name_opts_struc.LearnRate = 0.1;
% methods_name_opts_struc.CategoricalPredictors = [];
% methods_name_opts{m} = methods_name_opts_struc;
% m = m+1;


%% RobustBoost Options
% methods_name_opts_struc = [];
% methods_name_opts_struc.name = 'RobustBoost';
% methods_name_opts_struc.NTree = 222;
% methods_name_opts_struc.templateTree = templateTree('MaxNumSplits',22);
% methods_name_opts_struc.CategoricalPredictors = [];
% methods_name_opts{m} = methods_name_opts_struc;
% m = m+1;


% % RUSBoost Options
% methods_name_opts_struc = [];
% methods_name_opts_struc.name = 'RUSBoost';
% methods_name_opts_struc.NTree = 22;
% methods_name_opts_struc.templateTree = templateTree('MaxNumSplits',22);
% methods_name_opts_struc.LearnRate = 0.1;
% methods_name_opts_struc.CategoricalPredictors = [];
% methods_name_opts{m} = methods_name_opts_struc;
% m = m+1;
% 
% 
% % Bag Options
% methods_name_opts_struc = [];
% methods_name_opts_struc.name = 'Bag';
% methods_name_opts_struc.NTree = 22;
% methods_name_opts_struc.templateTree = 'tree';
% methods_name_opts_struc.type = 'classification';
% methods_name_opts_struc.CategoricalPredictors = [];
% methods_name_opts{m} = methods_name_opts_struc;
% m = m+1;


%% Fast classification Options
methods_name_opts_struc = [];
methods_name_opts_struc.name = 'fitctree';
methods_name_opts_struc.MinParentSize = 22;
methods_name_opts_struc.SplitCriterion = 'gdi';
methods_name_opts{m} = methods_name_opts_struc;
m = m+1;

methods_name_opts_struc = [];
methods_name_opts_struc.name = 'fitctree';
methods_name_opts_struc.MinParentSize = 22;
methods_name_opts_struc.SplitCriterion = 'twoing';
methods_name_opts{m} = methods_name_opts_struc;
m = m+1;

methods_name_opts_struc = [];
methods_name_opts_struc.name = 'fitctree';
methods_name_opts_struc.MinParentSize = 22;
methods_name_opts_struc.SplitCriterion = 'deviance';
methods_name_opts{m} = methods_name_opts_struc;
m = m+1;


%% Lasso: elastic net regularization for generalized linear model regression
% methods_name_opts_struc = [];
% methods_name_opts_struc.name = 'Lasso';
% methods_name_opts_struc.distr = 'binomial';
% methods_name_opts_struc.alpha = 1;
% methods_name_opts_struc.cv = 5;
% %methods_name_opts_struc.Link = 'identity';
% methods_name_opts_struc.NumLambda = 100;
% methods_name_opts_struc.Options = statset('UseParallel',true);
% methods_name_opts_struc.RelTol = 1e-4;
% methods_name_opts{m} = methods_name_opts_struc;
% m = m+1;

% %% SVM
% methods_name_opts_struc = [];
% methods_name_opts_struc.name = 'svm';
% methods_name_opts{m} = methods_name_opts_struc;
% m = m+1;

%% Make sure output is one column
methods_name_opts = methods_name_opts(:);



