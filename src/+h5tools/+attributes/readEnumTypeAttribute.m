function out = readEnumTypeAttribute(hdfName, pathName, attName)
% Read enumerated type attribute
%
% Description:
%   Read an enumerated type attribute and convert to logical, MATLAB class
%   with a defined enumeration or string array
%
% Syntax:
%   out = h5tools.attributes.readEnumTypeAttribute(hdfName, pathName, attName)
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
%   out     enum, logical or string
%       Contents of the enumerated type dataset
%
% Examples:
%   % Read attribute of group '/G1' named 'A1' 
%   out = h5tools.attributes.readAttributeByType('File.h5', '/G1', 'Att1')
%
% See Also:
%   h5tools.datasets.writeEnumTypeAttribute, h5info, h5readatt

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName                 {mustBeHdfFile(hdfName)}
        pathName    char        {mustBeHdfPath(hdfName, pathName)}
        attName     char
    end

    data = string(h5readatt(hdfName, pathName, attName));

    % Get attribute datatype information
    info = h5info(hdfName, pathName);
    idx = find(arrayfun(@(x)isequal(lower(x.Name),... 
        lower(attName)), info.Attributes));
    memberNames = arrayfun(@(x) string(x.Name),... 
        info.Attributes(idx).Datatype.Type.Member);

    if numel(memberNames) == 2 && all(contains(memberNames, ["FALSE", "TRUE"]))
        % Process as logical
        out = arrayfun(@(x) find(memberNames == x), data);
        out = logical(out - 1);
    else % Process as MATLAB class enumeration
        enumSize = size(data);
        data = data(:);
        idx = strfind(data(1), ".");
        charData1 = char(data(1));
        % Check whether it's a class on MATLAB path
        if ~isempty(idx) && exist(charData1(1:idx(end)), 'class') == 8
            % Convert to MATLAB enum class
            out = [];
            for i = 1:numel(data)
                out = cat(1, out, eval(sprintf("%s", data(i))));
            end
            out = reshape(out, enumSize);
        else % Return as a string array instead
            out = reshape(data, enumSize);
        end
    end