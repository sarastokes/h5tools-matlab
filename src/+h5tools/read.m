function out = read(hdfName, pathName, dsetName, className)
% READ
%
% Syntax:
%   out = read(hdfName, pathName, dsetName)
%   out = read(hdfName, pathName, dsetName, className)
%
% Supported data types:
%   datetime, char, numeric, logical, table, timetable, string, duration
%   cellstr, enum, containers.Map, affine2d, imref2d, simtform2d
%
% See also:
%   h5read, h5tools.readDatasetByType

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    
    arguments
        hdfName         char        {mustBeFile(hdfName)}
        pathName        char
        dsetName        char
        className       char                                = char.empty()
    end

    fullPath = h5tools.util.buildPath(pathName, dsetName);

    % Read the dataset
    data = h5read(hdfName, fullPath);

    % Perform additional class-specific post-processing
    if isempty(className)
        if h5tools.hasAttribute(hdfName, fullPath, 'Class')
            className = h5readatt(hdfName, fullPath, 'Class');
        else
            out = data;
            return
        end
    end

    switch className
        case 'datetime'
            dateFormat = h5readatt(hdfName, fullPath, 'Format');
            out = datetime(data, 'Format', dateFormat);
        case 'logical'
            out = logical(data);
        case 'duration'
            out = seconds(data);
        case 'cellstr'
            out = cellstr(data);
        case {'table', 'timetable'}
            out = struct2table(data);
            colClasses = h5readatt(hdfName, fullPath, 'ColumnClass');
            % TODO: This seems too hard, am I missing something here
            colClasses = strsplit(colClasses, ', '); 
            for i = 1:numel(colClasses)
                if strcmp(colClasses{i}, 'string')                        
                    colName = out.Properties.VariableNames{i};
                    out.(colName) = string(out.(colName));
                end
            end

            if strcmp(className, 'timetable')
                out.Time = seconds(out.Time);
                out = table2timetable(out);
            end
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
            out = data;
    end 
