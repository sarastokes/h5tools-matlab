function out = read(hdfName, pathName, dsetName, className)
% READ
%
% Syntax:
%   out = read(hdfName, pathName, dsetName)
%   out = read(hdfName, pathName, dsetName, className)
%
% Supported data types:
%   datetime, char, numeric, logical, table, timetable, string, duration
%   enum, containers.Map, affine2d, imref2d, simtform2d, cfit
%
% See also:
%   h5read
% -------------------------------------------------------------------------
    
    arguments
        hdfName         char        {mustBeFile(hdfName)}
        pathName        char
        dsetName        char
        className       char                                = char.empty()
    end

    fullPath = h5tools.buildPath(pathName, dsetName);

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
        otherwise
            out = data;
    end 
