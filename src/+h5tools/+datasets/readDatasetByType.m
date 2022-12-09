function out = readDatasetByType(hdfName, pathName, dsetName)
% READDATASETBYTYPE
%
% Description:
%   Reads dataset and assigns post-processing, if necessary
%
% Syntax:
%   out = read(hdfName, pathName, dsetName)

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    import h5tools.datatypes.DatatypeClasses

    fullPath = h5tools.util.buildPath(pathName, dsetName);
    data = h5read(hdfName, fullPath); 
    
    if h5tools.hasAttribute(hdfName, fullPath, 'Class')
        matlabClass = h5tools.readatt(hdfName, fullPath, 'Class');
    else % Numeric types, string, char
        matlabClass = [];
    end 

    % Return numeric data immediately
    if isnumeric(data) && isempty(matlabClass)
        out = data;
        return
    end

    % Get HDF5 and MATLAB classes
    dataClass = DatatypeClasses.getByPath(hdfName, fullPath);

    % Return string/char immediately, unless a placeholder
    if dataClass == DatatypeClasses.STRING
        if isempty(matlabClass) && isstring(data) && isscalar(data) ... 
                && ismember(data, ["containers.Map", "struct"])
            % Read as compound mapped to attributes
            out = h5tools.readatt(hdfName, fullPath, 'all');
            if isequal(data, "struct")
                out = map2struct(out);
            end
            return
        % The remaining placeholders are equal to the className
        elseif isempty(matlabClass) && ~isequal(data, matlabClass)  
            out = data;
            return
        end
    end

    % Handle compound together
    if dataClass == DatatypeClasses.COMPOUND 
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
        end
        return
    end

    % TODO: Handle enumerated types

    % Miscellaneous MATLAB classes
    switch matlabClass 
        case 'datetime'
            dateFormat = h5readatt(hdfName, fullPath, 'Format');
            out = datetime(data, 'Format', dateFormat);
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



