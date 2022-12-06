function write(hdfName, pathName, dsetName, data)

    arguments
        hdfName         {h5tools.validators.mustBeHdfFile(hdfName)}
        pathName        char 
        dsetName        char
        data 
    end
    
    % Create the group, if it doesn't exist
    if ~h5tools.exist(hdfName, pathName)
        newGroup = h5tools.util.getPathEnd(pathName);
        parent = h5tools.util.getPathParent(pathName);
        h5tools.createGroup(hdfName, parent, newGroup);
    end

    h5tools.datasets.writeDatasetByType(hdfName, pathName, dsetName, data);