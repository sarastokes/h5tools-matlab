function makeDatetimeAttribute(hdfName, pathName, attName, data)
% Write datetime as an attribute
%
% Description:
%   Writes datetime as string with formatting appended
%
% Syntax:
%   makeDatetimeAttribute(hdfName, pathName, attName, data)
%
% See also:
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