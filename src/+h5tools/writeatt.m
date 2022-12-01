function writeatt(hdfName, pathName, varargin)
    % WRITEATT
    %
    % Description:
    %   Writes one or more attributes to a group/dataset
    %
    % Syntax:
    %   writeatt(hdfFile, hdfPath, varargin)
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
    %       h5tools.writeatt(hdfFile, hdfPath, 'A', 1)
    %       h5tools.writeatt(hdfFile, hdfPath, 'A', 1, 'B', 2)
    %   2. A containers.Map
    %       attMap = containers.Map('A', 1, 'B', 2)
    %       h5tools.writeatt(hdfFile, hdfPath, attMap)
    %   3. A structure
    %       attStruct = struct('A', 1, 'B', 2)
    %       h5tools.writeatt(hdfFile, hdfPath, attStruct)
    %   4. A structure or containers.Map followed by key/value pairs
    %       h5tools.writeatt(hdfFile, hdfPath, attMap, 'C', 3, 'D', 4) 
    %       h5tools.writeatt(hdfFile, hdfPath, attStruct, 'C', 3, 'D', 4)
    % -------------------------------------------------------------------------
    arguments
        hdfName         char        {mustBeFile(hdfName)}
        pathName        char
    end

    arguments (Repeating)
        varargin
    end
    
    if nargin == 2 || isempty(varargin{1})
        warning('writeatt:NoInput',...
            'No inputs provided so no attributes written');
        return
    end

    % Parse the inputs
    if nargin == 1
        if isa(varargin{1}, 'containers.Map')
            attMap = varargin{1};
        elseif isstruct(varargin{1})
            attMap = struct2map(varargin{1});
        else
            error('writeatt:InvalidInput',...
                'A single input specifying attributes must be containers.Map or struct');
        end
    else
        attMap = kv2map(varargin{:});
    end

    % Write the attributes
    k = attMap.keys; 
    for i = 1:numel(k)
        fprintf('Writing %s to %s\n', k{i}, pathName);
        h5tools.attributes.writeAttributeByType(...
            hdfName, pathName, k{i}, attMap(k{i}));
    end