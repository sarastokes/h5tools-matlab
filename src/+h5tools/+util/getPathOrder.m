function out = getPathOrder(pathName)
% GETPATHORDER
%
% Description:
%   Returns the order of one or more HDF5 path names where the root group
%   has an order of 1.
%
% Syntax:
%   out = getPathOrder(pathName)
%
% Inputs:
%   pathName        string
%       HDF5 path name(s) as a scalar string or string array
% -------------------------------------------------------------------------

    arguments
        pathName        string
    end

    if ~isscalar(pathName)
        out = arrayfun(@(x)h5tools.util.getPathOrder(x), pathName);
        return
    end

    out = numel(strfind(pathName, "/"));



