function S = kv2map(varargin)
% KV2MAP
%   
% Description:
%   Maps multiple keys and values to a containers.Map
%
% Syntax:
%   S = kv2map(S, 'key', value, 'key', value);
%   S = kv2map('key', value, 'key', value);

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    if nargin == 1
        return
    end

    S = containers.Map();
    for i = 2:2:numel(varargin)
        S(varargin{i-1}) = varargin{i};
    end