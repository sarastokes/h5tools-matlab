function out = readEnumTypeDataset(hdfName, pathName, dsetName)
% Read enumerated type dataset
%
% Description:
%   Read enumerated type dataset and convert to logical, MATLAB class 
%   with a defined enumeration or string array
%
% Syntax:
%   out = h5tools.datasets.readEnumTypeDataset(hdfName, pathName, dsetName)
%
% Inputs:
%   hdfName     char
%       HDF5 file name
%   pathName     char
%       Path of the group where dataset was written
%   dsetName     char
%       Name of the dataset
%
% Output:
%   out     enum, logical or string
%       Contents of the enumerated type dataset
%
% Examples:
%   % Read a dataset named "DS1" within group "/G1"
%   out = h5tools.datasets.readEnumTypeDataset('Test.h5', '/G1', 'DSI');
%
% See Also:
%   h5tools.datasets.makeEnumTypeDataset, h5info, 
%   h5tools.datasets.makeLogicalDataset

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    fullPath = h5tools.util.buildPath(pathName, dsetName);

    data = string(h5read(hdfName, fullPath));

    info = h5info(hdfName, fullPath);
    memberNames = arrayfun(@(x) string(x.Name), info.Datatype.Type.Member);

    if isequal(memberNames, ["FALSE"; "TRUE"])
        % Process as logical
        out = arrayfun(@(x) find(memberNames == x), data);
        out = logical(out - 1);
    elseif h5tools.hasAttribute(hdfName, fullPath, 'EnumClass')
        % Process as MATLAB class enumeration
        enumClass = readatt(hdfName, fullPath, 'EnumClass');
        out = arrayfun(@(x) eval('%s.%s', enumClass, x), data);
    else  % Enumeration that is not related to a MATLAB class
        enumSize = size(data);
        data = data(:);
        idx = strfind(data(1), ".");
        charData1 = char(data(1));
        % Check whether it's a class on MATLAB path
        if ~isempty(idx) && exist(charData1(1:idx(end)), 'class') == 8
            % Convert to MATLAB enum class
            for i = 1:numel(data)
                out = cat(1, out, eval(sprintf("%s", data(i))));
            end
            out = reshape(out, enumSize);
        else % Return as a string array instead
            out = reshape(data, enumSize);
        end
    end