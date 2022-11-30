function datasetNames = collectDatasets(hdfName)
    % COLLECTDATASETS
    %
    % Description:
    %   Collect all the dataset names (full paths) in an HDF file
    %
    % Syntax:
    %   datasetNames = collectDatasets(hdfName)
    %
    % Inputs:
    %   hdfName         either file name or H5ML.id
    %
    % Outputs:
    %   datasetNames    string
    %
    % History:
    %   20Nov2022 - SSP
    % -------------------------------------------------------------
    if ~isa(hdfName, 'H5ML.id')
        rootID = h5tools.openFile(hdfName, true);
        rootIDx = onCleanup(@()H5F.close(rootID));
    else
        rootID = hdfName;
    end

    datasetNames = string.empty();
    [~, datasetNames] = H5O.visit(rootID, 'H5_INDEX_NAME',...
        'H5_ITER_NATIVE', @datasetVisitFcn, datasetNames);
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