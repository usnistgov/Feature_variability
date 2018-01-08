

T = readtable('Common_Features_v3.xlsx');
T1 = T;
a = T{:,2}; % get software names
b = cellfun(@(x)strcmp(x,'Java'),a) + cellfun(@(x)strcmp(x,'Matlab'),a); % get rows with Java and Matlab
T1(b>0,:) = [];

% Display the number of features per tool
display(['number of python features = ' num2str(sum(cellfun(@(x)strcmp(x,'Python'),a)))])
display(['number of ImageJ features = ' num2str(sum(cellfun(@(x)strcmp(x,'ImageJ'),a)))])
display(['number of CellProfiler features = ' num2str(sum(cellfun(@(x)strcmp(x,'CellProfiler'),a)))])
display(['number of MaZda features = ' num2str(sum(cellfun(@(x)strcmp(x,'MaZda'),a)))])

% Display the number of features per class
c =  T1{:,3}; % get class names
shape_feat = cellfun(@(x)strcmp(x,'shape'),c); % Get shape feature rows
intensity_feat = cellfun(@(x)strcmp(x,'Intensity'),c); % Get intensity feature rows
texture_feat = cellfun(@(x)strcmp(x,'texture'),c); % Get texture feature rows
display(['number of shape features = ' num2str(sum(shape_feat))])
display(['number of Intensity features = ' num2str(sum(intensity_feat))])
display(['number of texture features = ' num2str(sum(texture_feat))])

% Display the number of common features 
d =  T1{:,4}; % get common features
common_feat = ~cellfun(@(x)strcmp(x,'[]'),d); % Get common feature rows
display(['total number of common features = ' num2str(sum(common_feat))])

% Statistics per software and feature type
e = T1{:,2}; % get software names

% For Python
f = cellfun(@(x)strcmp(x,'Python'),e); % get rows with Python
display(['total number of common shape features for Python = ' num2str(sum(f & shape_feat & common_feat))])
display(['total number of shape features for Python = ' num2str(sum(f & shape_feat))])
display(['total number of common Intensity features for Python = ' num2str(sum(f & intensity_feat & common_feat))])
display(['total number of Intensity features for Python = ' num2str(sum(f & intensity_feat))])
display(['total number of common texture features for Python = ' num2str(sum(f & texture_feat & common_feat))])
display(['total number of texture features for Python = ' num2str(sum(f & texture_feat))])

% For ImageJ
f = cellfun(@(x)strcmp(x,'ImageJ'),e); % get rows with ImageJ
display(['total number of common shape features for ImageJ = ' num2str(sum(f & shape_feat & common_feat))])
display(['total number of shape features for ImageJ = ' num2str(sum(f & shape_feat))])
display(['total number of common Intensity features for ImageJ = ' num2str(sum(f & intensity_feat & common_feat))])
display(['total number of Intensity features for ImageJ = ' num2str(sum(f & intensity_feat))])
display(['total number of common texture features for ImageJ = ' num2str(sum(f & texture_feat & common_feat))])
display(['total number of texture features for ImageJ = ' num2str(sum(f & texture_feat))])

% For CellProfiler
f = cellfun(@(x)strcmp(x,'CellProfiler'),e); % get rows with CellProfiler
display(['total number of common shape features for CellProfiler = ' num2str(sum(f & shape_feat & common_feat))])
display(['total number of shape features for CellProfiler = ' num2str(sum(f & shape_feat))])
display(['total number of common Intensity features for CellProfiler = ' num2str(sum(f & intensity_feat & common_feat))])
display(['total number of Intensity features for CellProfiler = ' num2str(sum(f & intensity_feat))])
display(['total number of common texture features for CellProfiler = ' num2str(sum(f & texture_feat & common_feat))])
display(['total number of texture features for CellProfiler = ' num2str(sum(f & texture_feat))])

% For MaZda
f = cellfun(@(x)strcmp(x,'MaZda'),e); % get rows with MaZda
display(['total number of common shape features for MaZda = ' num2str(sum(f & shape_feat & common_feat))])
display(['total number of shape features for MaZda = ' num2str(sum(f & shape_feat))])
display(['total number of common Intensity features for MaZda = ' num2str(sum(f & intensity_feat & common_feat))])
display(['total number of Intensity features for MaZda = ' num2str(sum(f & intensity_feat))])
display(['total number of common texture features for MaZda = ' num2str(sum(f & texture_feat & common_feat))])
display(['total number of texture features for MaZda = ' num2str(sum(f & texture_feat))])



