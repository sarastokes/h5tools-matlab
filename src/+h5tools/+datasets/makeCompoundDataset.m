function makeCompoundDataset(hdfName, pathName, dsetName, data)
% References:
%   Largely adapted from NeurodataWithoutBorders (matnwb)
% -------------------------------------------------------------------------

    arguments
        hdfName         char        {mustBeFile(hdfName)}
        pathName        char
        dsetName        char
        data
    end

    fullPath = h5tools.buildPath(pathName, dsetName);
    fileID = h5tools.openFile(hdfName, false);
    fileIDx = onCleanup(@(x)H5F.close(fileID));

    if istable(data)
        data = table2struct(data);
    elseif isa(data, 'containers.Map')
        names = keys(data);
        vals = values(data, names);
        s = struct();
        for i=1:length(names)
            s.(str2validName(names{i})) = vals{i};
        end
        data = s;
    end

    names = fieldnames(data);
    if isempty(names)
        nRows = 0;
    elseif isscalar(data)
        if ischar(data.(names{1}))
            nRows = 1;
        else
            nRows = length(data.(names{1}));
        end
    else
        nRows = length(data);
        s = struct();
        for i=1:length(names)
            s.(names{i}) = {data.(names{i})};
        end
        data = s;
    end

    % Check for references and construct type IDs
    classes = cell(length(names), 1);
    typeIDs = cell(size(classes));
    sizes = zeros(size(classes));
    for i = 1:length(names)
        val = data.(names{i});
        if iscell(val) && ~iscellstr(val)
            data.(names{i}) = [val{:}];
            val = val{1};
        end

        classes{i} = class(val);
        typeIDs{i} = getDataType(classes{i});
        sizes(i) = H5T.get_size(typeIDs{i});
    end

    typeID = H5T.create('H5T_COMPOUND', sum(sizes));
    typeIDx = onCleanup(@()H5T.close(typeID));
    % Insert columns into compound type
    for i = length(names)
        H5T.insert(typeID, names{i}, sum(sizes(1:i-1)), typeIDs{i});
    end

    % Close custom type IDs (errors if char base type)
    isH5ml = typeIDs(cellfun('isclass', typeIDs, 'H5ML.id'));
    for i = 1:length(isH5ml)
        H5T.close(isH5ml{i});
    end
    % Optimizes for type size
    H5T.pack(typeID);

    
    % convert logical values
    boolNames = names(strcmp(classes, 'logical'));
    for iField = 1:length(boolNames)
        data.(boolNames{iField}) = strcmp('TRUE', data.(boolNames{iField}));
    end
    
    %transpose numeric column arrays to row arrays
    % reference and str arrays are handled below
    transposeNames = names;
    for i=1:length(transposeNames)
        nm = transposeNames{i};
        if iscolumn(data.(nm))
            data.(nm) = data.(nm) .';
        end
    end

    try
        spaceID = H5S.create_simple(1, nRows, []);
        spaceIDx = onCleanup(@()H5S.close(spaceID));
        dsetID = H5D.create(fileID, fullPath, typeID, spaceID, 'H5P_DEFAULT');
        dsetIDx = onCleanup(@()H5D.close(dsetID));
    catch ME
        if contains(ME.message, 'name already exists')
            dsetID = H5D.open(fileID, fullPath);
            dsetIDx = onCleanup(@()H5D.close(dsetID));
            create_plist = H5D.get_create_plist(dsetID);
            edit_spaceID = H5D.get_space(dsetID);
            [~, edit_dims, ~] = H5S.get_simple_extent_dims(edit_spaceID);
            layout = H5P.get_layout(create_plist);
            is_chunked = layout == H5ML.get_constant_value('H5D_CHUNKED');
            is_same_dims = all(edit_dims == nRows);
    
            if ~is_same_dims
                if is_chunked
                    H5D.set_extent(dsetID, dims);
                else
                    warning('Attempted to change size of continuous compound `%s`.  Skipping.',...
                        fullPath);
                end
            end
            H5P.close(create_plist);
            H5S.close(edit_spaceID);
        else
            rethrow(ME);
        end
    end
    H5D.write(dsetID, typeID, spaceID, spaceID, 'H5P_DEFAULT', data);
    H5D.close(dsetID);
    H5S.close(spaceID);
end

function id = getDataType(type)
    if any(strcmp(type, {'char' 'cell' 'datetime'}))
        % modify id to set the proper size
        id = H5T.copy('H5T_C_S1');
        H5T.set_size(id, 'H5T_VARIABLE');
        H5T.set_cset(id, H5ML.get_constant_value('H5T_CSET_UTF8'))
    elseif strcmp(type, 'double')
        id = 'H5T_IEEE_F64LE';
    elseif strcmp(type, 'single')
        id = 'H5T_IEEE_F32LE';
    elseif strcmp(type, 'logical')
        id = H5T.enum_create('H5T_STD_I8LE');
        H5T.enum_insert(id, 'FALSE', 0);
        H5T.enum_insert(id, 'TRUE', 1);
    elseif startsWith(type, {'int' 'uint'})
        prefix = 'H5T_STD_';
        pattern = 'int%d';
        if type(1) == 'u'
            pattern = ['u' pattern];
        end
        suffix = sscanf(type, pattern);
        
        switch suffix
            case 8
                suffix = '8LE';
            case 16
                suffix = '16LE';
            case 32
                suffix = '32LE';
            case 64
                suffix = '64LE';
        end
        
        if type(1) == 'u'
            suffix = ['U' suffix];
        else
            suffix = ['I' suffix];
        end
        
        id = [prefix suffix];
    else
        error('Type `%s` is not a supported raw type', type);
    end
end

function valid = str2validName(propname, prefix)
    % STR2VALIDNAME
    % Converts the property name into a valid matlab property name.
    % propname: the offending propery name
    % prefix: optional prefix to use instead of the ambiguous "dyn"
    if ~iscell(propname) && isvarname(propname)
        valid = propname;
        return;
    end
    
    if nargin < 2 || isempty(prefix)
        prefix = 'dyn_';
    else
        if ~isvarname(prefix)
            warning('Prefix contains invalid variable characters.  Reverting to "dyn"');
            prefix = 'dyn_';
        end
    end
    
    % general regex /[a-zA-Z]\w*/
    if ~iscell(propname)
        propname = {propname};
    end
    valid = cell(size(propname));
    for i=1:length(propname)
        p = propname{i};
        %find all alphanumeric and '_' characters
        validIdx = isstrprop(p, 'alphanum');
        validIdx(strfind(p, '_')) = true;
        %replace all invalid with '_'
        p(~validIdx) = '_';
        if isempty(p) || ~isstrprop(p(1), 'alpha') || iskeyword(p)
            p = [prefix p]; %#ok<AGROW> 
        end
        valid{i} = p(1:min(length(p),namelengthmax));
    end
    
    if isscalar(valid)
        valid = valid{1};
    end
end