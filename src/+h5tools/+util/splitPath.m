function [parentPath, objName] = splitPath(hdfPath)
% Split a path into the parent path and the last group/dataset
%
% Description:
%   Split the last group/dataset from the full path and return both.
%
% Syntax:
%   [parentPath, objName] = h5tools.util.splitPath(hdfPath)
%
% Inputs:
%   hdfPath         char
%       A path within the HDF5 file
%
% Outputs:
%   parentPath      char
%       The full path, minus the last group/dataset name
%   objName         char
%       The group/dataset name
%
% Examples:
%   % Split path into '/G1' and 'DS1'
%   [parentPath, objName] = h5tools.util.splitPath('/G1/DS1');
%
% See also:
%   h5tools.util.getPathParent, h5tools.util.getPathEnd

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    parentPath = h5tools.util.getPathParent(hdfPath);
    objName = h5tools.util.getPathEnd(hdfPath);