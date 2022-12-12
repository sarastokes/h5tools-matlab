function makeLogicalDataset(hdfName, pathName, dsetName, data)
% Write logical to an HDF5 dataset
%
% Description:
%   Write logical as an enum type dataset with two values (true, false)
%
% Syntax:
%   h5tools.dataset.makeLogicalDataset(hdfName, pathName, dsetName, data)
%
% Inputs:
%   hdfName         char or H5ML.id
%       HDF5 file name or identifier
%   pathName        char
%       HDF5 path to group where dataset will be written
%   dsetName        char
%       Name of the dataset
%   data            logical
%       Data to be written
%
% Outputs:
%   N/A
%
% Examples:   
%   % Write a dataset named 'D1' in group '/G1'
%   input = [true, false, true];
%   h5tools.datasets.makeStringDataset('Test.h5', '/G1', 'D1', input);
%
%
% See also:
%   h5tools.write, h5tools.datasets.readEnumTypeDataset
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
