

function fit_model = fit_model_by_name(X_train, Y_train, classifier_opts_structure)
%% Boosting methods
if strcmpi(classifier_opts_structure.name,'LSBoost') || strcmpi(classifier_opts_structure.name,'AdaBoostM1') || ...
        strcmpi(classifier_opts_structure.name,'LogitBoost') || strcmpi(classifier_opts_structure.name,'GentleBoost') || ...
        strcmpi(classifier_opts_structure.name,'RUSBoost')
    fit_model = fitensemble(X_train,Y_train,classifier_opts_structure.name,classifier_opts_structure.NTree,classifier_opts_structure.templateTree,...
        'LearnRate',classifier_opts_structure.LearnRate,'CategoricalPredictors',classifier_opts_structure.CategoricalPredictors);
    return,
end

%% Boosting methods without Learn rate parameter
if strcmpi(classifier_opts_structure.name,'RobustBoost') || strcmpi(classifier_opts_structure.name,'LPBoost')
    fit_model = fitensemble(X_train,Y_train,classifier_opts_structure.name,classifier_opts_structure.NTree,classifier_opts_structure.templateTree,...
        'CategoricalPredictors',classifier_opts_structure.CategoricalPredictors);
    return,
end

%% Bag
if strcmpi(classifier_opts_structure.name,'Bag')
    fit_model = fitensemble(X_train,Y_train,'Bag',classifier_opts_structure.NTree,classifier_opts_structure.templateTree,...
        'type',classifier_opts_structure.type,'CategoricalPredictors',classifier_opts_structure.CategoricalPredictors);
    return,
end

%% Lasso: elastic net regularization for generalized linear model regression
if strcmpi(classifier_opts_structure.name,'Lasso')
    [B,FitInfo] = lassoglm(X_train,Y_train,classifier_opts_structure.distr,'Alpha', classifier_opts_structure.alpha, ...
        'CV',classifier_opts_structure.cv, 'NumLambda', classifier_opts_structure.NumLambda, ...
        'Options',classifier_opts_structure.Options, 'RelTol',classifier_opts_structure.RelTol);
    indx = FitInfo.IndexMinDeviance;
    B0 = B(:,indx);
    cnst = FitInfo.Intercept(indx);
    fit_model = [cnst;B0];
    return,
end

%% Bag
if strcmpi(classifier_opts_structure.name,'svm')
    fit_model = fitcsvm(X_train,Y_train);
    return,
end

%% Regression tree
if strcmpi(classifier_opts_structure.name,'fitrtree')
    fit_model = fitrtree(X_train,Y_train,'MinParentSize',classifier_opts_structure.MinParentSize);
    return,
end

%% Classification tree
if strcmpi(classifier_opts_structure.name,'fitctree')
    fit_model = fitctree(X_train,Y_train,'MinParentSize',classifier_opts_structure.MinParentSize, 'SplitCriterion', classifier_opts_structure.SplitCriterion);
    return,
end

%% if fit is not ensemble erase nan values from feature matrix for all other fits
X_train(isnan(X_train)) = -22;

% Linear regression
% if fit is multiple linear regression
if strcmpi(classifier_opts_structure.name,'Regress')
    fit_model = regress(Y_train,X_train);
    return,
end

% if fit is linear regression models: 'constant'; 'linear'; 'interactions'; 'purequadratic'; 'quadratic'
fit_model = fitlm(X_train,Y_train, classifier_opts_structure.name, 'RobustOpts', classifier_opts_structure.RobustOpts, ...
    'CategoricalVars', classifier_opts_structure.CategoricalPredictors);

