function names = getAttributeNames(hdfName, pathName)
    % GETALLATTRIBUTENAMES
    %
    % Description:
    %   Return all attribute names for an HDF5 dataset or group
    %
    % Syntax:
    %   names = getAllAttributeNames(hdfFile, pathName)
    %
    % Inputs:
    %   hdfName         char or H5ML.id
    %       The HDF5 file name or identifier
    %
    % Outputs:
    %   names           string
    %       The names of all attributes contained by the object
    %
    % History:
    %   17Oct2022 - SSP
    % -------------------------------------------------------------
    arguments
        hdfName     char     {h5tools.validators.mustBeHdfFile(hdfName)}
        pathName    char
    end

    if isa(hdfName, 'H5ML.id')
        fileID = hdfName;
    else
        fileID = H5F.open(hdfName);
        fileIDx = onCleanup(@()H5F.close(fileID));
    end
    
    % Are the attributes associated with a dataset or a group
    try
        rootID = H5G.open(fileID, pathName);
        rootIDx = onCleanup(@()H5G.close(rootID));
    catch
        rootID = H5D.open(fileID, pathName);
        rootIDx = onCleanup(@()H5D.close(rootID));
    end

    names = string.empty();
    [~, ~, names] = H5A.iterate(rootID, 'H5_INDEX_NAME',...
        'H5_ITER_NATIVE', 0, @attributeIterateFcn, names);
end

function [status, names] = attributeIterateFcn(~, name, ~, names)
    names = cat(1, names, string(name));
    status = 0;
end