function makeEnumTypeDataset(hdfName, pathName, dsetName, data)
% MAKEENUMTYPEDATASET
%
% Description:
%   Write enumerated type dataset
%
% Syntax:
%   makeEnumTypeDataset(hdfName, pathName, dsetName, data)
%
% See also:
%   h5tools.write, h5tools.readEnumDataset

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName                 {mustBeHdfFile(hdfName)}
        pathName    char        {mustBeHdfPath(hdfName, pathName)}
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
        fileID = h5tools.openFile(hdfName, false);
        fileIDx = onCleanup(@()H5F.close(fileID));
    else
        fileID = hdfName;
    end

    % Datatype
    typeID = H5T.enum_create('H5T_STD_I8LE');
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
    
    H5D.write(dsetID, typeID, spaceID, spaceID, 'H5P_DEFAULT', uint8(values));
