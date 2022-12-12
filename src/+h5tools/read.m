function out = read(hdfName, pathName, dsetName)
% READ
%
% Syntax:
%   out = read(hdfName, pathName, dsetName)
%
% Supported data types:
%   datetime, char, numeric, logical, table, timetable, string, duration
%   cellstr, enum, containers.Map, affine2d, imref2d, simtform2d
%
% See Also:
%   h5read, h5tools.datasets.readDatasetByType

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    
    arguments
        hdfName         char        {mustBeFile(hdfName)}
        pathName        char        {mustBeHdfPath(hdfName, pathName)}
        dsetName        string
    end

    out = h5tools.datasets.readDatasetByType(hdfName, pathName, dsetName);


