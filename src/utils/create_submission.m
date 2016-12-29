function create_submission(pred)
    
    if(nargin < 1)
        error('Not enough input args!');
    end
    
    path = './prediction.csv';
    fid = fopen(path, 'w');
    fprintf(fid, 'ID,Prediction\n');
    fclose(fid);
    
    pred = [(1:length(pred))', pred];
    
    dlmwrite(path, pred, '-append');
end
