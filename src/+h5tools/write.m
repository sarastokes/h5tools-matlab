function success = write(hdfName, pathName, dsetName, data)
% Write data to a HDF5 dataset
%
% Description:
%   Write an HDF5 dataset at the specified path 
%
% Syntax:
%   success = h5tools.write(hdfName, pathName, dsetName, data)
%
% Inputs:
%   hdfName         char or H5ML.id
%       HDF5 file name or identifier
%   pathName        char
%       HDF5 path to group where dataset will be written
%   dsetName        char
%       Name of the dataset
%   data 
%       Data to be written
%
% Outputs:
%   success     logical
%       Optional flag for writing success
%
% Examples:   
%   % Write a dataset named 'D1' in group '/G1'
%   h5tools.write('Test.h5', '/G1', 'D1', 1:3);
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