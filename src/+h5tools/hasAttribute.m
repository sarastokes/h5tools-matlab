function tf = hasAttribute(hdfFile, pathName, paramName)
    % HASATTRIBUTE
    %
    % Description:
    %   Determine whether a specific attribute is present
    %
    % Syntax:
    %   tf = hasAttribute(hdfFile, pathName, paramName)
    % -------------------------------------------------------------
    arguments
        hdfFile             char        {mustBeFile(hdfFile)}
        pathName            char
        paramName           string
    end
    
    attNames = h5tools.getAttributeNames(hdfFile, pathName);
    tf = ismember(paramName, attNames);