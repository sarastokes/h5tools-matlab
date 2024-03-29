function out = readDateDataset(hdfName, pathName, dsetName)
% Read date dataset
%
% Description:
%   Read a dataset written from MATLAB datetimes
%
% Syntax:
%   out = h5tools.datasets.readDateDataset(hdfName, pathName, dsetName)
%
% Inputs:
%   hdfName         char
%       HDF5 file name
%   pathName        char
%       Path of the group where dataset was written
%   dsetName        char
%       Name of the dataset
%
% Outputs:
%   out             datetime
%       Contents of the dataset
%
% Examples:
%   % Read a dataset named "DS1" within group "/G1"
%   out = h5tools.datasets.readCompoundDataset('Test.h5', '/G1', 'DSI');
%
% See Also:
%   h5tools.datasets.makeDateDataset

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName                     {mustBeHdfFile(hdfName)}
        pathName        char        %{mustBeHdfPath(hdfName, pathName)}
        dsetName        char 
    end

    fullPath = h5tools.util.buildPath(pathName, dsetName);

    map = h5tools.readatt(hdfName, fullPath, 'all');
    
    value = [map('Year'), map('Month'), map('Day'),...
        map('Hour'), map('Minute'), map('Second')];
    out = datetime(value);