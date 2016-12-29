classdef Cuboid < handle & Region
    
    properties
        x
        y
        z
        v_min
        v_max
    end
    
    methods
        function o = Cuboid(x, y, z)
            o.x = x;
            o.y = y;
            o.z = z;
            o.v_min = Inf;
            o.v_max = 0;
        end
        
        function [d_min, d_max] = extreme_values(o, data)
            sub = o.submatrix(data);
            d_min = min(sub(:));
            d_max = max(sub(:));
            o.v_min = min(d_min, o.v_min);
            o.v_max = max(d_max, o.v_max);
        end
        
        function hgram = histogram(o, data, n_bins)
            hgram = histcounts(o.submatrix(data), n_bins);
            %hgram = histcounts(o.submatrix(data), linspace(double(o.v_min), double(o.v_max), n_bins+1));
        end
        
        function mean = mean(o, data)
            mean = mean2(o.submatrix(data));
        end
        
        function std = std(o, data)
            std = std2(o.submatrix(data));
        end
        
        function sub = submatrix(o, data)
            sub = data(o.x(1):o.x(2), o.y(1):o.y(2), o.z(1):o.z(2));
            sub = sub(sub~=-Inf);
        end
        
        function cubes = split(o, n)
            % why is this so slow?...
            
            cubes = Cuboid.empty(0);
            
            s = o.max_size()./n;
            
            z_ = [1,s(1)];
            for i=1:n
                y_ = [1,s(2)];
                for j=1:n
                    x_ = [1,s(3)];
                    for k=1:n
                        
                        cubes = [cubes, Cuboid(floor(x_), floor(y_), floor(z_))];
                        
                        x_ = x_ + s(3);
                    end
                    y_ = y_ + s(2);
                end
                z_ = z_ + s(3);
            end
        end
    end
    
    methods(Static)
        function max = max_size()
            max = [176,208,176];
        end
        
        function o = max_instance()
            s = Cuboid.max_size()';
            s = [ones(3,1), s];
            o = Cuboid(s(1,:), s(2,:), s(3,:));
        end
        
        function o = random_instance()
            % create random cuboid
            size = Cuboid.max_size();
            voxels = 1;
            
            % make sure region isn't tiny
            while(voxels < 500)
                voxels = 1;
                
                %   randomly choose indices for x dim
                x = randi([1, size(1)], 1, 2);
                x = sort(x);
                voxels = voxels*(x(2)-x(1));

                %   randomly choose indices for y dim
                y = randi([1, size(2)], 1, 2);
                y = sort(y);
                voxels = voxels*(y(2)-y(1));
                
                %   randomly choose indices for z dim
                z = randi([1, size(3)], 1, 2);
                z = sort(z);
                voxels = voxels*(z(2)-z(1));
            
                o = Cuboid(x, y, z);
            end
        end
    end
end