function writelink(hdfFile, linkPath, linkName, targetPath)
% WRITELINK 
%
% Description:
%   Creates a soft link within HDF5 group
%
% Syntax:
%   h5tools.writelink(hdfFile, linkPath, linkName, targetPath)
%
% Inputs:
%   hdfFile             char or H5ML.id
%       The file name of an HDF5 file or the identifier
%   linkPath
%       The HDF5 path where the link will be written
%   linkName
%       The name of the link
%   targetPath          char
%       The HDF5 path to link to
%
% See also:
%   h5tools.collectSoftlinks

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments
        hdfFile             {mustBeFile(hdfFile)} 
        linkPath            char
        linkName            char
        targetPath          char
    end

    % Check whether the target path exists
    if ~h5tools.exist(hdfFile, targetPath)
        error('writeLink:InvalidLinkTarget',...
            'Target path %s does not exist', targetPath);
    end
    % Check whether the link already exists
    if h5tools.exist(hdfFile, h5tools.util.buildPath(linkPath, linkName))
        error('writelink:DatasetExists',...
            'Skipped existing link at %s', h5tools.util.buildPath(linkPath, linkName));
        return
    end
    fileID = h5tools.files.openFile(hdfFile, false);
    fileIDx = onCleanup(@()H5F.close(fileID));

    % Open the group where the link will be written
    linkID = H5G.open(fileID, linkPath);
    linkIDx = onCleanup(@()H5G.close(linkID));

    H5L.create_soft(targetPath, linkID, linkName, 'H5P_DEFAULT', 'H5P_DEFAULT');
