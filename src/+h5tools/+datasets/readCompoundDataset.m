function out = readCompoundDataset(hdfName, pathName, dsetName)
% Read a compound dataset
%
% Description:
%   Read a dataset of type H5T_COMPOUND and convert to table
%
% Syntax:
%   out = h5tools.datasets.readCompoundDataset(hdfName, pathName, dsetName)
%
% Inputs:
%   hdfName     char
%       HDF5 file name
%   pathName     char
%       Path of the group where dataset was written
%   dsetName     char
%       Name of the dataset
%
% Output:
%   out     table
%       Contents of the compound dataset
%
% Examples:
%   % Read a dataset named "DS1" within group "/G1"
%   out = h5tools.datasets.readCompoundDataset('Test.h5', '/G1', 'DSI');
%
% See Also:
%   h5tools.read, h5tools.datasets.readDatasetByType, 
%   h5tools.datasets.makeCompoundDataset

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    fullPath = h5tools.util.buildPath(pathName, dsetName);

    data = h5read(hdfName, fullPath);
    out = struct2table(data);

    % Handle individual classes
    colClasses = h5readatt(hdfName, fullPath, 'ColumnClass');
    colClasses = strsplit(colClasses, ', '); 
    if isempty(colClasses{1})
        colClasses = colClasses(2:end);
    end
    for i = 1:numel(colClasses)
        colName = out.Properties.VariableNames{i};
        switch colClasses{i}
            case 'string'                     
                out.(colName) = string(out.(colName));
            case 'datetime'
                try
                    out.(colName) = datetime(uncell(out.(colName)));
                catch ME
                    if startsWith(ME.message, 'Could not recognize')
                        out.(colName) = string(out.(colName));
                    else
                        rethrow(ME);
                    end
                end
        end
    end

