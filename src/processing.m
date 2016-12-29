% load data sets
train = DataSet('train');
test = DataSet('test');

% load target vector
Y = train.targets;

% normalize data
% only done once, normalized data is stored to disk!
% path is ./data/set_name/normalized/x.mat
fprintf('%s normalize training data\n', ts());
train.normalize_set();
fprintf('%s normalize test data\n', ts());
test.normalize_set();

% generate the cuboids
fprintf('%s generate cubes\n', ts());
cubes = generate_cubes(17, train);

% extract features
fprintf('%s extract features from training data\n', ts());
X_17_20_0 = extract_features(train, cubes, 20, true);
fprintf('%s extract features from test data\n', ts());
X_17_20_1 = extract_features(test, cubes, 20, true);

% calculate means and stds
fprintf('%s calculate means and stds\n', ts());
means = [mean(X_17_20_0(Y==0, :)); mean(X_17_20_0(Y==1, :))];
stds = [std(X_17_20_0(Y==0, :)); std(X_17_20_0(Y==1, :))];

p_means = abs(means(1, :) - means(2, :));
p_stds = stds(1, :)+stds(2, :);
p_divs = p_means./p_stds;

% sort and select
fprintf('%s select best features\n', ts());
[s_divs, i_divs] = sort(p_divs, 'descend');
X_17_20_2k_0 = X_17_20_0(:, i_divs(1:2048));
X_17_20_2k_1 = X_17_20_1(:, i_divs(1:2048));

% save to disk
fprintf('%s store .mat files to disk\n', ts());
save('./features/X_17_20_2k_0.mat', 'X_17_20_2k_0');
save('./features/X_17_20_2k_1.mat', 'X_17_20_2k_1');

% continue in Python (tuning.py, then predict_final.py)