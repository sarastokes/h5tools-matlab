function out = readAttributeLink(hdfName, pathName, attName)
% READATTRIBUTELINK
%
% Description:
%   Read object references from an attribute. Very similar to 
%   h5ex_t_objrefatt until I figure out exactly what info is most useful
%   to return about attribute references
% -------------------------------------------------------------------------

    % Open HDF5 file, read-only
    fileID = h5tools.openFile(hdfName);

    % Open dataset or group
    try 
        rootID = H5G.open(fileID, pathName);
    catch
        rootID = H5D.open(fileID, pathName);
    end

    % Open the attribute to get the type class
    attID = H5A.open(rootID, pathName, 'H5P_DEFAULT');
    typeID = H5A.get_type(attID);
    attClass = H5T.get_class(typeID);

    % Confirm attribute is a link
    if attClas ~= H5ML.get_constant_value('H5T_REFERENCE')
        error("readAttributeLink:NotALink",...
            "%s at %s is not a link", attName, pathName);
    end

    % Get the dataspace
    spaceid = H5A.get_space(attr);
    [~, dims, ~] = H5S.get_simple_extent_dims(spaceID);
    dims = fliplr(dims);

    % Read the data
    rdata = H5A.read(attr, 'H5T_STD_REF_OBJ');

    % Output the data to the screen
    for i = 1:dims(i)
        fprintf('%s[%d]:\n  ->', attName, i);

        % Open the referenced object, get it's name and type
        obj = H5R.dereference(rootID, 'H5R_OBJECT', rdata(:,i));
        objType = H5R.get_obj_type(rootID, 'H5R_OBJECT', rdata(:,i));

        % Retrieve the name
        name = H5I.get_name(obj);

        % Print the object type
        switch objType 
            case H5ML.get_constant_value('H5G_GROUP')
                fprintf('Group');
                H5G.close(obj);
            case H5ML.get_constant_value('H5D_DATASET')
                fprintf('Dataset');
                H5D.close(obj);
            case H5ML.get_constant_value('H5G_TYPE')
                fprintf('Named Datatype');
                H5T.close(obj);
        end
    end
H5A.close(attID);
H5D.close(dsetID);
H5S.close(spaceID);
H5F.close(fileID);