function makeMatrixDataset(hdfName, pathName, dsetName, data)
% Write numeric data to an HDF5 dataset
% 
% Description:
%   Chains h5create and h5write for use with numeric data
%
% Syntax:
%   h5tools.datasets.makeMatrixDataset(hdfFile, pathName, dsetName, data)
%
% Inputs:
%   hdfName     char
%       HDF5 file name
%   pathName     char
%       Path of the group where dataset was written
%   dsetName     char
%       Name of the dataset
%   data        numeric
%       Data to write to the dataset
%
% Outputs:
%   N/A
%
% Examples:   
%   % Write a dataset named 'D1' in group '/G1'
%   input = magic(5);
%   h5tools.datasets.makeMatrixDataset('Test.h5', '/G1', 'D1', input);
%
% See Also:
%   h5tools.write, h5tools.datasets.writeDatasetByType, h5write, h5create

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