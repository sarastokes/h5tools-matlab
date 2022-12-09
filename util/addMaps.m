function newMap = addMaps(map1, map2)
% ADDMAP
%
% Description:
%   Add two containers.Maps with unique keys together
%
% Syntax:
%   newMap = addMaps(map1, map2)

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments
        map1        containers.Map
        map2        containers.Map
    end

    keys1 = map1.keys;
    keys2 = map2.keys;

    if ismember(string(keys1), string(keys2))
        error('addMap:DuplicateKeys',...
            'One or more keys are shared between the two inputs');
    end

    newMap = containers.Map();
    for i = 1:numel(keys1)
        newMap(keys1{i}) = map1(keys1{i});
    end
    for i = 1:numel(keys2)
        newMap(keys2{i}) = map2(keys2{i});
    end