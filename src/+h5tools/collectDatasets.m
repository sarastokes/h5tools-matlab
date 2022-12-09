function datasetNames = collectDatasets(hdfName, sortFlag)
% COLLECTDATASETS
%
% Description:
%   Collect all the dataset names (full paths) in an HDF file
%
% Syntax:
%   datasetNames = h5tools.collectDatasets(hdfName, sortFlag)
%
% Inputs:
%   hdfName         char or H5ML.id
%       HDF5 file name or identifier
%   sortFlag        logical (default=false)
%       Whether to sort the results alphabetically
%
% Outputs:
%   datasetNames    string
%       A string array containing the full paths of all 
%       datasets within the HDF5 file
%
% See also:
%   h5tools.collectGroups, h5tools.collectSoftlinks, h5tools.getAttributeNames

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName     char        {mustBeHdfFile(hdfName)}
        sortFlag    logical                                 = false 
    end

    if ~isa(hdfName, 'H5ML.id')
        rootID = h5tools.openFile(hdfName, true);
        rootIDx = onCleanup(@()H5F.close(rootID));
    else
        rootID = hdfName;
    end

    datasetNames = string.empty();
    [~, datasetNames] = H5O.visit(rootID, 'H5_INDEX_NAME',...
        'H5_ITER_NATIVE', @datasetVisitFcn, datasetNames);
        
    if sortFlag && ~isempty(datasetNames)
        datasetNames = sort(datasetNames);
    end
end

function [status, datasetNames] = datasetVisitFcn(rootID, name, datasetNames)
    % Visit function to iterate through an HDF5 file

    objID = H5O.open(rootID, name, 'H5P_DEFAULT');
    info = H5O.get_info(objID);
    H5O.close(objID);

    if string(name) == "."
        status = 0;
        return
    end

    if info.type == H5ML.get_constant_value('H5O_TYPE_DATASET')
        datasetNames = cat(1, datasetNames, "/" + string(name));
    end

    status = 0;
end