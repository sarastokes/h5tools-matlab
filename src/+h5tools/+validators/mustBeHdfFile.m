function mustBeHdfFile(input)
    % MUSTBEHDFFILE
    %
    % Description:
    %   Validates whether input is an HDF5 file or H5ML.id for a file
    %
    % Syntax:
    %   mustBeHdfFile(input)
    %
    % ---------------------------------------------------------------------
    
    if istext(input)
        if ~isfile(input) || ~endsWith(input, '.h5')
            eid = 'mustBeHdfFile:InvalidFile';
            msg = 'File %s not found, input must be valid file name ending with .h5 or an H5ML.id';
            throwAsCaller(MException(eid, msg));
        end
        return
    end

    if isa(input, 'H5ML.id')
        objType = H5I.get_type(input);
        if objType ~= H5ML.get_constant_value('H5I_FILE')
            eid = 'mustBeFileID:InvalidH5MLID';
            msg = 'H5ML.id was not a file identifier';
            throwAsCaller(MException(eid, msg));
        end
        return
    end

    % If input wasn't an HDF5 file name or a file H5ML.id, it's invalid
    eid = 'mustBeHdfFile:InvalidInput';
    msg = 'Input must be a valid HDF5 file name or a file H5ML.id';
    throwAsCaller(MException(eid, msg));