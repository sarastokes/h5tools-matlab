function names = getAttributeNames(hdfFile, pathName)
    % GETALLATTRIBUTENAMES
    %
    % Description:
    %   Return all attribute names for an HDF5 dataset or group
    %
    % Syntax:
    %   names = getAllAttributeNames(hdfFile, pathName)
    %
    % History:
    %   17Oct2022 - SSP
    % -------------------------------------------------------------
    arguments
        hdfFile             char     {mustBeFile(hdfFile)} 
        pathName            char
    end

    fileID = H5F.open(hdfFile);
    fileIDx = onCleanup(@()H5F.close(fileID));
    groupID = H5G.open(fileID, pathName);
    groupIDx = onCleanup(@()H5G.close(groupID));

    names = string.empty();
    [~, ~, names] = H5A.iterate(groupID, 'H5_INDEX_NAME',...
        'H5_ITER_NATIVE', 0, @attributeIterateFcn, names);
end

function [status, names] = attributeIterateFcn(~, name, ~, names)
    names = cat(1, names, string(name));
    status = 0;
end