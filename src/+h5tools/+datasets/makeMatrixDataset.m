function makeMatrixDataset(hdfName, pathName, dsetName, data)
% MAKEMATRIXDATASET
% 
% Description:
%   Chains h5create and h5write for use with simple matrices
%
% Syntax:
%   h5tools.makeMatrixDataset(hdfFile, pathName, dsetName, data)
%
% See also:
%   h5tools.write, h5tools.datasets.writeDatasetByType, h5write

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments
        hdfName             char        {mustBeFile(hdfName)} 
        pathName            char
        dsetName            char 
        data                            {mustBeNumeric(data)}
    end

    fullPath = h5tools.util.buildPath(pathName, dsetName);

    % Create the dataset (if it doesn't exist already)
    try
        h5create(hdfName, fullPath, size(data), 'Datatype', class(data));
    catch ME
        % If it already exists, try to proceed with the next step
        if ~contains(ME.message, 'already exists')
            rethrow(ME);
        end
    end                    
    % Write the dataset
    h5write(hdfName, fullPath, data);