function makeEnumTypeAttribute(hdfName, pathName, attName, data)
% Write enumerated type as attribute
%
% Description:
%   Write a matlab enumeration class as an HDF5 attribute
%
% Syntax:
%   makeEnumTypeAttribute(hdfName, pathName, attName, data)
%
%
% Inputs:
%   hdfFile     char or H5ML.id
%       HDF5 file name or identifier
%   hdfPath     char
%       Path of the dataset/group where attributes will be written
%   attName     char
%       Attribute name
%   data        enum
%       Data to write to the attribute
%
% See also:
%   h5tools.writeatt, h5tools.readatt

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName             {mustBeHdfFile(hdfName)}
        pathName    char    {mustBeHdfPath(hdfName, pathName)}
        attName     char
        data                {mustBeEnum(data)}
    end
    
    % Determine enumeration characteristics
    matlabClass = string(class(data));
    mc = metaclass(data);
    memberNames = arrayfun(@(x) string(x.Name), mc.EnumerationMemberList);
    values = arrayfun(@(x) find(memberNames == string(x)), data);

    fileID = h5tools.files.openFile(hdfName, false);
    fileIDx = onCleanup(@()H5F.close(fileID));

    objID = H5O.open(fileID, pathName, 'H5P_DEFAULT');
    objIDx = onCleanup(@()H5O.close(objID));

    typeID = H5T.enum_create('H5T_STD_I32LE');
    typeIDx = onCleanup(@()H5T.close(typeID));
    for i = 1:numel(memberNames)
        H5T.enum_insert(typeID, [matlabClass + "." + memberNames(i)], uint32(i));
    end

    spaceID = H5S.create_simple(2, fliplr(size(data)), []);
    spaceIDx = onCleanup(@()H5S.close(spaceID));

    attID = H5A.create(objID, attName, typeID, spaceID, 'H5P_DEFAULT');
    attIDx = onCleanup(@()H5A.close(attID));
    H5A.write(attID, typeID, uint32(values));

