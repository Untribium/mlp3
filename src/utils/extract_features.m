% Extracts features from all brains in the specified data set
% Every brain is split n-1 times in all dimensions, so for n=5 we get 125
% cuboids.
% Extracted values are:
% - histogram (using specified number of bins)
% - mean
% - standard deviation
function X = extract_features(data, cubes, n_bins, normalized)

    if(nargin < 4)
        normalized = false;
    end

    n_cubes = length(cubes);

    n_scores = n_bins;
    % add space for mean and std
    n_scores = n_scores+2;
    
    % init feature matrix
    X = zeros(data.count, n_cubes*n_scores);
    
    % iterate over all brains
    for i=1:data.count
        % load brain i
        if(normalized)
            b = data.load_normalized(i);
        else
            b = data.load(i);
        end
        
        % extract all features
        for j=1:length(cubes)
            hi = cubes(j).histogram(b, n_bins);
            me = cubes(j).mean(b);
            sd = cubes(j).std(b);
            
            X(i, (j-1)*n_scores+1:j*n_scores) = [hi, me, sd];
        end
    end
    
end