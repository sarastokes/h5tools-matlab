function fileID = openFile(hdfName, readOnly)
% Open an HDF5 file
%
% Description:
%   Convenience function for opening file for use with low-level library 
%   with a flag for specifying whether it should be opened as read-only
%
% Syntax:
%   fileID = h5tools.files.openFile(hdfFile, readOnly)
%
% Inputs:
%   hdfFile         char
%       HDF5 file name
% Optional inputs:
%   readOnly        logical, default = true
%       Whether to open in read-only mode or allow write access too
%
% Output:
%   fileID          H5ML.id
%       Identifier for the HDF5 file
%
% Examples:
%   % Open file 'File.h5' as read only
%   fileID = h5tools.files.openFile('File.h5');
%
%   % Open file 'File.h5' with write access
%   fileID = h5tools.files.openFile('File.h5', true);
%
%   % Remember to close the file ID when done
%   H5F.close(fileID)
%
% See Also:
%   h5tools.createFile

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName         char    {mustBeFile(hdfName)}
        readOnly        logical                         = true
    end

    if readOnly
        fileID = H5F.open(hdfName, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
    else
        fileID = H5F.open(hdfName, 'H5F_ACC_RDWR', 'H5P_DEFAULT');
    end
