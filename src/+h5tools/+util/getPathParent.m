function parentPath = getPathParent(pathName)
% Returns leading groups for an HDF5 path
% 
% Description:
%   Removes last identifier in path name, returning parent 
%
% Syntax:
%   parentPath = h5tools.util.getPathParent(pathName)
%
% Example:
%   h5tools.util.getParentPath('/GroupOne/GroupTwo/Dataset')
%   >> '/GroupOne/GroupTwo'
%
% See Also:
%   h5tools.util.getPathEnd, h5tools.util.splitPath

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        pathName            char
    end

    idx = strfind(pathName, '/');
    if numel(idx) == 1 && idx == 1
        parentPath = '/';
    else
        parentPath = pathName(1:idx(end)-1);
    end