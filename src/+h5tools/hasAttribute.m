function tf = hasAttribute(hdfName, pathName, paramName)
% HASATTRIBUTE
%
% Description:
%   Determine whether a specific attribute is present
%
% Syntax:
%   tf = hasAttribute(hdfFile, pathName, paramName)
%
% See also:
%   h5tools.getAllAttributeNames

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments
        hdfName             char        {mustBeFile(hdfName)}
        pathName            char
        paramName           string
    end
    
    attNames = h5tools.getAttributeNames(hdfName, pathName);
    tf = ismember(paramName, attNames);