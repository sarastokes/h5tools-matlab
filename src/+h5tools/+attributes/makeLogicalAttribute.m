function makeLogicalAttribute(hdfName, pathName, attName, data)

    arguments
        hdfName             {mustBeHdfFile(hdfName)}
        pathName    char    {mustBeHdfPath(hdfName, pathName)}
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
    typeID = H5T.enum_create('H5T_STD_I32LE');
    typeIDx = onCleanup(@()H5T.close(typeID));
    H5T.enum_insert(typeID, 'FALSE', 0);
    H5T.enum_insert(typeID, 'TRUE', 1);

    spaceID = H5S.create_simple(2, fliplr(size(data)), []);
    spaceIDx = onCleanup(@()H5S.close(spaceID));

    attID = H5A.create(objID, attName, typeID, spaceID, 'H5P_DEFAULT');
    attIDx = onCleanup(@()H5A.close(attID));
    H5A.write(attID, typeID, uint32(data));
