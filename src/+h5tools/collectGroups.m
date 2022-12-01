function groupNames = collectGroups(hdfFile)
    % COLLECTGROUPS
    %
    % Description:
    %   Collect all the group names in an HDF5 file
    %
    % Syntax:
    %   groupNames = collectGroups(hdfFile)
    %
    % Inputs:
    %   hdfFile         char or H5ML.id
    %       HDF5 file name or identifier
    %
    % Outputs:
    %   groupNames      string array
    %       Full paths of all groups in the HDF5 file
    %
    % History:
    %   16Oct2022 - SSP
    % ---------------------------------------------------------------------
    if isa(hdfFile, 'H5ML.id')
        rootID = hdfFile;
    else
        rootID = h5tools.openFile(hdfFile, true);
        rootIDx = onCleanup(@()H5F.close(rootID));
    end

    groupNames = string.empty();
    [~, groupNames] = H5O.visit(rootID, 'H5_INDEX_NAME',... 
        'H5_ITER_NATIVE', @groupVisitFcn, groupNames);
end

function [status, groupNames] = groupVisitFcn(rootID, name, groupNames)
    objID = H5O.open(rootID, name, 'H5P_DEFAULT');
    info = H5O.get_info(objID);
    H5O.close(objID);
    
    if string(name) == "."
        status = 0;
        return
    end

    if info.type == H5ML.get_constant_value('H5O_TYPE_GROUP')
        groupNames = cat(1, groupNames, "/" + string(name));
    end

    status = 0;
end