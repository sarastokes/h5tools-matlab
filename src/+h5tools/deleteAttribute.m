function deleteAttribute(hdfName, pathName, name)
% DELETEATTRIBUTE
%
% Description:
%   Delete an attribute
%
% Syntax:
%   h5tools.deleteAttribute(hdfFile, pathName, name)
%
% Inputs:
%   hdfName         char or H5ML.id
%       The HDF5 file name or identifier
%   pathName        char
%       The path to the dataset or group within the HDF5 file
%
% Examples:
%   h5tools.deleteAttribute('File.h5', '/GroupOne', 'AttrName')
%
% See also:
%   h5tools.deleteObject

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments
        hdfName                         {mustBeHdfFile(hdfName)} 
        pathName        char            {mustBeHdfPath(hdfName, pathName)}
        name            char
    end

    fileID = h5tools.openFile(hdfName, false);
    fileIDx = onCleanup(@()H5F.close(fileID));

    fprintf('Deleting %s:%s attribute %s\n', hdfName, pathName, name);
    try  % See if pathName refers to a group
        rootID = H5G.open(fileID, pathName);
        rootIDx = onCleanup(@()H5G.close(rootID));
    catch % If not, it refers to a dataset
        rootID = H5D.open(fileID, pathName);
        rootIDx = onCleanup(@()H5D.close(rootID));
    end

    H5A.delete(rootID, name);