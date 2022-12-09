function mustBeHdfPath(hdfFile, hdfPath)
% MUSTBEHDFPATH
%
% Description:
%   Argument validation function confirming hdfPath exists within hdfFile
%
% Syntax:
%   mustBeHdfPath(hdfFile, hdfPath)
%
% Notes:
%   For this to work in an argument block, the HDF file name must be 
%   a previous argument.
%
% History:
%   06Dec2022 - SSP
% -------------------------------------------------------------------------

    if strcmp(hdfPath, '/')
        return
    end
    
    if ~h5tools.exist(hdfFile, hdfPath)
        eid = "HdfPath:InvalidPath";
        msg = sprintf("Path %s does not exist in %s", hdfPath, hdfFile);
        throwAsCaller(MException(eid, msg));
    end