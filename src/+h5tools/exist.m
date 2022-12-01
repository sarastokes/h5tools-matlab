function tf = exist(hdfName, pathName)
    % EXISTS
    % 
    % Check if group or dataset exists in file
    %
    % Syntax:
    %   tf = exist(fileName, pathName)
    %
    % Inputs:
    %   fileName        char H5 file name OR H5ML.id
    % -------------------------------------------------------------
    arguments
        hdfName             char            {mustBeFile(hdfName)}
        pathName            char
    end

    if isa(hdfName, 'H5ML.id')
        tf = H5L.exists(hdfName, pathName, 'H5P_DEFAULT');
    else
        fileID = h5tools.openFile(hdfName, false);
        fileIDx = onCleanup(@()H5F.close(fileID));
        try
            tf = H5L.exists(fileID, pathName, 'H5P_DEFAULT');
        catch ME
            if contains(ME.message, 'component not found')
                error('Parent group not found: %s', pathName);
            else
                rethrow(ME);
            end
        end
    end