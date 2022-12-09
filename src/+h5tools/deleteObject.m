function deleteObject(hdfName, pathName)
% DELETEOBJECT
%
% Description:
%   Delete a group or dataset
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
% -------------------------------------------------------------------------

    arguments
        hdfName             {mustBeHdfFile(hdfName)} 
        pathName    char    {mustBeHdfPath(hdfName, pathName)}
    end
    
    objName = h5tools.util.getPathEnd(pathName);
    pathName = h5tools.util.getPathParent(pathName);
    
    if ~isa(hdfName, 'H5ML.id')
        fileID = aod.h5.HDF5.openFile(hdfName, false);
        fileIDx = onCleanup(@()H5F.close(fileID));
    else
        fileID = hdfName;
    end

    if pathName == '/'
        parentID = fileID;
    else
        try    % Try to treat pathName as a group
            parentID = H5G.open(fileID, pathName);
            parentIDx = onCleanup(@()H5G.close(parentID));
        catch  % Otherwise handle it as a dataset
            parentID = H5D.open(fileID, pathName);
            parentIDx = onCleanup(@()H5G.close(parentID));
        end
    end

    H5L.delete(parentID, objName, 'H5P_DEFAULT');