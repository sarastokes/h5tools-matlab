function out = readEnumDataset(hdfName, pathName, dsetName)
% READENUMDATASET
%
% Syntax:
%   out = readEnumDataset(hdfName, pathName, dsetName)
%

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    fullPath = h5tools.util.buildPath(pathName, dsetName);

    data = string(h5read(hdfName, fullPath));

    info = h5info(hdfName, fullPath);
    memberNames = arrayfun(@(x) string(x.Name), info.Datatype.Type.Member);

    if isequal(memberNames, ["FALSE"; "TRUE"])
        out = arrayfun(@(x) find(memberNames == x), data);
        out = logical(out - 1);
    elseif h5tools.hasAttribute(hdfName, fullPath, 'EnumClass')
        enumClass = readatt(hdfName, fullPath, 'EnumClass');
        out = arrayfun(@(x) eval('%s.%s', enumClass, x), data);
    else
        out = data;
    end