function cubes = generate_cubes(n, set)

    cubes = Cuboid.max_instance().split(n);
    
    nonzero = ones(n^3, 1);
    
    for j=1:set.count
        b = set.load(j);

        for k=1:n^3
            if(nonzero(k))
                if(nnz(cubes(k).submatrix(b)) < 500)
                    nonzero(k) = 0;
                end
            end
        end
    end
    
    for i=n^3:-1:1
        if(~nonzero(i))
            cubes(i) = [];
        end
    end
    
end