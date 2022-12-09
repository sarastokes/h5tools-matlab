function makeStringDataset(hdfName, pathName, dsetName, data)
% MAKESTRINGDATASET
%
% Description:
%   Write a string array dataset
%
% Syntax:
%   makeStringDataset(fileName, pathName, dsetName, data)
%
% See also:
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