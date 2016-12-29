classdef Extractor

    properties
        name
        region
        n_buckets
        selection
    end
    
    methods
        function o = Extractor(region, n_buckets, selection)
            o.region = region;
            o.n_buckets = n_buckets;
            o.selection = selection;
            % random id to avoid name clashes
            id = num2str(sprintf('%05d', randi(99999)));
            o.name = strcat(datestr(now, 'mm-dd_HH-MM_'), id);
        end
        
        function fval = extract(o, data)
            if(min(o.selection) <= 2)
                mean = o.region.mean(data);
                std = o.region.std(data);
            else
                mean = 0;
                std = 0;
            end
            
            if(max(o.selection) > 2)
                hgram = o.region.histogram(data, o.n_buckets);
            else
                hgram = [];
            end
            
            fvals = [mean, std, hgram];
            fval = fvals(o.selection(1));
            
            for k=2:size(o.selection, 2)
                fval = fval - fvals(o.selection(k));
            end
        end
        
        function save(o, suite_name)
            path = strcat('./extractors/', suite_name, '/');
            % fprintf('[save] Saving extractor ''%s''\n', o.name);
            save(strcat(path, o.name, '.mat'), 'o');
        end
        
        function delete(o, suite_name)
            path = strcat('./extractors/', suite_name, '/');
            % fprintf('[delete] Deleting extractor ''%s''\n', o.name);
            delete(strcat(path, o.name, '.mat'));
        end
    end
    
    methods(Static)
        function o = random_instance(specifiers)
            
            % set defaults if params empty
            if(nargin == 0)
                specifiers = cell(2,1);
            end
            
            if(isempty(specifiers{1}))
                specifiers(1) = {[5, 20]};
            end
            if(isempty(specifiers{2}))
                specifiers(2) = {[1, 4]};
            end
            
            % get random cuboid
            c = Cuboid.random_instance();

            % randomly choose number of buckets
            n_buckets = randi(specifiers{1});

            % randomly choose n_selections
            n_selections = randi(specifiers{2});
            
            % randomly choose indices for scores to be used
            selection = datasample(1:n_buckets+2, n_selections, 'Replace', false);

            % init extractor
            o = Extractor(c, n_buckets, selection);
        end
        
        function os = random_batch(batch_size, specifiers)
            os = Extractor.empty(0);
            
            if(nargin < 2)
                specifiers = cell(2,1);
            end
            
            for k=1:batch_size
                os(k) = Extractor.random_instance(specifiers);
            end
        end
    end
end