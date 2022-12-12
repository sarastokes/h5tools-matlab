function makeDateDataset(hdfName, pathName, dsetName, data)
% Write datetime to a dataset
% 
% Description:
%   Saves datetime as text dataset with class and date format stored as 
%   attributes for accurately reading back into datetime 
%
% Syntax:
%   makeDateDataset(hdfFile, pathName, data)
%
% Inputs:
%   hdfName         char
%       HDF5 file name
%   pathName        char
%       Path of the group where dataset was written
%   dsetName        char
%       Name of the dataset
%   data            datetime
%
% Outputs:
%   N/A
%
% Examples:   
%   % Write a dataset named 'D1' in group '/G1'
%   input = datetime('now');
%   h5tools.datasets.makeDateDataset('Test.h5', '/G1', 'D1', input);
%
% See Also:
%   h5tools.write, h5tools.datasets.readDateDataset

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName            {mustBeFile(hdfName)} 
        pathName            char
        dsetName            char 
        data                datetime
    end

    fullPath = h5tools.util.buildPath(pathName, dsetName);

    h5tools.datasets.makeStringDataset(hdfName, pathName,...
        dsetName, "datetime");
    assignin('base','datedata', data);
    h5tools.writeatt(hdfName, fullPath,...
        'Year', data.Year,...
        'Month', data.Month,...
        'Day', data.Day,...
        'Hour', data.Hour,...
        'Minute', data.Minute,...
        'Second', data.Second,...
        'TimeZone', data.TimeZone);