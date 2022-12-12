function makeDatetimeAttribute(hdfName, pathName, attName, data)
% Write datetime as an attribute
%
% Description:
%   Writes datetime as string with formatting appended
%
% Syntax:
%   h5tools.attributes.makeDatetimeAttribute(hdfName, pathName, attName, data)
%
% Input:
%   hdfName             char
%       HDF5 file name
%   pathName            char
%       HDF5 path of the group/dataset containing the HDF5 attribute
%   attName             char
%       Attribute name 
%   data                datetime
%       Data to be written to the attribute
%
% Outputs:
%   N/A
%
% Examples:
%   % Write attribute named 'A1' to group '/G1'
%   input = datetime('now'); 
%   out = h5tools.attributes.makeLogicalAttribute('File.h5', '/G1', 'Att1', input)
%
% See Also:
%   h5tools.read, h5read

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments
        hdfName     char        {mustBeHdfFile(hdfName)}
        pathName    char        {mustBeHdfPath(hdfName, pathName)}
        attName     char    
        data        datetime 
    end

    dims = size(data);
    input = data(:);

    output = string.empty();
    for i = 1:numel(input)
        output = cat(1, output, string(datestr(input(i))) + sprintf(" (Format=%s)", input(i).Format));
    end
    
    output = reshape(output, dims);
    h5writeatt(hdfName, pathName, attName, output);