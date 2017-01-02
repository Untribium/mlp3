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
cubes = generate_cubes(7, train);

% extract features
fprintf('%s extract features from training data\n', ts());
X_7_40_0 = extract_features(train, cubes, 40, true);
fprintf('%s extract features from test data\n', ts());
X_7_40_1 = extract_features(test, cubes, 40, true);

% save to disk
fprintf('%s store .mat files to disk\n', ts());
save('./features/X_7_40_0.mat', 'X_7_40_0');
save('./features/X_7_40_1.mat', 'X_7_40_1');

% continue in Python (tuning.py, then predict_final.py)