function makeStringDataset(hdfName, pathName, dsetName, data)
% Write string to a dataset
%
% Description:
%   Write a string array or scalar to an HDF5 dataset
%
% Syntax:
%   h5tools.datasets.makeStringDataset(hdfName, pathName, dsetName, data)
%
% Inputs:
%   hdfName         char or H5ML.id
%       HDF5 file name or identifier
%   pathName        char
%       HDF5 path to group where dataset will be written
%   dsetName        char
%       Name of the dataset
%   data            string
%       Data to be written
%
% Outputs:
%   N/A
%
% Examples:   
%   % Write a dataset named 'D1' in group '/G1'
%   input = ["string", "array"];
%   h5tools.datasets.makeStringDataset('Test.h5', '/G1', 'D1', input);
%
% See Also:
%   h5tools.write, h5tools.datasets.writeDatasetByType

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments
        hdfName             char        {mustBeFile(hdfName)}
        pathName            char
        dsetName            char 
        data                string
    end

    fullPath = h5tools.util.buildPath(pathName, dsetName);
    if ~h5tools.exist(hdfName, fullPath)
        h5create(hdfName, fullPath, size(data), 'DataType', 'string');
    end
    h5write(hdfName, fullPath, data);