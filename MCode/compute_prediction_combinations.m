

% This function computes the combination statistics of all possile combinations between k methods
function [predicted_Y,IND] = compute_prediction_combinations(predicted_Y1,C,nb_methods)

% Get the number of methods and corresponding combinations
[nb_observations, nb_methods1] = size(predicted_Y1);

% Compute combinations of predictions
predicted_Y = zeros(nb_observations,nb_methods);
IND = cell(1,nb_methods);
P = zeros(nb_observations,4); % mean, median, min, and max

% Initialize output
m = nb_methods1;
predicted_Y(:,1:m) = predicted_Y1;
for i = 1:m, IND{i}{1} = 'none'; IND{i}{2} = m; end

% Statistics for all methods
m = m+1;
P(:,1) = mean(predicted_Y1,2);
IND{m}{1} = 'mean'; IND{m}{2} = 1:nb_methods1;
P(:,2) = median(predicted_Y1,2);
IND{m+1}{1} = 'median'; IND{m+1}{2} = 1:nb_methods1;
P(:,3) = min(predicted_Y1,[],2);
IND{m+2}{1} = 'min'; IND{m+2}{2} = 1:nb_methods1;
P(:,4) = max(predicted_Y1,[],2);
IND{m+3}{1} = 'max'; IND{m+3}{2} = 1:nb_methods1;
predicted_Y(:,m:m+3) = P;

% Combinations statistics
for i = 1:length(C)
    cbn = size(C{i},1);
    for j = 1:cbn
        m = m+4;
        P(:,1) = mean(predicted_Y(:,C{i}(j,:)),2);
        IND{m}{1} = 'mean'; IND{m}{2} = C{i}(j,:);
        P(:,2) = median(predicted_Y(:,C{i}(j,:)),2);
        IND{m+1}{1} = 'median'; IND{m+1}{2} = C{i}(j,:);
        P(:,3) = min(predicted_Y(:,C{i}(j,:)),[],2);
        IND{m+2}{1} = 'min'; IND{m+2}{2} = C{i}(j,:);
        P(:,4) = max(predicted_Y(:,C{i}(j,:)),[],2);
        IND{m+3}{1} = 'max'; IND{m+3}{2} = C{i}(j,:);
        predicted_Y(:,m:m+3) = P;
    end
end



