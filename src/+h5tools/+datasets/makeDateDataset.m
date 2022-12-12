function makeDateDataset(hdfName, pathName, dsetName, data)
% MAKEDATEDATASET
% 
% Description:
%   Saves datetime as text dataset with class and date format stored as 
%   attributes for accurately reading back into datetime 
%
% Syntax:
%   makeDateDataset(hdfFile, pathName, data)
%
% Inputs:
%   hdfName     char
%       HDF5 file name
%   pathName     char
%       Path of the group where dataset was written
%   dsetName     char
%       Name of the dataset
%
% See also:
%   h5tools.write, h5tools.datasets.writeDatasetByType

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName            {mustBeFile(hdfName)} 
        pathName            char
        dsetName            char 
        data                datetime
    end

    % Limitation: Seconds is rounded (better than MATLAB's floor w/ datesr)
    data.Second = round(data.Second);
    
    input = string(datestr(data));
    input = reshape(input, size(data));
    h5tools.datasets.makeStringDataset(hdfName, pathName,... 
        dsetName, input); %#ok<DATST> 
    h5tools.writeatt(hdfName, h5tools.util.buildPath(pathName, dsetName),...
        'Class', 'datetime', 'Format', data.Format);
end