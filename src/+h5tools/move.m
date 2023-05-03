function move(hdfName, sourcePath, destPath)
% Move a group (useful for renaming)
%
% Syntax:
%   h5tools.move(hdfName, sourcePath, destPath)
%
% Inputs:
%   hdfName         HDF5 file name or H5ML.id
%   sourcePath      char 
%       Path of the group/dataset to move
%   destPath        char
%       Destination path (including new name)
%
% Examples:
%   % Rename and move /Group1/Group1A to /Group3
%   h5tools.move('MyFile.h5', '/Group1/Group1A', '/Group3')
%   % Full example in test/MoveTest.m
%
% Notes:
%   Any softlinks to the original path will not be changed!!!
%
% See also:
%   H5L.move

% By Sara Patterson, 2023 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName 
        sourcePath      char
        destPath        char
    end

    if ~isa(hdfName, 'H5ML.id')
        fileID = h5tools.files.openFile(hdfName, false);
        onCleanup(@() H5F.close(fileID));
    else
        fileID = hdfName;
    end
    
    [sourcePath, sourceName] = h5tools.util.splitPath(sourcePath);
    [destPath, destName] = h5tools.util.splitPath(destPath);

    sourceID = H5G.open(fileID, sourcePath);
    destID = H5G.open(fileID, destPath);

    H5L.move(sourceID, sourceName, destID, destName, 'H5P_DEFAULT', 'H5P_DEFAULT');

