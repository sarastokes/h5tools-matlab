function mustBeHdfFile(input)
    % MUSTBEHDFFILE
    %
    % Description:
    %   Validates whether input is an HDF5 file or H5ML.id
    %
    % Syntax:
    %   mustBeHdfFile(input)
    %
    % Todo:
    %   Check to see if it's possible to confirm H5ML.id is a file 
    % ---------------------------------------------------------------------
    
    if istext(input)
        if ~isfile(input) || ~endsWith(input, '.h5')
            eid = 'mustBeHdfFile:InvalidFile';
            msg = 'File %s not found, input must be valid file name ending with .h5 or an H5ML.id';
            throwAsCaller(MException(eid, msg));
        end
        return
    end

    % If input wasn't a file name, check whether it's an identifier
    if ~isa(input, 'H5ML.id')
        eid = 'mustBeHdfFile:InvalidInput';
        msg = 'Input must be a valid HDF5 file name or an H5ML.id';
        throwAsCaller(MException(eid, msg));
    end