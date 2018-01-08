
% Computes a similarity metric based on given labels and predicted values
% For Area Under the Curve metric, similarity_name = 'AUC'
% For Root Mean Square Percentage Error, similarity_name = 'RMSPE'

function accuracy = similarity_metric(Observed_Y, predicted_Y, similarity_name)

% if selected similarity is the Area Under the Curve metric
if strcmp(similarity_name, 'AUC')
    [~,~,~,AUC] = perfcurve(Observed_Y,predicted_Y,true);
%     figure
%     plot(X,Y)
%     xlabel('False positive rate')
%     ylabel('True positive rate')
    accuracy = AUC;
end

% if selected similarity is the Root Mean Square Percentage Error (RMSPE)
if strcmp(similarity_name, 'RMSPE')
    ind_nz = Observed_Y>0;
    accuracy = sqrt(mean(((Observed_Y(ind_nz) - predicted_Y(ind_nz))./Observed_Y(ind_nz)).^2));
end


