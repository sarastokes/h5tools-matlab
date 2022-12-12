function writelink(hdfName, linkPath, linkName, targetPath)
% Write an HDF5 soft link 
%
% Description:
%   Creates a soft link dataset within HDF5 group linking to another 
%   dataset or group within the HDF5 file.
%
% Syntax:
%   h5tools.writelink(hdfName, linkPath, linkName, targetPath)
%
% Inputs:
%   hdfName             char or H5ML.id
%       The file name of an HDF5 file or the identifier
%   linkPath
%       The HDF5 path to the group where the link will be written
%   linkName
%       The name of the link
%   targetPath          char
%       The HDF5 path of the group or dataset that is the link target
%
% Outputs:
%   N/A
%
% See Also:
%   h5tools.collectSoftlinks, h5tools.readlink

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments
        hdfName             {mustBeHdfFile(hdfName)} 
        linkPath            {mustBeHdfPath(hdfName, linkPath)}
        linkName            char
        targetPath          {mustBeHdfPath(hdfName, targetPath)}
    end

    if isa(hdfName, 'H5ML.id')
        fileID = hdfName;
    else
        fileID = h5tools.files.openFile(hdfName, false);
        fileIDx = onCleanup(@()H5F.close(fileID));
    end

    % Open the group where the link will be written
    linkID = H5G.open(fileID, linkPath);
    linkIDx = onCleanup(@()H5G.close(linkID));

    H5L.create_soft(targetPath, linkID, linkName, 'H5P_DEFAULT', 'H5P_DEFAULT');
