function write(hdfName, pathName, dsetName, data)
% WRITE
%
% Description:
%   Write one or more HDF5 datasets
%
% Syntax:
%   h5tools.write(hdfName, pathName, dsetName, data)
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

    h5tools.datasets.writeDatasetByType(hdfName, pathName, dsetName, data);