function [linkPath, ID] = readlink(hdfName, pathName, linkName)
% Read a soft link
%
% Description:
%   Write a dataset that is a soft link to a group or another dataset 
%   within the HDF5 file
%
% Syntax:
%   [path, ID] = h5tools.readlink(hdfName, pathName, linkName)
%
% Inputs:
%   hdfName     char
%       HDF5 file name
%   pathName    char
%       HDF5 group path containing the link
%   linkName    char
%       Name of the link
%
% Outputs:
%   path        char
%       Path within HDF5 file of linked object
%   ID          H5ML.id
%       Identifier of linked object
%
% See Also:
%   h5tools.writelink, h5tools.getAllSoftlinks

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName         char        {mustBeHdfFile(hdfName)}
        pathName        char        %{mustBeHdfPath(hdfName, pathName)}
        linkName        char 
    end

    import h5tools.files.HdfTypes

    fullPath = h5tools.util.buildPath(pathName, linkName);
    info = h5info(hdfName, fullPath);
    linkPath = info.Value{1};

    if nargout == 2
        fileID = h5tools.files.openFile(hdfName);
        fileIDx = onCleanup(@()H5F.close(fileID));
        objID = H5O.open(fileID, linkPath, 'H5P_DEFAULT');
        objIDx = onCleanup(@()H5O.close(objID));
        
        hdfType = h5tools.files.HdfTypes.get(objID);
        if hdfType == HdfTypes.GROUP
            ID = H5G.open(fileID, linkPath);
        elseif hdfType == HdfTypes.DATASET
            ID = H5D.open(fileID, linkPath);
        end
    end