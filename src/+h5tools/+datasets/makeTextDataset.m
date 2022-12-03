function makeTextDataset(hdfName, pathName, dsetName, txt) 
    % MAKETEXTDATASET
    %
    % Description:
    %   Create dataset for char/string data
    %
    % Syntax:
    %   makeTextDataset(fileName, pathName, dsetName, txt)
    % -------------------------------------------------------------
    arguments
        hdfName             char        {mustBeFile(hdfName)}
        pathName            char
        dsetName            char 
        txt
    end

    if isa(hdfName, 'H5ML.id')
        fileID = hdfName;
    else
        fileID = h5tools.openFile(hdfName, false);
        fileIDx = onCleanup(@()H5F.close(fileID));
    end
        
    typeID = H5T.copy('H5T_C_S1');
    typeIDx = onCleanup(@()H5T.close(typeID));
    H5T.set_size(typeID, 'H5T_VARIABLE');
    H5T.set_strpad(typeID, 'H5T_STR_NULLTERM');

    dspaceID = H5S.create('H5S_SCALAR');
    dspaceIDx = onCleanup(@()H5S.close(dspaceID));
    
    % Get the parent group, create if doesn't exist
    try
        groupID = H5G.open(fileID, pathName);
        groupIDx = onCleanup(@()H5G.close(groupID));
    catch ME
        if contains(ME.message, 'doesn''t exist')
            groupID = H5G.create(fileID, pathName,...
                'H5P_DEFAULT', 'H5P_DEFAULT', 'H5P_DEFAULT');
            groupIDx = onCleanup(@()H5G.close(groupID));
        else
            rethrow(ME);
        end
    end

    % Get the dataset
    try
        dsetID = H5D.create(groupID, dsetName, typeID, dspaceID, 'H5P_DEFAULT');
        dsetIDx = onCleanup(@()H5D.close(dsetID));
    catch ME
        if contains(ME.message, 'name already exists')
            dsetID = H5D.open(groupID, dsetName, 'H5P_DEFAULT');
            dsetIDx = onCleanup(@()H5D.close(dsetID));
        else
            rethrow(ME);
        end
    end
    H5D.write(dsetID, 'H5ML_DEFAULT', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT', txt);
end