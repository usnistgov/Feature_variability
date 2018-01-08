
% compute_k_fold_accuracy
function [A,predicted_Y] = compute_k_fold_accuracy(X,Y,cvp,k,single_method_name_opts,name_similarity_metric)

A = nan(k,1);
predicted_Y = cell(k,1);
for i = 1:k
    warning off 
    % Split into learning and testing
    X_train = X(cvp.training(i),:);
    Y_train = Y(cvp.training(i));
    X_test = X(cvp.test(i),:);
    Y_test = Y(cvp.test(i));
    
    % Train and predict with corresponding classifier
    fit_model = fit_model_by_name(X_train, Y_train, single_method_name_opts);
    [predicted_Y{i}, prob_Y] = predict_model_by_name(fit_model, X_test, single_method_name_opts);
    
    % Compute accuracy of prediction per set of parameters
    A(i) = similarity_metric(Y_test, prob_Y(:,2), name_similarity_metric);
    warning on
end
end