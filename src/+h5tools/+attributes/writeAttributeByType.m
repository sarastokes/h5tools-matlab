function writeAttributeByType(hdfFile, hdfPath, attName, attValue)
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
    %   attName     char
    %       Name of the attribute
    %   attValue
    %       Data to write for the attribute
    %
    % See also:
    %   writeatt, kv2map
    % -------------------------------------------------------------------------

    arguments
        hdfFile         char        {mustBeFile(hdfFile)}
        hdfPath         char
        attName         char
        attValue
    end

    % Write the attributes
    attValue = getOutput(attValue);
    h5writeatt(hdfFile, hdfPath, attName, attValue);
end

function out = getOutput(data)
    if islogical(data)
        out = int32(data);
    elseif isdatetime(data)
        out = datestr(data); %#ok<DATST> 
    elseif isenum(data)
        out = string(class(data)) + "." + string(data);
    elseif ismember(class(data), {'table', 'struct', 'containers.Map', 'timetable'})
        error('writeAttributeByType:InvalidInput',...
            'Structs, tables and maps cannot be written as attributes');
    else
        out = data;
    end
end