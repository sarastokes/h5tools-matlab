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

    h5tools.datasets.makeTextDataset(hdfName, pathName,... 
        dsetName, datestr(data)); %#ok<DATST> 
    h5tools.writeatt(hdfName, h5tools.util.buildPath(pathName, dsetName),...
        'Class', 'datetime', 'Format', data.Format);
end