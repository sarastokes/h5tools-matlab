function fileID = openFile(hdfName, readOnly)
% OPENFILE
%
% Description:
%   Convenience function for opening file for use with low-level library
%
% Syntax:
%   fileID = openFile(hdfFile, readOnly)
%
% Inputs:
%   hdfFile         char, HDF5 file name
% Optional inputs:
%   readOnly        logical, default = true
%
% Output:
%   fileID          H5ML.id
%       Identifier for the HDF5 file

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
