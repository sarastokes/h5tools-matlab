function deleteObject(hdfName, pathName)
% Delete a group or dataset
%
% Description:
%   Delete a group or dataset within the HDF5 file (see Warning below)
%
% Syntax:
%   h5tools.deleteObject(fileID, pathName)
%
% Inputs:
%   hdfName         char, H5ML.id
%       HDF5 file name or identifier
%   pathName        char
%       HDF5 path to the dataset/group to delete
%
% Examples:
%   % Delete 'Dataset1'
%   h5tools.deleteObject(hdfName, '/Group1/Dataset1')
%
%   % Delete 'Group1A'
%   h5tools.deleteObject(hdfName, '/Group1/Group1A')
%
% Warning:
%   Deleting an HDF5 object only removes the link, the data still exists
%   and the file size is not reduced. Space can only be recovered with
%   h5repack in the HDF5 library
%
% See also:
%   h5tools.deleteAttribute

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------


    arguments
        hdfName             {mustBeHdfFile(hdfName)} 
        pathName    char    {mustBeHdfPath(hdfName, pathName)}
    end
    
    [pathName, objName] = h5tools.util.splitPath(pathName);
    
    if ~isa(hdfName, 'H5ML.id')
        fileID = h5tools.files.openFile(hdfName, false);
        fileIDx = onCleanup(@()H5F.close(fileID));
    else
        fileID = hdfName;
    end

    if pathName == '/'
        parentID = fileID;
    else
        parentID = H5O.open(fileID, pathName);
        parentIDx = onCleanup(H5O.close(parentID));
    end

    H5L.delete(parentID, objName, 'H5P_DEFAULT');