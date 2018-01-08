
function [chosen_method, kfold_accuracy] = kfold_choose_best_fit_combinations(X,Y,k,methods_name_opts,ncbs,name_similarity_metric,selected_features)
tic
% Define constants
nb_observations = size(X,1);

% Get k permutations
P = zeros(nb_observations,k);
%P(:,1) = (1:nb_observations)';
for i = 1:k, P(:,i) = randperm(nb_observations); end

% Split input into train and test data
train_size = round(nb_observations - 0.1*nb_observations);

% Compute the number of methods and corresponding combinations
nb_methods1 = length(methods_name_opts);
nb_methods = nb_methods1 + 4;
C = cell(ncbs,1);
v = 1:nb_methods1;
for i = 2:ncbs, C{i-1} = nchoosek(v,i); nb_methods = nb_methods + 4*size(C{i-1},1); end

% Compute k-fold accuracy per method
kfold_accuracy = zeros(k,nb_methods);
predicted_Y1 = zeros(nb_observations-train_size,nb_methods1);
for i = 1:k
    display(['computing accuracies for iteration '  num2str(i)])
    X_train = X(P(1:train_size,i),:);
    X_test = X(P(1+train_size:end,i),:);
    Y_train = Y(P(1:train_size,i));
    Y_test = Y(P(1+train_size:end,i));
    
    parfor m = 1:nb_methods1
        warning off
        % Compute accuracy
        fit_model = fit_model_by_name(X_train(:,selected_features(:,m)), Y_train, methods_name_opts{m});
        predicted_Y1(:,m) = predict_model_by_name(fit_model, X_test(:,selected_features(:,m)), methods_name_opts{m});
    end
    % Compute all combinations of methods predictions
    predicted_Y = compute_prediction_combinations(predicted_Y1,ncbs);
    
    % Compute accuracies
    ind_nz = Y_test>0;
    Y_test = repmat(Y_test, 1, nb_methods);
    kfold_accuracy(i,:) = sqrt(mean(((Y_test(ind_nz,:) - predicted_Y(ind_nz,:))./Y_test(ind_nz,:)).^2));
end
kfold_accuracy = mean(kfold_accuracy);

% Get best method for prediction
[~,chosen_method] = min(kfold_accuracy);
toc

