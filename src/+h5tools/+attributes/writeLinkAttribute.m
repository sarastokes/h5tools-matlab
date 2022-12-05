function writeLinkAttribute(hdfName, pathName, attName, targetPath)
% WRITELINKATTRIBUTE

    fileID = h5tools.openFile(hdfName, false);

    groupID = H5G.open(fileID, pathName, 'H5P_DEFAULT');
    % TODO: Error handling for creating the group

    spaceID = H5S.create('H5S_SCALAR');
    attID = H5A.create(groupID, attName, 'H5T_STD_REF_OBJ',..
        spaceID, 'H5P_DEFAULT', 'H5P_DEFAULT');
    % TODO: Error handling for creating the attribute
    
    objID = H5O.open(fileID, targetPath, 'H5P_DEFAULT');
    % TODO: Error handling for opening the object

    objInfo = H5O.get_info(objID);
    H5A.write(attID, 'H5T_STD_REF_OBJ', objInfo.addr);

