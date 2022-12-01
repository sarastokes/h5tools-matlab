function path = buildPath(varargin)
    % BUILDPATH
    %
    % Description:
    %   Concatenates names into valid HDF5 path. If leading / is
    %   missing, it will be added. Similar concept to fullfile
    %
    % Syntax:
    %   path = buildPath(varargin)
    %
    % Example:
    %   buildPath('Group1', 'Group2')
    %       returns '/Group1/Group2'
    % -------------------------------------------------------------
    path = [];
    for i = 1:nargin
        path = [path, '/', char(varargin{i})]; %#ok<AGROW> 
    end

    % Make sure leading / isn't duplicated
    while strcmp(path(2), '/')
        path = path(2:end);
    end