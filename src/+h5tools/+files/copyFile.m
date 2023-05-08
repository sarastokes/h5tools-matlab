function success = copyFile(hdfName, newName, overwriteFlag)
% Copy a file
%
% Description:
%   Wrapper for built-in function that checks HDF5 extensions 
%
% Syntax:
%   success = h5tools.files.copyFile(hdfName, newName)
%
% Inputs:
%   hdfName         string
%       Original HDF5 file name
%   newName         string
%       New HDF5 file name (if no path, written to hdfName's location)
%   overwriteFlag   logical 
%       Whether to overwrite existing file (default = false)
% Outputs:
%   success         logical
%       Whether file copy was successful 
%
% See also:
%   copyfile

% By Sara Patterson, 2023 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName         string  {mustBeHdfFile(hdfName)}
        newName         string 
        overwriteFlag   logical = false
    end

    [newPath, ~, ext] = fileparts(newName);
    if ~endsWith(newName, ".h5")
        if ext == ""
            newName = newName + ".h5";
        else
            error("copyFile:InvalidExtension",...
                "File must end with .h5, not %s", ext);
        end
    end

    if newPath == ""
        oldPath = string(fileparts(which(hdfName)));
        newName = fullfile(oldPath, newName);
    end

    if ~overwriteFlag && exist(newName, 'file')
        error('copyFile:FileExists',...
            'Cannot copy as %s because file exists. Set overwrite to true', newName);
    end

    success = copyfile(hdfName, newName);