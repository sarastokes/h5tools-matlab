function writeAttributeByType(hdfFile, hdfPath, varargin)
    % WRITEATTRIBUTEBYTYPE
    %
    % Description:
    %   Ensure datatype compatibility, then write as an attribute 
    %
    % Syntax:
    %   writeAttributeByType(hdfFile, hdfPath, varargin)
    %
    % Inputs:
    %   hdfFile     char
    %       HDF5 file name
    %   hdfPath     char
    %       Path of the dataset/group where attributes will be written
    %   varargin    see below
    %
    % Attributes can be specified in the following ways:
    %   1. A list of one or more key/value pairs
    %       writeAttributeByType(hdfFile, hdfPath, 'A', 1)
    %       writeAttributeByType(hdfFile, hdfPath, 'A', 1, 'B', 2)
    %   2. A containers.Map
    %       attMap = containers.Map('A', 1, 'B', 2)
    %       writeAttributeByType(hdfFile, hdfPath, attMap)
    %   3. A structure
    %       attStruct = struct('A', 1, 'B', 2)
    %       writeAttributeByType(hdfFile, hdfPath, attStruct)
    %   4. A structure or containers.Map followed by key/value pairs
    %       writeAttributeByType(hdfFile, hdfPath, attMap, 'C', 3, 'D', 4) 
    %       writeAttributeByType(hdfFile, hdfPath, attStruct, 'C', 3, 'D', 4)
    % -------------------------------------------------------------------------

    if nargin == 0 || (nargin == 1 && isempty(varargin{1}))
        warning('writeAttributeByType:NoInput',...
            'No inputs provided so no attributes written');
        return
    end
    attMap = getInput(varargin{:});

    % Write the attributes
    k = attMap.keys;
    for i = 1:numel(k)
        attValue = getOutput(k{i});
        h5writeatt(hdfFile, hdfPath, k{i}, attValue);
    end
end

function out = getInputs(varargin)
    if nargin == 1 
        if isa(varargin{1}, 'containers.Map')
            out = varargin{1};
        elseif isstruct(varargin{1})
            out = struct2map(varargin{1});
        end
    else
        out = kv2map(varargin{:})
    end
end

function out = getOutput(data)
    if islogical(data)
        out = int32(data);
    elseif isdatetime(data)
        out = datestr(data);
    elseif isenum(data)
        out = []
    elseif isa(data, {'table', 'struct', 'containers.Map', 'timetable'})
        error('writeAttributeByType',...
            'Structs, tables and maps cannot be written as attributes');
    end
end