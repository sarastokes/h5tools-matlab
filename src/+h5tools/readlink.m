function [data, path, ID] = readlink(hdfName, pathName, linkName)
% Read a soft link
%
% Description:
%   Write a dataset that is a soft link to a group or another dataset 
%   within the HDF5 file
%
% Syntax:
%   [data, path, ID] = h5tools.readlink(hdfName, pathName, linkName)
%
% See Also:
%   h5tools.writelink, h5tools.getAllSoftlinks

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    import h5tools.files.HdfTypes

    fullPath = h5tools.util.buildPath(pathName, linkName);
    info = h5info(hdfName, fullPath);
    linkPath = info.Value{1};

    fileID = H5F.openFile(hdfName);
    objID = H5O.open(fileID, linkPath);
    objIDx = onCleanup(@()H5O.close(objID));
    hdfType = h5tools.files.HdfTypes.get(objID);

    if hdfType == HdfTypes.GROUP
        data = [];
        if nargout == 3
            ID = H5G.open(linkPath);
        end
    elseif hdfType == HdfTypes.DATASET
        [parentPath, dsetName] = h5tools.util.splitPath(linkPath);
        data = h5tools.read(hdfName, parentPath, dsetName)
        if nargout == 3
            ID = H5D.open(linkPath);
        end
    end