
% Run the Feature_Variability_Analysis function
Feature_Variability_Analysis

%  PERIMETER
% Get perimeter value
% A = Output_feature_diff_val{8,3}(:,1:3); % Do not take Matlab or cellprofiler value into account
A = Output_feature_diff_val{8,3}(:,[1:3 5]); % Do not take Matlab but include cellprofiler value into account
% A = A - repmat(mean(A,2),1,3); % Without cellprofiler. This line goes with line 7
A = A - repmat(mean(A,2),1,4); % With cell profiler. This line goes with line 8

var_names = {'CellProfiler','ImageJ', 'Java', 'Python'};
TT = array2table(A,'VariableNames',var_names);
TT = [T(:,1) TT];
writetable(TT,'perimeter_plot_diff_data.csv')

% Plot error with regards to Radius value
h = figure;
plot(A(:,1),'gx','LineWidth',2,'Markersize',8)
hold on
plot(A(:,2),'ro','LineWidth',2,'Markersize',8)
plot(A(:,3),'md','LineWidth',2,'Markersize',8)
plot(A(:,4),'^','LineWidth',2,'Markersize',8) % This line goes with line 8
h.Children.FontSize = 30;
% legend({'Python','ImageJ', 'Java'},'FontSize',30) % This line goes with line 7
legend(var_names,'FontSize',30) % This line goes with line 8

% Mean Intensity
% Get perimeter value
% A = Output_feature_diff_val{8,3}(:,1:3); % Do not take Matlab or cellprofiler value into account
A = Output_feature_diff_val{24,3}(:,[1:3 5 6]); % Do not take Matlab but include cellprofiler value into account
% A = A - repmat(mean(A,2),1,3); % Without cellprofiler. This line goes with line 7
A = A - repmat(mean(A,2),1,5); % With cell profiler. This line goes with line 8

var_names = {'CellProfiler','ImageJ', 'Java', 'MaZda','Python'};
TT = array2table(A,'VariableNames',var_names);
TT = [T(:,1) TT];
writetable(TT,'mean_intensity_plot_diff_data.csv')

% Plot error with regards to Radius value
h = figure;
plot(A(:,1),'gx','LineWidth',2,'Markersize',8)
hold on
plot(A(:,2),'ro','LineWidth',2,'Markersize',8)
plot(A(:,3),'md','LineWidth',2,'Markersize',8)
plot(A(:,4),'<k','LineWidth',2,'Markersize',8) % This line goes with line 8
plot(A(:,5),'^','LineWidth',2,'Markersize',8) % This line goes with line 8
h.Children.FontSize = 30;
% legend({'Python','ImageJ', 'Java'},'FontSize',30) % This line goes with line 7
legend(var_names,'FontSize',30) % This line goes with line 8





% TEXTURE CONTRAST
% Get perimeter value
% A = Output_feature_diff_val{8,3}(:,1:3); % Do not take Matlab or cellprofiler value into account
A = Output_feature_diff_val{28,3}(:,[1 3 4]); % Do not take Matlab but include cellprofiler value into account
% A = A - repmat(mean(A,2),1,3); % Without cellprofiler. This line goes with line 7
A = A - repmat(mean(A,2),1,3); % With cell profiler. This line goes with line 8

var_names = {'CellProfiler','MaZda', 'Python'};
TT = array2table(A,'VariableNames',var_names);
TT = [T(:,1) TT];
writetable(TT,'texture_contrast_0_plot_diff_data.csv')

% Plot error with regards to Radius value
h = figure;
plot(A(:,1),'gx','LineWidth',2,'Markersize',8)
hold on
plot(A(:,2),'<k','LineWidth',2,'Markersize',8)
plot(A(:,3),'^','LineWidth',2,'Markersize',8)
h.Children.FontSize = 30;
% legend({'Python','ImageJ', 'Java'},'FontSize',30) % This line goes with line 7
legend(var_names,'FontSize',30) % This line goes with line 8

