function makeEnumTypeDataset(hdfName, pathName, dsetName, data)
% Write an enumerated type dataset
%
% Description:
%   Write a dataset with a enumerated type datatype
%
% Syntax:
%   h5tools.datasets.makeEnumTypeDataset(hdfName, pathName, dsetName, data)
%
% Inputs:
%   hdfName         char or H5ML.id
%       HDF5 file name or identifier
%   pathName        char
%       HDF5 path to group where dataset will be written
%   dsetName        char
%       Name of the dataset
%   data            enum
%       Data to be written
%
% Outputs:
%   N/A
%
% Examples:   
%   % Write a dataset named 'D1' in group '/G1'
%   input = [test.EnumClass.GROUPONE, test.EnumClass.GROUPTWO];
%   h5tools.datasets.makeEnumTypeDataset('Test.h5', '/G1', 'D1', input);
%
% See Also:
%   h5tools.write, h5tools.readEnumTypeDataset
%

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName                 {mustBeHdfFile(hdfName)}
        pathName    char        %{mustBeHdfPath(hdfName, pathName)}
        dsetName    char
        data                    {mustBeEnum(data)}
    end

    fullPath = h5tools.util.buildPath(pathName, dsetName);

    % Determine enumeration characteristics
    mc = metaclass(data);
    memberNames = arrayfun(@(x) string(x.Name), mc.EnumerationMemberList);
    values = arrayfun(@(x) find(memberNames == string(x)), data);

    % File
    if ~isa(hdfName, 'H5ML.id')
        fileID = h5tools.files.openFile(hdfName, false);
        fileIDx = onCleanup(@()H5F.close(fileID));
    else
        fileID = hdfName;
    end

    % Datatype
    typeID = H5T.enum_create('H5T_STD_U32LE');
    typeIDx = onCleanup(@()H5T.close(typeID));
    for i = 1:numel(memberNames)
        H5T.enum_insert(typeID, memberNames(i), uint8(i));
    end 

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
    
    H5D.write(dsetID, typeID, spaceID, spaceID, 'H5P_DEFAULT', uint32(values));
