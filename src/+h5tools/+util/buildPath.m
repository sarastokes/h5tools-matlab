function path = buildPath(varargin)
% Builds path out of provided components
%
% Description:
%   Concatenates names into valid HDF5 path. If leading / is
%   missing, it will be added. Similar concept to fullfile
%
% Syntax:
%   path = h5tools.util.buildPath(varargin)
%
% Input:
%   varargin    char
%       Components of an HDF5 path
%
% Output:
%   path        char
%       Combined HDF5 path
%
% Examples:
%   h5tools.util.buildPath('Group1', 'Group2')
%       >> returns '/Group1/Group2'
%
% See Also: 
%   h5tools.util.splitPath, fullfile

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    path = [];
    for i = 1:nargin
        path = [path, '/', char(varargin{i})]; %#ok<AGROW> 
    end

    % Make sure leading / isn't duplicated
    while strcmp(path(2), '/')
        path = path(2:end);
    end