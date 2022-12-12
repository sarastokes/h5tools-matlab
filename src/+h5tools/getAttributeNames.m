function names = getAttributeNames(hdfName, pathName)
% Get names of all attributes
%
% Description:
%   Return all attribute names for an HDF5 dataset or group
%
% Syntax:
%   names = h5tools.getAllAttributeNames(hdfFile, pathName)
%
% Inputs:
%   hdfName         char or H5ML.id
%       The HDF5 file name or identifier
%   pathName        char
%       The path to the dataset or group within the HDF5 file
%
% Outputs:
%   names           string
%       The names of all attributes contained by the object
%
% Examples:
%   % Get all attributes for group "/G1"
%   names = h5tools.getAttributeNames('File.h5', '/G1');
%
% See also:
%   h5tools.hasAttribute, h5tools.readatt

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments
        hdfName              {mustBeHdfFile(hdfName)}
        pathName    char
    end

    if isa(hdfName, 'H5ML.id')
        fileID = hdfName;
    else
        fileID = H5F.open(hdfName);
        fileIDx = onCleanup(@()H5F.close(fileID));
    end
    
    rootID = H5O.open(fileID, pathName, 'H5P_DEFAULT');
    rootIDx = onCleanup(@()H5O.close(rootID));

    names = string.empty();
    [~, ~, names] = H5A.iterate(rootID, 'H5_INDEX_NAME',...
        'H5_ITER_NATIVE', 0, @attributeIterateFcn, names);
end

function [status, names] = attributeIterateFcn(~, name, ~, names)
    names = cat(1, names, string(name));
    status = 0;
end