function writelink(hdfFile, linkPath, linkName, targetPath)
    % WRITELINK 
    %
    % Description:
    %   Creates a soft link within HDF5 group
    %
    % Syntax:
    %   writelink(hdfFile, linkPath, linkName, targetPath)
    %
    % Inputs:
    %   hdfFile             char or H5ML.id
    %       The file name of an HDF5 file or the identifier
    %   targetPath          char
    %       The HDF5 path to link to
    %   linkPath
    %       The HDF5 path where the link will be written
    %   linkName
    %       The name of the link
    % ---------------------------------------------------------------------
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
        warning('writelink:LinkExists',...
            'Skipped existing link at %s', h5tools.util.buildPath(linkPath, linkName));
        return
    end
    fileID = h5tools.openFile(hdfFile, false);
    fileIDx = onCleanup(@()H5F.close(fileID));

    linkID = H5G.open(fileID, linkPath);
    linkIDx = onCleanup(@()H5G.close(linkID));

    H5L.create_soft(targetPath, linkID, linkName, 'H5P_DEFAULT', 'H5P_DEFAULT');
