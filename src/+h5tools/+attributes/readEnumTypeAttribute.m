function out = readEnumTypeAttribute(hdfName, pathName, attName)
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
%   h5tools.datasets.writeEnumTypeAttribute, h5info, h5readatt

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------


    data = string(h5readatt(hdfName, pathName, attName));

    
    info = h5info(hdfName, pathName);
    % Case insensitive search for attribute, then return datatype info
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