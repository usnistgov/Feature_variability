

path_to_output = 'C:\Users\cardone\Desktop\Feature_variability_code\Feature_variab_11-20_output\csv-files\';

f = dir([path_to_output '*.csv']);

% Read first table
T = table;

for i = 1:length(f)
    % Read table
    T(i,:) = readtable([path_to_output f(i).name]);
end
% Add image name to table
T = [cell2table({f.name}','VariableNames',{'image_ID'}), T];

save T T