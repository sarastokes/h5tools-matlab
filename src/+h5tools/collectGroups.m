function groupNames = collectGroups(hdfName, sortFlag)
% COLLECTGROUPS
%
% Description:
%   Collect all the group names in an HDF5 file
%
% Syntax:
%   groupNames = collectGroups(hdfName, sortFlag)
%
% Inputs:
%   hdfName         char or H5ML.id
%       HDF5 file name or identifier
%   sortFlag        logical (default=false)
%       Whether to sort the results alphabetically
%
% Outputs:
%   groupNames      string array
%       Full paths of all groups in the HDF5 file
%
% See also:
%   h5tools.collectDatasets, h5tools.collectSoftlinks, h5tools.getAttributeNames

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName                 {mustBeHdfFile(hdfName)}
        sortFlag    logical                                 = false 
    end

    if isa(hdfName, 'H5ML.id')
        rootID = hdfName;
    else
        rootID = h5tools.openFile(hdfName, true);
        rootIDx = onCleanup(@()H5F.close(rootID));
    end

    groupNames = string.empty();
    [~, groupNames] = H5O.visit(rootID, 'H5_INDEX_NAME',... 
        'H5_ITER_NATIVE', @groupVisitFcn, groupNames);
    
    if sortFlag && ~isempty(groupNames)
        groupNames = sort(groupNames);
    end
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