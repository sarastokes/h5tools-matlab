function out = readCompoundDataset(hdfName, pathName, dsetName)

    fullPath = h5tools.util.buildPath(pathName, dsetName);

    data = h5read(hdfName, fullPath);
    out = struct2table(data);

    % Handle individual classes
    colClasses = h5readatt(hdfName, fullPath, 'ColumnClass');
    colClasses = strsplit(colClasses, ', '); 
    if isempty(colClasses{1})
        colClasses = colClasses(2:end);
    end
    for i = 1:numel(colClasses)
        if strcmp(colClasses{i}, 'string')  
            % TODO: This seems too hard, am I missing something here                      
            colName = out.Properties.VariableNames{i};
            out.(colName) = string(out.(colName));
        end
    end

