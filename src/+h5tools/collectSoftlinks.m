function linkNames = collectSoftlinks(hdfName)
    % COLLECTALLSOFTLINKS
    %
    % Description:
    %   Returns all soft links in an HDF5 file
    %
    % Syntax:
    %   linkNames = collectAllSoftlinks(hdfName)
    %
    % Inputs:
    %   hdfName         HDF file name or H5ML.id
    %
    % Outputs:
    %   linkNames       string array
    %       The full hdfPaths and names of all softlinks
    %
    % History:
    %   21Nov2022 - SSP
    % ---------------------------------------------------------------------
    
    if isa(hdfName, 'H5ML.id')
        rootID = hdfName;
    else
        rootID = h5tools.openFile(hdfName, true);
        rootIDx = onCleanup(@()H5F.close(rootID));
    end
    
    linkNames = string.empty();
    [~, linkNames] = H5L.visit(rootID, 'H5_INDEX_NAME',...
        'H5_ITER_NATIVE', @softlinkVisitFcn, linkNames);
end

function [status, dataOut] = softlinkVisitFcn(groupID, name, dataIn)
    % LINKVISITFCN
    %
    % Description:
    %   Iterator function for visiting all links in an HDF5 file and 
    %   returning the names of soft links
    % ---------------------------------------------------------------------

    info = H5L.get_info(groupID, name, 'H5P_DEFAULT');

    if isequal(info.type, H5ML.get_constant_value('H5L_TYPE_SOFT'))
        dataOut = cat(1, dataIn, "/" + string(name));
    else
        dataOut = dataIn;
    end

    status = 0;
end
