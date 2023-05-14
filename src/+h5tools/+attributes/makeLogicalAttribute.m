function makeLogicalAttribute(hdfName, pathName, attName, data)
% Write logical as an attribute
%
% Description:
%   Write logical to an attribute of an HDF5 group or dataset
%
% Syntax:
%   h5tools.attributes.makeLogicalAttribute(hdfName, pathName, attName, data)
%
% Input:
%   hdfName             char
%       HDF5 file name
%   pathName            char
%       HDF5 path of the group/dataset containing the HDF5 attribute
%   attName             char
%       Attribute name 
%   data                logical
%       Data to be written to the attribute
%
% Outputs:
%   N/A
%
% Examples:
%   % Write attribute named 'A1' to group '/G1'
%   input = [true, false, true]; 
%   out = h5tools.attributes.makeLogicalAttribute('File.h5', '/G1', 'Att1', input)
%
% See Also:
%   h5tools.readatt, h5tools.attributes.readEnumTypeAttribute

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments
        hdfName             {mustBeHdfFile(hdfName)}
        pathName    char    %{mustBeHdfPath(hdfName, pathName)}
        attName     char    
        data        logical 
    end

    
    % File
    if ~isa(hdfName, 'H5ML.id')
        fileID = h5tools.files.openFile(hdfName, false);
        fileIDx = onCleanup(@()H5F.close(fileID));
    else
        fileID = hdfName;
    end

    % Parent dataset/group
    objID = H5O.open(fileID, pathName, 'H5P_DEFAULT');
    objIDx = onCleanup(@()H5O.close(objID));

    % Datatype
    typeID = H5T.enum_create('H5T_STD_U8LE');
    typeIDx = onCleanup(@()H5T.close(typeID));
    H5T.enum_insert(typeID, 'FALSE', 0);
    H5T.enum_insert(typeID, 'TRUE', 1);

    spaceID = H5S.create_simple(2, fliplr(size(data)), []);
    spaceIDx = onCleanup(@()H5S.close(spaceID));

    attID = H5A.create(objID, attName, typeID, spaceID, 'H5P_DEFAULT');
    attIDx = onCleanup(@()H5A.close(attID));
    H5A.write(attID, typeID, uint8(data));
