function makeLogicalDataset(hdfName, pathName, dsetName, data)
% MAKELOGICALDATASET
%
% Description:
%   Write logical as an enum type dataset with two values (true, false)
%
% Syntax:
%   makeLogicalDataset(hdfName, pathName, dsetName, data)
%
% See also:
%   h5tools.write, h5tools.datasets.writeDatasetByType
% -------------------------------------------------------------------------

    arguments
        hdfName                 {mustBeHdfFile(hdfName)}
        pathName    char        {mustBeHdfPath(hdfName, pathName)}
        dsetName    char
        data        logical 
    end

    fullPath = h5tools.util.buildPath(pathName, dsetName);

    % File
    if ~isa(hdfName, 'H5ML.id')
        fileID = h5tools.files.openFile(hdfName, false);
        fileIDx = onCleanup(@()H5F.close(fileID));
    else
        fileID = hdfName;
    end

    % Datatype
    typeID = H5T.enum_create('H5T_STD_U8LE');
    typeIDx = onCleanup(@()H5T.close(typeID));
    H5T.enum_insert(typeID, 'FALSE', 0);
    H5T.enum_insert(typeID, 'TRUE', 1);

    % Dataspace
    if isvector(data)
        nDims = 1;
        dims = length(data);
    else
        nDims = ndims(data);
        dims = size(data);
    end
    dims = fliplr(dims);

    spaceID = H5S.create_simple(nDims, dims, []);
    spaceIDx = onCleanup(@()H5S.close(spaceID));

    % Dataset
    propList = H5P.create('H5P_DATASET_CREATE');
    propListx = onCleanup(@()H5P.close(propList));

    dsetID = H5D.create(fileID, fullPath, typeID, spaceID, propList);
    dsetIDx = onCleanup(@()H5D.close(dsetID));
    
    H5D.write(dsetID, typeID, spaceID, spaceID, 'H5P_DEFAULT', uint8(data));
