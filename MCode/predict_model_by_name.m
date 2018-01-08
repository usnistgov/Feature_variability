

function [predicted_Y, prob_Y] = predict_model_by_name(fit_model, X_test, name_opts_structure)
%% ensemble methods classification
if strcmpi(name_opts_structure.name,'AdaBoostM1') || strcmpi(name_opts_structure.name,'LogitBoost') || strcmpi(name_opts_structure.name,'GentleBoost') || ...
        strcmpi(name_opts_structure.name,'RobustBoost') || strcmpi(name_opts_structure.name,'LPBoost') || strcmpi(name_opts_structure.name,'RUSBoost') || ...
        (strcmpi(name_opts_structure.name,'Bag') && strcmpi(name_opts_structure.type, 'classification')) || strcmpi(name_opts_structure.name,'fitctree')
    [predicted_Y, prob_Y] = predict(fit_model,X_test);
    return
end

%% ensemble methods classification
if strcmpi(name_opts_structure.name,'svm')
    [predicted_Y, prob_Y] = predict(fit_model,X_test);
    return
end

%% ensemble methods regression
if strcmpi(name_opts_structure.name,'LSBoost') || strcmpi(name_opts_structure.name,'fitrtree') || (strcmpi(name_opts_structure.name,'Bag') && strcmpi(name_opts_structure.type, 'regression')) 
    predicted_Y = predict(fit_model,X_test);
    prob_Y = [predicted_Y -predicted_Y];
    return
end

%% Lasso
if strcmpi(name_opts_structure.name,'Lasso')
    predicted_Y = glmval(fit_model,X_test,'logit');
    prob_Y = [predicted_Y -predicted_Y];
    return
end

%% if fit is not ensemble erase nan values from feature matrix for all other fits
X_test(isnan(X_test)) = -22;

% if fit is multiple linear regression
if strcmpi(name_opts_structure.name,'Regress')
    predicted_Y = X_test*fit_model;
    prob_Y = [predicted_Y -predicted_Y];
    return
end

% if fit is linear regression models: 'constant'; 'linear'; 'interactions'; 'purequadratic'; 'quadratic'
predicted_Y = predict(fit_model,X_test);
prob_Y = [predicted_Y -predicted_Y];

