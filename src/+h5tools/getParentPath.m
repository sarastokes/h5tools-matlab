function parentPath = getPathParent(pathName)
    % GETPATHPARENT
    % 
    % Description:
    %   Removes last identifier in path name, returning parent 
    %
    % Syntax:
    %   parentPath = getPathParent(pathName)
    %
    % Example:
    %   getParentPath('/GroupOne/GroupTwo/Dataset')
    %   >> '/GroupOne/GroupTwo'
    % -------------------------------------------------------------
    arguments
        pathName            char
    end

    idx = strfind(pathName, '/');
    if numel(idx) == 1 && idx == 1
        parentPath = '/';
    else
        parentPath = pathName(1:idx(end)-1);
    end