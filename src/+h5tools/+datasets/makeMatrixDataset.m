function makeMatrixDataset(hdfName, pathName, dsetName, data)
    % MAKEMATRIXDATASET
    % 
    % Description:
    %   Chains h5create and h5write for use with simple matrices
    %
    % Syntax:
    %   makeMatrixDataset(hdfFile, pathName, dsetName, data)
    % -------------------------------------------------------------
    arguments
        hdfName             char        {mustBeFile(hdfName)} 
        pathName            char
        dsetName            char 
        data                            {mustBeNumeric(data)}
    end

    fullPath = h5tools.buildPath(pathName, dsetName);

    % Create the group (if it doesn't exist already)
    try
        h5create(hdfName, fullPath, size(data), 'Datatype', class(data));
    catch ME
        if ~strcmp(ME.identifier, 'MATLAB:imagesci:h5create:datasetAlreadyExists')
            rethrow(ME);
        end
    end                    
    % Write the dataset
    h5write(hdfName, fullPath, data);