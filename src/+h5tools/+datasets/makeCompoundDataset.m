function makeCompoundDataset(hdfName, pathName, dsetName, data)
% MAKECOMPOUNDDATASET
%
% Description:
%   Adds table/struct to HDF5 file as compound
%
% Syntax:
%   h5tools.makeCompoundDataset(hdfName, pathName, dsetName, data);
%
% See also:
%   h5tools.write, h5tools.datasets.writeDatasetByType

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName         char    {mustBeFile(hdfName)} 
        pathName        char 
        dsetName        char 
        data            {mustBeA(data, ["struct", "table", "timetable", "containers.Map"])}
    end

    fullPath = h5tools.util.buildPath(pathName, dsetName);

    % Record original class and column classes
    dataClass = class(data);
    if istimetable(data)
        data = timetable2table(data);
        data.Time = seconds(data.Time);
    end
    columnClass = [];
    colsToFix = [];
    if istable(data) || istimetable(data)
        for i = 1:size(data, 2)
            if i == 1 && strcmp(dataClass, 'timetable') %#ok<STISA> 
                columnClass = 'duration';
                continue
            end
            if iscellstr(data{:,i})
                % fix for cellstr is being transposed oddly 
                columnClass = [columnClass, ', ', 'cellstr']; %#ok<*AGROW> 
                colsToFix = cat(2, colsToFix, i);
            else
                columnClass = [columnClass, ', ', class(data{:,i})];  
            end
        end

        columnClass = columnClass(3:end); % FIX
        for i = 1:numel(colsToFix)
            % Am I missing something, why is this so hard
            colData = string(data{:,colsToFix}')';
            varName = data.Properties.VariableNames{colsToFix(i)};
            data = removevars(data, colsToFix(i));
            data.(varName) = colData;
            data = movevars(data, varName, 'Before', colsToFix(i));
        end
        nDims = height(data);
        data = table2struct(data);
    else
        f = fieldnames(data);
        nElements = zeros(1, numel(f));
        for i = 1:numel(f)
            columnClass = [columnClass, ', ', class(data.(f{i}))];
            nElements(i) = numel(data.(f{i}));
        end
        if numel(unique(nElements)) > 1
            error('makeCompoundDataset:DifferentFieldSizes',...
                'All fields in the structure must have the same number of elements');
        end
        nDims = max(nElements);
        % TODO: Should they be equal
    end

    fileID = h5tools.openFile(hdfName, false);
    fileIDx = onCleanup(@()H5F.close(fileID));

    names = fieldnames(data);

    S = struct();
    for i = 1:length(names) 
        S.(names{i}) = {data.(names{i})};
    end
    data = S;

    typeIDs = cell(length(names), 1);
    sizes = zeros(size(typeIDs));

    for i = 1:length(names)
        val = data.(names{i});
        if isdatetime(val)
            data.(names{i}) = string(data.(names{i}));
            val = string(val);
        elseif iscell(val) && ~isstring(val)
            data.(names{i}) = [val{:}];
            val = val{1};
        elseif isstring(val) && numel(val) == 1
            val = char(val);
        end
        typeIDs{i} = getDataType(val);
        sizes(i) = H5T.get_size(typeIDs{i});
    end

    typeID = H5T.create('H5T_COMPOUND', sum(sizes));
    typeIDx = onCleanup(@(x)H5T.close(typeID));
    for i = 1:length(names)
        % Insert columns into compound type
        H5T.insert(typeID, names{i}, sum(sizes(1:i-1)), typeIDs{i});
    end
    % Optimizes for type size
    H5T.pack(typeID);

    spaceID = H5S.create_simple(1, nDims, []);
    spaceIDx = onCleanup(@()H5S.close(spaceID));
    if h5tools.exist(fileID, fullPath)
        warning('found and replaced %s', fullPath);
        h5tools.deleteObject(hdfName, fullPath);
    end
    dsetID = H5D.create(fileID, fullPath, typeID, spaceID, 'H5P_DEFAULT');
    dsetIDx = onCleanup(@()H5D.close(dsetID));

    for i = 1:numel(names)
        if isdatetime(data.(names{i}))
            data.(names{i}) = cellstr(data.(names{i}));
        end
    end

    H5D.write(dsetID, typeID, spaceID, spaceID, 'H5P_DEFAULT', data);

    % Write original class and column classes attributes
    h5tools.writeatt(hdfName, fullPath, 'Class', dataClass,...
        'ColumnClass', columnClass);
end

function typeID = getDataType(var)
    % GETDATATYPE
    %
    % Description:
    %   Maps MATLAB data types to H5 data types (incomplete)
    %
    % Syntax:
    %   typeID = getDataType(var)
    % -------------------------------------------------------------
    varType = class(var);

    if contains(varType, 'int')
    end

    if isa(var, 'double')
        typeID = 'H5T_IEEE_F64LE';
    elseif ismember(class(var), {'char', 'cell', 'datetime'})
        typeID = H5T.copy('H5T_C_S1');
        H5T.set_size(typeID, 'H5T_VARIABLE');
        H5T.set_cset(typeID, H5ML.get_constant_value('H5T_CSET_ASCII'));
    elseif isstring(var) && numel(var) == 1
        typeID = H5T.copy('H5T_C_S1');
        H5T.set_size(typeID, 'H5T_VARIABLE');
        H5T.set_cset(typeID, H5ML.get_constant_value('H5T_CSET_UTF8'));
    elseif islogical(var)
        typeID = 'H5T_STD_I32LE';
    elseif isa(var, 'int8')
        typeID = 'H5T_STD_I8LE';
    elseif isa(var, 'uint8')
        typeID = 'H5T_STD_U8LE';
    elseif isa(var, 'int16')
        typeID = 'H5T_STD_I16LE';
    elseif isa(var, 'uint16')
        typeID = 'H5T_STD_U16LE';
    elseif isa(var, 'int32')
        typeID = 'H5T_STD_I32LE';
    elseif isa(var, 'uint32')
        typeID = 'H5T_STD_U32LE';
    elseif isa(var, 'int64')
        typeID = 'H5T_STD_I64LE';
    elseif isa(var, 'uint64')
        typeID = 'H5T_STD_U64LE';
    elseif isa(var, 'single')
        typeID = 'H5T_IEEE_F32LE';
    else
        assignin('base', 'var', var);
        error('getDataType:UnrecognizedDataType',...
            'Data type %s was not recognized for makeCompoundDataset', class(var));
    end
end