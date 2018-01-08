

% max_numTrees = 250 and name_similarity_metric = 'AUC';
function methods_name_opts = kfold_parameter_optimization(X,Y,k,methods_name_opts,name_similarity_metric,max_numTrees)

% Define constants
nb_observations = size(X,1);
nb_methods = length(methods_name_opts);

% Create kfold or Holdout split vector
cvp = cvpartition(nb_observations, 'kfold', k);

% Optimize parameters per method
for m = 1:nb_methods
    % For Classification. Only Bag is for both regression and classification
    if strcmpi(methods_name_opts{m}.name,'AdaBoostM1'), methods_name_opts{m} = kfold_parameter_optimization_AdaBoostM1(X,Y,k,cvp,methods_name_opts{m},max_numTrees,name_similarity_metric); end
    if strcmpi(methods_name_opts{m}.name,'LogitBoost'), methods_name_opts{m} = kfold_parameter_optimization_LogitBoost(X,Y,k,cvp,methods_name_opts{m},max_numTrees,name_similarity_metric); end
    if strcmpi(methods_name_opts{m}.name,'GentleBoost'), methods_name_opts{m} = kfold_parameter_optimization_GentleBoost(X,Y,k,cvp,methods_name_opts{m},max_numTrees,name_similarity_metric); end
    if strcmpi(methods_name_opts{m}.name,'RobustBoost'), methods_name_opts{m} = kfold_parameter_optimization_RobustBoost(X,Y,k,cvp,methods_name_opts{m},max_numTrees,name_similarity_metric); end
    if strcmpi(methods_name_opts{m}.name,'RUSBoost'), methods_name_opts{m} = kfold_parameter_optimization_RUSBoost(X,Y,k,cvp,methods_name_opts{m},max_numTrees,name_similarity_metric); end
    if strcmpi(methods_name_opts{m}.name,'Bag'), methods_name_opts{m} = kfold_parameter_optimization_Bag_classification(X,Y,k,cvp,methods_name_opts{m},max_numTrees,name_similarity_metric); end
    if strcmpi(methods_name_opts{m}.name,'fitctree'), methods_name_opts{m} = kfold_parameter_optimization_fitctree(X,Y,k,cvp,methods_name_opts{m},name_similarity_metric); end
    if strcmpi(methods_name_opts{m}.name,'Lasso'), methods_name_opts{m} = kfold_parameter_optimization_Lasso(X,Y,k,cvp,methods_name_opts{m},name_similarity_metric); end
    
    % For Regression
    if strcmpi(methods_name_opts{m}.name,'LSBoost'), methods_name_opts{m} = kfold_parameter_optimization_LSBoost(X,Y,k,cvp,methods_name_opts{m},max_numTrees,name_similarity_metric); end
    if strcmpi(methods_name_opts{m}.name,'fitrtree'), methods_name_opts{m} = kfold_parameter_optimization_fitrtree(X,Y,k,cvp,methods_name_opts{m},name_similarity_metric); end
end

end



%% % % % % % % % % %     AdaBoostM1    % % % % % % % % % %
function single_method_name_opts = kfold_parameter_optimization_AdaBoostM1(X,Y,k,cvp,single_method_name_opts,max_numTrees,name_similarity_metric)

% AdaBoostM1 parameters
train_size = round(size(X,1)-1/k*size(X,1));
learn_rate = [0.1 0.25 0.5 1]; % learn rate
a = floor(log2(train_size - 1));
maxNumSplits = 2.^(0:a);
numTrees = [10 25 50:50:max_numTrees];

% Optimize parameters
nb_lr = length(learn_rate);
nb_maxNumSplits = length(maxNumSplits);
nb_numTrees = length(numTrees);
method_accuracy = nan(nb_numTrees,nb_maxNumSplits,nb_lr);
for c = 1:nb_lr
    single_method_name_opts.LearnRate = learn_rate(c);
    for b = 1:nb_maxNumSplits
        single_method_name_opts.templateTree = templateTree('MaxNumSplits',maxNumSplits(b));
        for a = 1:nb_numTrees
            single_method_name_opts.NTree = numTrees(a);
            A = compute_k_fold_accuracy(X,Y,cvp,k,single_method_name_opts,name_similarity_metric);
            method_accuracy(a,b,c) = mean(A);
            display(['AdaBoostM1: nTrees = ' num2str(numTrees(a)) ', maxSplits = ' num2str(maxNumSplits(b)) ', lr = ' num2str(learn_rate(c)) ' accuracy = ' num2str(method_accuracy(a,b,c))])
        end
    end
end

% Get optimal parameters
[aa,ind] = min(method_accuracy(:));
[a,b,c] = ind2sub(size(method_accuracy),ind);
display(['AdaBoostM1 optimal results: nTrees = ' num2str(numTrees(a)) ', maxSplits = ' num2str(maxNumSplits(b)) ', lr = ' num2str(learn_rate(c)) ' accuracy = ' num2str(aa)])
single_method_name_opts.NTree = numTrees(a);
single_method_name_opts.templateTree = templateTree('MaxNumSplits',maxNumSplits(b));
single_method_name_opts.LearnRate = learn_rate(c);
end



%% % % % % % % % % %     LogitBoost    % % % % % % % % % %
function single_method_name_opts = kfold_parameter_optimization_LogitBoost(X,Y,k,cvp,single_method_name_opts,max_numTrees,name_similarity_metric)

% LogitBoost parameters
train_size = round(size(X,1)-1/k*size(X,1));
learn_rate = [0.1 0.25 0.5 1]; % learn rate
a = floor(log2(train_size - 1));
maxNumSplits = 2.^(0:a);
numTrees = [10 25 50:50:max_numTrees];

% Optimize parameters
nb_lr = length(learn_rate);
nb_maxNumSplits = length(maxNumSplits);
nb_numTrees = length(numTrees);
method_accuracy = nan(nb_numTrees,nb_maxNumSplits,nb_lr);
for c = 1:nb_lr
    single_method_name_opts.LearnRate = learn_rate(c);
    for b = 1:nb_maxNumSplits
        single_method_name_opts.templateTree = templateTree('MaxNumSplits',maxNumSplits(b));
        for a = 1:nb_numTrees
            single_method_name_opts.NTree = numTrees(a);
            A = compute_k_fold_accuracy(X,Y,cvp,k,single_method_name_opts,name_similarity_metric);
            method_accuracy(a,b,c) = mean(A);
            display(['LogitBoost: nTrees = ' num2str(numTrees(a)) ', maxSplits = ' num2str(maxNumSplits(b)) ', lr = ' num2str(learn_rate(c)) ' accuracy = ' num2str(method_accuracy(a,b,c))])
        end
    end
end

% Get optimal parameters
[aa,ind] = min(method_accuracy(:));
[a,b,c] = ind2sub(size(method_accuracy),ind);
display(['LogitBoost optimal results: nTrees = ' num2str(numTrees(a)) ', maxSplits = ' num2str(maxNumSplits(b)) ', lr = ' num2str(learn_rate(c)) ' accuracy = ' num2str(aa)])
single_method_name_opts.NTree = numTrees(a);
single_method_name_opts.templateTree = templateTree('MaxNumSplits',maxNumSplits(b));
single_method_name_opts.LearnRate = learn_rate(c);
end



%% % % % % % % % % %     GentleBoost    % % % % % % % % % %
function single_method_name_opts = kfold_parameter_optimization_GentleBoost(X,Y,k,cvp,single_method_name_opts,max_numTrees,name_similarity_metric)

% GentleBoost parameters
train_size = round(size(X,1)-1/k*size(X,1));
learn_rate = [0.1 0.25 0.5 1]; % learn rate
a = floor(log2(train_size - 1));
maxNumSplits = 2.^(0:a);
numTrees = [10 25 50:50:max_numTrees];

% Optimize parameters
nb_lr = length(learn_rate);
nb_maxNumSplits = length(maxNumSplits);
nb_numTrees = length(numTrees);
method_accuracy = nan(nb_numTrees,nb_maxNumSplits,nb_lr);
for c = 1:nb_lr
    single_method_name_opts.LearnRate = learn_rate(c);
    for b = 1:nb_maxNumSplits
        single_method_name_opts.templateTree = templateTree('MaxNumSplits',maxNumSplits(b));
        for a = 1:nb_numTrees
            single_method_name_opts.NTree = numTrees(a);
            A = compute_k_fold_accuracy(X,Y,cvp,k,single_method_name_opts,name_similarity_metric);
            method_accuracy(a,b,c) = mean(A);
            display(['GentleBoost: nTrees = ' num2str(numTrees(a)) ', maxSplits = ' num2str(maxNumSplits(b)) ', lr = ' num2str(learn_rate(c)) ' accuracy = ' num2str(method_accuracy(a,b,c))])
        end
    end
end

% Get optimal parameters
[aa,ind] = min(method_accuracy(:));
[a,b,c] = ind2sub(size(method_accuracy),ind);
display(['GentleBoost optimal results: nTrees = ' num2str(numTrees(a)) ', maxSplits = ' num2str(maxNumSplits(b)) ', lr = ' num2str(learn_rate(c)) ' accuracy = ' num2str(aa)])
single_method_name_opts.NTree = numTrees(a);
single_method_name_opts.templateTree = templateTree('MaxNumSplits',maxNumSplits(b));
single_method_name_opts.LearnRate = learn_rate(c);
end



%% % % % % % % % % %     RobustBoost    % % % % % % % % % %
function single_method_name_opts = kfold_parameter_optimization_RobustBoost(X,Y,k,cvp,single_method_name_opts,max_numTrees,name_similarity_metric)

% RobustBoost parameters
a = floor(log2(size(X,1) - 1));
maxNumSplits = 2.^(0:a);
numTrees = [10 25 50:50:max_numTrees];

% Optimize parameters
nb_maxNumSplits = length(maxNumSplits);
nb_numTrees = length(numTrees);
method_accuracy = nan(nb_numTrees,nb_maxNumSplits);
for b = 1:nb_maxNumSplits
    single_method_name_opts.templateTree = templateTree('MaxNumSplits',maxNumSplits(b));
    for a = 1:nb_numTrees
        single_method_name_opts.NTree = numTrees(a);
        A = compute_k_fold_accuracy(X,Y,cvp,k,single_method_name_opts,name_similarity_metric);
        method_accuracy(a,b) = mean(A);
        display(['RobustBoost: nTrees = ' num2str(numTrees(a)) ', maxSplits = ' num2str(maxNumSplits(b)) ' accuracy = ' num2str(method_accuracy(a,b))])
    end
end


% Get optimal parameters
[aa,ind] = min(method_accuracy(:));
[a,b] = ind2sub(size(method_accuracy),ind);
display(['RobustBoost optimal results: nTrees = ' num2str(numTrees(a)) ', maxSplits = ' num2str(maxNumSplits(b)) ' accuracy = ' num2str(aa)])
single_method_name_opts.NTree = numTrees(a);
single_method_name_opts.templateTree = templateTree('MaxNumSplits',maxNumSplits(b));
end


%% % % % % % % % % %     RUSBoost    % % % % % % % % % %
function single_method_name_opts = kfold_parameter_optimization_RUSBoost(X,Y,k,cvp,single_method_name_opts,max_numTrees,name_similarity_metric)

% RUSBoost parameters
train_size = round(size(X,1)-1/k*size(X,1));
learn_rate = [0.1 0.25 0.5 1]; % learn rate
a = floor(log2(train_size - 1));
maxNumSplits = 2.^(0:a);
numTrees = [10 25 50:50:max_numTrees];

% Optimize parameters
nb_lr = length(learn_rate);
nb_maxNumSplits = length(maxNumSplits);
nb_numTrees = length(numTrees);
method_accuracy = nan(nb_numTrees,nb_maxNumSplits,nb_lr);
for c = 1:nb_lr
    single_method_name_opts.LearnRate = learn_rate(c);
    for b = 1:nb_maxNumSplits
        single_method_name_opts.templateTree = templateTree('MaxNumSplits',maxNumSplits(b));
        for a = 1:nb_numTrees
            single_method_name_opts.NTree = numTrees(a);
            A = compute_k_fold_accuracy(X,Y,cvp,k,single_method_name_opts,name_similarity_metric);
            method_accuracy(a,b,c) = mean(A);
            display(['RUSBoost: nTrees = ' num2str(numTrees(a)) ', maxSplits = ' num2str(maxNumSplits(b)) ', lr = ' num2str(learn_rate(c)) ' accuracy = ' num2str(method_accuracy(a,b,c))])
        end
    end
end

% Get optimal parameters
[aa,ind] = min(method_accuracy(:));
[a,b,c] = ind2sub(size(method_accuracy),ind);
display(['RUSBoost optimal results: nTrees = ' num2str(numTrees(a)) ', maxSplits = ' num2str(maxNumSplits(b)) ', lr = ' num2str(learn_rate(c)) ' accuracy = ' num2str(aa)])
single_method_name_opts.NTree = numTrees(a);
single_method_name_opts.templateTree = templateTree('MaxNumSplits',maxNumSplits(b));
single_method_name_opts.LearnRate = learn_rate(c);
end



%% % % % % % % % % %     Bag Classification   % % % % % % % % % %
function single_method_name_opts = kfold_parameter_optimization_Bag_classification(X,Y,k,cvp,single_method_name_opts,max_numTrees,name_similarity_metric)

% Bag parameters
numTrees = [10 25 50:50:max_numTrees];

% Optimize parameters
nb_numTrees = length(numTrees);
method_accuracy = nan(nb_numTrees,1);

for a = 1:nb_numTrees
    single_method_name_opts.NTree = numTrees(a);
    A = compute_k_fold_accuracy(X,Y,cvp,k,single_method_name_opts,name_similarity_metric);
    method_accuracy(a) = mean(A);
    display(['Bag: nTrees = ' num2str(numTrees(a)) ' accuracy = ' num2str(method_accuracy(a))])
end


% Get optimal parameters
[aa,ind] = min(method_accuracy(:));
display(['Bag optimal results: nTrees = ' num2str(numTrees(ind)) ' accuracy = ' num2str(aa)])
single_method_name_opts.NTree = numTrees(ind);
end


%% % % % % % % % % %     fitctree Classification   % % % % % % % % % %
function single_method_name_opts = kfold_parameter_optimization_fitctree(X,Y,k,cvp,single_method_name_opts,name_similarity_metric)

% Bag parameters
MinParentSize = 5:5:50;

% Optimize parameters
nb_MinParentSize = length(MinParentSize);
method_accuracy = nan(nb_MinParentSize,1);

for a = 1:nb_MinParentSize
    single_method_name_opts.MinParentSize = MinParentSize(a);
    A = compute_k_fold_accuracy(X,Y,cvp,k,single_method_name_opts,name_similarity_metric);
    method_accuracy(a) = mean(A);
    display(['fitctree: MinParentSize = ' num2str(MinParentSize(a)) ' accuracy = ' num2str(method_accuracy(a))])
end


% Get optimal parameters
[aa,ind] = min(method_accuracy(:));
display(['fitctree optimal results: MinParentSize = ' num2str(MinParentSize(ind)) ' accuracy = ' num2str(aa)])
single_method_name_opts.MinParentSize = MinParentSize(ind);
end



%% % % % % % % % % %     Lasso Classification   % % % % % % % % % %
function single_method_name_opts = kfold_parameter_optimization_Lasso(X,Y,k,cvp,single_method_name_opts,name_similarity_metric)

% Bag parameters
distr_val = {'normal'; 'binomial'; 'poisson'; 'gamma'; 'inverse gaussian'};
% link_val = {'comploglog'; 'identity'; 'log'; 'logit'; 'loglog'; 'probit'; 'reciprocal'; -2};
Lambda_val = 100:300;
tol_val = 10.^(-6:-3);

% Optimize parameters
nb_distr = length(distr_val);
% nb_link = length(link_val);
nb_Lambda = length(Lambda_val);
nb_tol = length(tol_val);
% method_accuracy = nan(nb_distr,nb_link,nb_Lambda,nb_tol);
method_accuracy = nan(nb_distr,nb_Lambda,nb_tol);

for a = 1:nb_distr
    single_method_name_opts.distr = distr_val{a};
    %     for b = 1:nb_link
    %         single_method_name_opts.Link = link_val{b};
    for c = 1:nb_Lambda
        single_method_name_opts.NumLambda = Lambda_val(c);
        for d = 1:nb_tol
            single_method_name_opts.RelTol = tol_val(d);
            A = compute_k_fold_accuracy(X,Y,cvp,k,single_method_name_opts,name_similarity_metric);
            method_accuracy(a,c,d) = mean(A);
            %display(['Lasso: distr = ' distr_val{a} ',link = ' link_val{b} ', NumLambda = ' num2str(Lambda_val(c)) ', Tol = ' num2str(tol_val(d)) ' accuracy = ' num2str(method_accuracy(a))])
            display(['Lasso: distr = ' distr_val{a} ', NumLambda = ' num2str(Lambda_val(c)) ', Tol = ' num2str(tol_val(d)) ' accuracy = ' num2str(method_accuracy(a))])
        end
    end
    %     end
end

% Get optimal parameters
[aa,ind] = min(method_accuracy(:));
[a,c,d] = ind2sub(size(method_accuracy),ind);
display(['Lasso optimal results: distr = ' distr_val{a} ', NumLambda = ' num2str(Lambda_val(c)) ', Tol = ' num2str(tol_val(d)) ' accuracy = ' num2str(aa)])
end



%% % % % % % % % % %     LSBoost    % % % % % % % % % %
function single_method_name_opts = kfold_parameter_optimization_LSBoost(X,Y,k,cvp,single_method_name_opts,max_numTrees,name_similarity_metric)

% LSBoost parameters
train_size = round(size(X,1)-1/k*size(X,1));
learn_rate = [0.1 0.25 0.5 1]; % learn rate
a = floor(log2(train_size - 1));
maxNumSplits = 2.^(0:a);
numTrees = [10 25 50:50:max_numTrees];

% Optimize parameters
nb_lr = length(learn_rate);
nb_maxNumSplits = length(maxNumSplits);
nb_numTrees = length(numTrees);
method_accuracy = nan(nb_numTrees,nb_maxNumSplits,nb_lr);
for c = 1:nb_lr
    single_method_name_opts.LearnRate = learn_rate(c);
    for b = 1:nb_maxNumSplits
        single_method_name_opts.templateTree = templateTree('MaxNumSplits',maxNumSplits(b));
        for a = 1:nb_numTrees
            single_method_name_opts.NTree = numTrees(a);
            A = compute_k_fold_accuracy(X,Y,cvp,k,single_method_name_opts,name_similarity_metric);
            method_accuracy(a,b,c) = mean(A);
            display(['LSBoost: nTrees = ' num2str(numTrees(a)) ', maxSplits = ' num2str(maxNumSplits(b)) ', lr = ' num2str(learn_rate(c)) ' accuracy = ' num2str(method_accuracy(a,b,c))])
        end
    end
end

% Get optimal parameters
[aa,ind] = min(method_accuracy(:));
[a,b,c] = ind2sub(size(method_accuracy),ind);
display(['LSBoost optimal results: nTrees = ' num2str(numTrees(a)) ', maxSplits = ' num2str(maxNumSplits(b)) ', lr = ' num2str(learn_rate(c)) ' accuracy = ' num2str(aa)])
single_method_name_opts.NTree = numTrees(a);
single_method_name_opts.templateTree = templateTree('MaxNumSplits',maxNumSplits(b));
single_method_name_opts.LearnRate = learn_rate(c);
end



%% % % % % % % % % %     fitrtree Classification   % % % % % % % % % %
function single_method_name_opts = kfold_parameter_optimization_fitrtree(X,Y,k,cvp,single_method_name_opts,name_similarity_metric)

% Bag parameters
MinParentSize = 5:5:50;

% Optimize parameters
nb_MinParentSize = length(MinParentSize);
method_accuracy = nan(nb_MinParentSize,1);

for a = 1:nb_MinParentSize
    single_method_name_opts.MinParentSize = MinParentSize(a);
    A = compute_k_fold_accuracy(X,Y,cvp,k,single_method_name_opts,name_similarity_metric);
    method_accuracy(a) = mean(A);
    display(['fitrtree: MinParentSize = ' num2str(MinParentSize(a)) ' accuracy = ' num2str(method_accuracy(a))])
end


% Get optimal parameters
[aa,ind] = min(method_accuracy(:));
display(['fitrtree optimal results: MinParentSize = ' num2str(MinParentSize(ind)) ' accuracy = ' num2str(aa)])
single_method_name_opts.MinParentSize = MinParentSize(ind);
end



