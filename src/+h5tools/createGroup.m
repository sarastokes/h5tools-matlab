function createGroup(hdfName, pathName, varargin)
% CREATEGROUP
% 
% Description:
%   Create one or more groups at a specific location
%
% Syntax:
%   groupID = h5tools.createGroup(fileName, pathName, varargin)
%
% Inputs:
%   hdfName         char
%       HDF5 file name
%   pathName        char
%       HDF5 file path
%   varargin        char
%       One or more new group name(s)
%
% Examples:
%   h5tools.createGroup(hdfName, '/', 'Group1')
%   h5tools.createGroup(hdfName, '/', 'Group1', 'Group2')
%   h5tools.createGroup(hdfName, '/', 'Group1', '/Group1/Dataset1')
%
% Notes:
%   Groups can be in different locations as long as the location is 
%   specified relative to "pathName".
%
% See also:
%   h5tools.collectGroups

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName         char        {mustBeFile(hdfName)}
        pathName        char
    end
    
    arguments (Repeating)
        varargin
    end

    fileID = h5tools.openFile(hdfName, false);
    fileIDx = onCleanup(@()H5F.close(fileID));
    for i = 1:numel(varargin)
        try
            groupPath = h5tools.util.buildPath(pathName, varargin{i});
            groupID = H5G.create(fileID, groupPath,...
                'H5P_DEFAULT', 'H5P_DEFAULT', 'H5P_DEFAULT');
            groupIDx = onCleanup(@()H5G.close(groupID));
        catch ME
            if contains(ME.message, 'name already exists')
                warning('createGroup:GroupExists',...
                    'Group %s already exists, skipping', groupPath);
            else
                rethrow(ME);
            end
        end
    end
end