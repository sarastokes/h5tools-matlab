function success = write(hdfName, pathName, dsetName, data)
% Write data to a HDF5 dataset
%
% Description:
%   Write an HDF5 dataset at the specified path 
%
% Syntax:
%   success = h5tools.write(hdfName, pathName, dsetName, data)
%
% See also:
%   h5tools.datasets.writeDatasetByType

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName                 {mustBeFile(hdfName)}
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

    success = h5tools.datasets.writeDatasetByType(...
        hdfName, pathName, dsetName, data);