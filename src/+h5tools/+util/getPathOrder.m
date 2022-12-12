function out = getPathOrder(pathName)
% Get path distance from root group
%
% Description:
%   Returns the order of one or more HDF5 path names where the root group
%   has an order of 1.
%
% Syntax:
%   out = h5tools.util.getPathOrder(pathName)
%
% Inputs:
%   pathName        string
%       HDF5 path name(s) as a scalar string or string array
%
% Outputs:
%   out             double
%       Order of each provided path
%
% Examples:
%   h5tools.util.getPathOrder('/G1/G1a');
%       >> returns 2

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        pathName        string
    end

    if ~isscalar(pathName)
        out = arrayfun(@(x)h5tools.util.getPathOrder(x), pathName);
        return
    end

    out = numel(strfind(pathName, "/"));



