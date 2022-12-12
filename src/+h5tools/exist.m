function tf = exist(hdfName, pathName)
% EXISTS
% 
% Description:
%   Check if group or dataset exists in file
%
% Syntax:
%   tf = exist(hdfName, hdfName)
%
% Inputs:
%   hdfName         HDF6 file name or H5ML.id
%       The HDF5 file name or identifier
%   pathName        char
%       HDF5 path to group or dataset
%
% Output:
%   tf              logical
%       Whether the path exists within HDF5 file or not
%
% Examples:
%   tf = h5tools.exist('File.h5', '/GroupOne/DatasetA')
%
% See also:
%   h5tools.hasAttribute

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments
        hdfName                 {mustBeHdfFile(hdfName)}
        pathName        char    
    end

    if isa(hdfName, 'H5ML.id')
        fileID = hdfName;
    else
        fileID = h5tools.files.openFile(hdfName, false);
        fileIDx = onCleanup(@()H5F.close(fileID));
    end

    try
        tf = H5L.exists(fileID, pathName, 'H5P_DEFAULT');
    catch ME
        if contains(ME.message, 'component not found')
            tf = false;
        else
            rethrow(ME);
        end
    end