function out = readDatasetByType(hdfName, pathName, dsetName)
% Reads HDF5 dataset with type-specific processing
%
% Description:
%   Reads dataset and handles post-processing, if necessary
%
% Syntax:
%   out = h5tools.datasets.readDatasetByType(hdfName, pathName, dsetName)
%
% Inputs:
%   hdfName     char
%       HDF5 file name
%   pathName     char
%       Path of the group where dataset was written
%   dsetName     char
%       Name of the dataset
%
% Outputs:
%   data    
%       Contents of the HDF5 dataset
%
% Examples:
%   % Read a dataset named "DS1" within group "/G1"
%   out = h5tools.datasets.readDatasetByType('Test.h5', '/G1', 'DSI');
%
% See Also:
%   h5tools.read, h5read

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName         char        {mustBeHdfFile(hdfName)}
        pathName        char        {mustBeHdfPath(hdfName, pathName)}
        dsetName        char
    end

    import h5tools.datatypes.Classes

    fullPath = h5tools.util.buildPath(pathName, dsetName);
    data = h5read(hdfName, fullPath); 
    
    if h5tools.hasAttribute(hdfName, fullPath, 'Class')
        matlabClass = h5tools.readatt(hdfName, fullPath, 'Class');
        if ismember(string(matlabClass), ["string", "char", "double", "single", "uint8", "uint16", "uint32", "uint64", "int64", "int32", "int16", "int8"])
            matlabClass = [];
        end
    else % Numeric types, string, char
        matlabClass = [];
    end 

    % Return numeric data immediately
    if isnumeric(data) && isempty(matlabClass)
        out = data;
        return
    end

    % Get HDF5 and MATLAB classes
    dataClass = Classes.getByPath(hdfName, fullPath);

    % Return string/char immediately, unless a placeholder
    if dataClass == Classes.STRING
        if isempty(matlabClass) && isstring(data)  
            if isscalar(data) && ismember(data, ["containers.Map", "struct"])
                % Read as compound mapped to attributes
                out = h5tools.readatt(hdfName, fullPath, 'all');
                if isequal(data, "struct")
                    out = map2struct(out);
                end
                return
            elseif isscalar(data) && isequal(data, "datetime")
                out = h5tools.datasets.readDateDataset(hdfName, pathName, dsetName);
                return
            % The remaining placeholders are equal to the className
            elseif ~isequal(data, matlabClass)  
                out = data;
                return
            end
        end
    end

    % Handle compound together
    if dataClass == Classes.COMPOUND 
        out = h5tools.datasets.readCompoundDataset(...
            hdfName, pathName, dsetName);
        switch matlabClass
            case 'struct'
                out = table2struct(out);
            case 'timetable'
                out.Time = seconds(out.Time);
                out = table2timetable(out);
            case 'containers.Map'
                out = struct2map(table2struct(data));
            case 'table'
                if h5tools.hasAttribute(hdfName, fullPath, 'RowNames')
                    out.Properties.RowNames = ...
                        h5tools.readatt(hdfName, fullPath, 'RowNames');
                end
                if h5tools.hasAttribute(hdfName, fullPath, 'VariableUnits');
                    out.Properties.VariableUnits = ... 
                        h5tools.readatt(hdfName, fullPath, 'VariableUnits');
                end
        end
        return
    end

    % Handle enumerated types
    if dataClass == Classes.ENUM 
        out = h5tools.datasets.readEnumTypeDataset(...
            hdfName, pathName, dsetName);
        return 
    end

    % Return any other standard types that weren't caught before
    if isempty(matlabClass)
        out = data;
        return
    end
    
    % Miscellaneous MATLAB classes
    switch matlabClass 
        case 'datetime'
            % dateFormat = h5readatt(hdfName, fullPath, 'Format');
            % out = datetime(data, 'Format', dateFormat);
            out = h5tools.datasets.readDateDataset(...
                hdfName, pathName, dsetName);
        case 'logical'
            out = logical(data);
        case 'duration'
            out = seconds(data);
        case 'cellstr'
            out = cellstr(data);
        case 'enum'
            enumClass = h5readatt(hdfName, fullPath, 'EnumClass');
            try
                eval(sprintf('out = %s.%s;', enumClass, data));
            catch ME 
                if strcmp(ME.identifier, 'MATLAB:undefinedVarOrClass')
                    warning('read:UnknownEnumerationClass',...
                        'The enumeration class %s could not be found, returning char', enumClass);
                elseif strcmp(ME.identifier, 'MATLAB:subscripting:classHasNoPropertyOrMethod')
                    warning('read:UnknownEnumerationType',...
                        'The class %s does not contain %s, returning char', enumClass, data);
                else
                    rethrow(ME);
                end
            end 
        case 'affine2d'
            out = affine2d(data);
        case 'simtform2d'
            T = h5readatt(hdfName, fullPath, 'Translation')';
            S = h5readatt(hdfName, fullPath, 'Scale');
            R = h5readatt(hdfName, fullPath, 'RotationAngle');
            out = simtform2d(S, R, T);
        case 'imref2d'
            imageSize = h5readatt(hdfName, fullPath, 'ImageSize')';
            pixelExtentX = h5readatt(hdfName, fullPath, 'PixelExtentInWorldX');
            pixelExtentY = h5readatt(hdfName, fullPath, 'PixelExtentInWorldY');
            if pixelExtentX ~= 1 || pixelExtentY ~= 1
                out = imref2d(imageSize, pixelExtentX, PixelExtentInWorldX);
                return
            end
            xWorldLimits = h5readatt(hdfName, fullPath, 'XWorldLimits');
            yWorldLimits = h5readatt(hdfName, fullPath, 'YWorldLimits');
            if xWorldLimits(2) ~= (imageSize(2)+0.5) ...
                    || yWorldLimits(2) ~= (imageSize(1) + 0.5)
                out = imref2d(imageSize, xWorldLimits, yWorldLimits);
                return
            end
            out = imref2d(imageSize);
        otherwise
            warning('readDatasetByType:UnknownClass',... 
                'MATLAB class %s was unrecognized for %s', matlabClass, fullPath);
            out = data;      
    end



