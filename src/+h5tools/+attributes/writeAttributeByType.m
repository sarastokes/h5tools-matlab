function writeAttributeByType(hdfName, pathName, attName, attValue)
% Writes an HDF5 attribute with type-specific processing
%
% Description:
%   Ensure datatype compatibility, then writes as an attribute of a 
%   HDF5 dataset or group.
%
% Syntax:
%   h5tools.attributes.writeAttributeByType(hdfName, pathName, attName, attValue)
%
% Inputs:
%   hdfName     char
%       HDF5 file name
%   pathName     char
%       Path of the dataset/group where attributes will be written
%   attName     char
%       Name of the attribute
%   attValue
%       Data to write for the attribute
%
% Outputs:
%   N/A
%
% Examples:
%   % Write an attribute called 'A1' to group '/G1'
%   input = 'test';
%   h5tools.attributes.writeAttributeByType('File.h5', '/G1', 'A1', input)
%
% See Also:
%   h5tools.writeatt, h5writeatt, h5tools.attributes.readAttributeByType

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName                     {mustBeHdfFile(hdfName)}
        pathName        char        %{mustBeHdfPath(hdfName, pathName)}
        attName         char
        attValue
    end

    % Write the attributes
    if islogical(attValue)
        h5tools.attributes.makeLogicalAttribute(hdfName, pathName, attName, attValue);
    elseif isenum(attValue)
        h5tools.attributes.makeEnumTypeAttribute(hdfName, pathName, attName, attValue);
    elseif isdatetime(attValue)
        h5tools.attributes.makeDatetimeAttribute(...
            hdfName, pathName, attName, attValue);
    elseif ismember(class(attValue), {'table', 'struct', 'containers.Map', 'timetable'})
        error('writeAttributeByType:InvalidInput',...
            'Structs, tables and maps cannot be written as attributes');
    else
        attValue = getOutput(attValue);
        h5writeatt(hdfName, pathName, attName, attValue);
    end
end

function out = getOutput(data)
    % Convert data to an HDF5-writable format
    if iscellstr(data)
        out = string(data);
        warning("writeAttributeByType:Cellstr",...
            "Cellstr will be converted to string and read back in as string");
    elseif isduration(data)
        out = seconds(data);
        warning("writeAttributeByType:Duration",...
            "Duration will be converted to double with seconds and read in as double");
    else
        out = data;
    end
end