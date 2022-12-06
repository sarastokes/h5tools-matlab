function lastName = getPathEnd(pathName)
    % GETPATHEND
    % 
    % Description:
    %   Extracts the final group/dataset from a full path 
    %
    % Syntax:
    %   parentPath = getPathEnd(pathName)
    %
    % Examples:
    %   getPathEnd('/GroupOne/GroupTwo/Dataset')
    %       >> 'Dataset'
    % -------------------------------------------------------------
    arguments
        pathName            char
    end

    idx = strfind(pathName, '/');
    lastName = pathName(idx(end)+1:end);