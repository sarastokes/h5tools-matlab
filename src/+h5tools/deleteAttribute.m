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

    fileID = h5tools.files.openFile(hdfName, false);
    fileIDx = onCleanup(@()H5F.close(fileID));

    fprintf('Deleting %s:%s attribute %s\n', hdfName, pathName, name);
    rootID = H5O.open(fileID, pathName, 'H5P_DEFAULT');
    rootIDx = onCleanup(@()H5O.close(rootID));

    H5A.delete(rootID, name);