function out = readAttributeByType(hdfName, pathName, attName)
% Read a single HDF5 attribute
%
% Description:
%   Read a single HDF5 attribute and perform datatype-specific processing
%
% Syntax:
%   out = h5tools.attributes.readAttributeByType(hdfName, pathName, attName)
%
% Input:
%   hdfName             char
%       HDF5 file name
%   pathName            char
%       HDF5 path of the group/dataset containing the HDF5 attribute
%   attName             char
%       Attribute name to read
%
% Output:
%   value   
%       Attribute value
%
% See also:
%   h5tools.readatt, h5readatt, h5tools.attributes.writeAttributeByType

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments 
        hdfName         char    {mustBeHdfFile(hdfName)} 
        pathName        char    {mustBeHdfPath(hdfName, pathName)}
        attName         char 
    end

    import h5tools.datatypes.Classes

    % Begin with h5readatt and post-process as needed
    data = h5readatt(hdfName, pathName, attName);

    dataType = Classes.getByPath(hdfName, pathName, attName);

    if dataType == Classes.ENUM 
        out = h5tools.attributes.readEnumTypeAttribute(hdfName, pathName, attName);
        return
    end
    
    % Check for datetime
    if isstring(data) && all(contains(data(:), " (Format="))
        txt = extractBefore(data, " (Format=");
        fmt = extractBetween(data, "(Format=", ")");
        out = arrayfun(@(x,y) datetime(x, "format", y), txt, fmt);
        return
    end

    % Otherwise return as is
    out = data;