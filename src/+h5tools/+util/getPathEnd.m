function lastName = getPathEnd(pathName)
% Get final group/dataset from HDF5 path
% 
% Description:
%   Extracts the final group/dataset from a full path 
%
% Syntax:
%   parentPath = h5tools.util.getPathEnd(pathName)
%
% Inputs:
%   pathName        char
%       HDF5 path
%
% Outputs:
%   lastName        char
%
% Examples:
%   h5tools.util.getPathEnd('/GroupOne/GroupTwo/Dataset')
%       >> 'Dataset'
%
% See Also:
%   h5tools.util.getPathParent

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments
        pathName            char
    end

    idx = strfind(pathName, '/');
    lastName = pathName(idx(end)+1:end);