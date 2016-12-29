classdef DataSet

    properties
        name
        count
        targets
        sumsq
        path
    end
    
    methods
        function o = DataSet(set_name)
            
            o.name = set_name;
            o.path = strcat('./data/set_', o.name, '/');
            
            if(exist(o.path, 'dir') ~= 7)
                error('There is no data set named ''%s''!', o.name)
            end
            
            files = dir(fullfile(o.path, '*.nii'));
            o.count = length(files);
            
            t_path = strcat('./data/targets.csv');
            if(exist(t_path, 'file'))
                o.targets = csvread(t_path);
                o.sumsq = var(o.targets)*o.count-1;
            end
        end
        
        % normalize data in set
        % set all 0-voxels to -Inf, then normalize the rest
        function normalize_set(o)
            if(~exist([o.path, 'normalized'], 'dir'))
                mkdir([o.path, 'normalized/']);

                for i=1:o.count
                    b = o.load(i);

                    b_n = double(b);

                    b_n(b_n==0) = -Inf;
                    b_mean = mean(b_n(b_n~=-Inf));
                    b_n = b_n - b_mean;
                    b_std = std(b_n(b_n~=-Inf));
                    b_n = b_n/b_std;

                    file = [o.path, 'normalized/', o.name, '_', num2str(i), '.mat'];
                    save(file, 'b_n');
                end
            else
                fprintf('%s ''%s'' is already normalized\n', ts(), o.name);
            end
        end
        
        function path = path_to_file(o, index)
            if(index > o.count)
                error('''index'' exceeds number of brains in set ''%s''!', o.name);
            end
            
            % construct file name
            path = strcat(o.name, '_', num2str(index), '.nii');
        end
        
        function b = load(o, index)

            % load brain struct using nifty libs
            s = load_nii(o.path_to_file(index));
            
            % extract matrix from brain struct
            b = s.img;
        end
        
        function b_n = load_normalized(o, index)
            file = [o.path, 'normalized/', o.name, '_', num2str(index), '.mat'];
            load(file);
        end
        
        function view(o, index)
            b = load_nii(o.path_to_file(index));
            view_nii(b)
        end
    end
end
