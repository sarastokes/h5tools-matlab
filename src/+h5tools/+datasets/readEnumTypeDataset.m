function out = readEnumDataset(hdfName, pathName, dsetName)
% READENUMDATASET
%
% Syntax:
%   out = readEnumDataset(hdfName, pathName, dsetName)
%
% Todo:
%   Remove reliance on h5info (see getEnumTypes for current progress on 
%   implementing this with the low-level library)
%
% See also:
%   h5tools.datasets.makeLogicalDataset, h5info

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