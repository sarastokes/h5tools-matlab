function varargout = readatt(hdfName, pathName, varargin)
% Read HDF5 attributes
%
% Description:
%   Read one, multiple or all attributes of a dataset or group
%
% Syntax:
%   out = readatt(hdfName, pathName, varargin)
%
% Input:
%   hdfName             char
%       HDF5 file name
%   pathName            char
%       HDF5 path of the group/dataset containing the HDF5 attribute
%   varargin            chars or strings
%       Attribute name(s) to read or "all" for all attributes
% See examples below for varargin specification
%
% Output:
%   1. If you provide a single attribute name, the output will be that 
%   attribute's value.
%   2. If you provide multiple attribute names and a matching number of 
%   outputs, the attribute values will be assigned in order to each output
%   3. If you provide multiple attribute names and a single output, the 
%   attributes will be returned as containers.Map.
%   4. If you use "all", the attributes will return as a containers.Map, 
%   where the attribute names are the keys for the attribute values.
% The examples are numbered by output type above to demonstrate
%   
%
% Example:
%   % Create an HDF5 file and write attributes to "/GroupOne"
%   h5tools.createFile('File.h5');
%   h5tools.createGroup('File.h5', '/', 'GroupOne');
%   h5tools.writeatt('File.h5', '/GroupOne',...
%       'Attr1', 1:3, 'Attr2', "hello", 'Attr3', 'hej');
%
%   % 1. Return a single attribute
%   out = readatt('File.h5', '/GroupOne', 'Attr1')
%
%   % 2. Read two attributes, return as two outputs
%   [out1, out2] = readatt('File.h5', '/GroupOne', 'Attr1', 'Attr2')
%
%   % 3. Read two attributes, return as containers.Map:
%   out = readatt('File.h5', '/GroupOne', 'Attr1', 'Attr2')
%
%   % 4. Read all attributes, return as containers.Map
%   out = readatt('File.h5', '/GroupOne', 'all')
%
% See Also:
%   h5tools.writeatt, h5readatt, h5tools.getAllAttributeNames

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments 
        hdfName         char    {mustBeFile(hdfName)}
        pathName        char    %{mustBeHdfPath(hdfName, pathName)} 
    end

    arguments (Repeating)
        varargin        char
    end

    if nargin < 3
        error('readatt:InsufficientInputs',...
            'Must provide at least 3 inputs.');
    end

    inputs = convertCharsToStrings(varargin)';

    % Process multiple attribute inputs
    if numel(inputs) > 1
        % Confirm output is either 1 or matches # of inputs
        if nargout > 1 && nargout ~= numel(inputs)
            error('readatt:OutputsDoesNotMatchAttributeNumber',...
                'Must have %s outputs or 1 output to get containers.Map', numel(inputs));
        end

        % Collect the attribute values
        map = containers.Map();
        for i = 1:numel(inputs)
            map(char(inputs(i))) = h5tools.attributes.readAttributeByType(...
                hdfName, pathName, inputs(i));
        end

        % Return as either a map or individual outputs
        if nargout == 1
            varargout{1} = map;
            return
        elseif nargout == numel(inputs)
            for i = 1:numel(inputs)
                varargout{i} = map(char(inputs(i))); %#ok<AGROW> 
            end
            return
        end
    end

    % Process a single attribute input
    if numel(inputs) == 1 
        if nargout > 1
            error('readatt:InvalidOutputCount',...
                'Multiple outputs are not supported when specifying a single attribute name or ''all''');
        end
        if lower(inputs(1)) == "all"
            attNames = h5tools.getAttributeNames(hdfName, pathName);
            map = containers.Map();
            % If there are no attributes, return empty map
            if isempty(attNames)
                varargout{1} = map;
                return
            end
            for i = 1:numel(attNames)
                map(char(attNames(i))) = h5tools.attributes.readAttributeByType(...
                    hdfName, pathName, attNames(i));
            end
            varargout{1} = map;
        else  % A single attribute name was provided
            out = h5tools.attributes.readAttributeByType(...
                hdfName, pathName, inputs(1));
            varargout{1} = out;
        end
    end
end