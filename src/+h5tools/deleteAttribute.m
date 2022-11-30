function deleteAttribute(hdfFile, pathName, name)
    % DELETEATTRIBUTE
    %
    % Description:
    %   Delete an attribute
    %
    % Syntax:
    %   deleteAttribute(hdfFile, pathName, name)
    % -------------------------------------------------------------
    arguments
        hdfFile            {mustBeFile(hdfFile)} 
        pathName            char
        name                char
    end

    fileID = h5tools.openFile(hdfFile, false);
    fileIDx = onCleanup(@()H5F.close(fileID));

    fprintf('Deleting %s:%s attribute %s\n', hdfFile, pathName, name);
    try  % See if pathName refers to a group
        rootID = H5G.open(fileID, pathName);
        rootIDx = onCleanup(@()H5G.close(rootID));
    catch % If not, it refers to a dataset
        rootID = H5D.open(fileID, pathName);
        rootIDx = onCleanup(@()H5D.close(rootID));
    end

    H5A.delete(rootID, name);