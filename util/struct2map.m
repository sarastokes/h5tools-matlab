function map = struct2map(S)
% STRUCT2MAP
%
% Description:
%   Convert a containers.Map to a struct
%
% Syntax:
%   S = map2struct(map)
%
% Inputs:
%   S               struct
%
% Outputs:
%   map             containers.Map
%
% History:
%   30Nov2022 - SSP
% -------------------------------------------------------------------------
    map = containers.Map();

    if isempty(S)
        return
    end
    
    keys = fieldnames(S);
    for i = 1:numel(keys)
        map(keys{i}) = S.(keys{i});
    end