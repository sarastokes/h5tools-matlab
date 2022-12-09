function makeMapDataset(hdfName, pathName, dsetName, data)
% MAKEMAPDATASET
%
% Description:
%   Write a dataset as attributes of a placeholder text dataset
%
% Syntax:
%   h5tools.makeMapDataset(hdfName, pathName, dsetName, data)
%
% Notes:
%   Mapping a dataset to attributes is a last-ditch effort when compound 
%   dataset did not work due to unequal numbers of elements in each field
%
% See also:
%   h5tools.write, h5tools.datasets.writeDatasetByType

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName         char    {mustBeFile(hdfName)} 
        pathName        char 
        dsetName        char 
        data            {mustBeA(data, ["struct", "containers.Map"])}
    end        

    fullPath = h5tools.util.buildPath(pathName, dsetName);
    matlabClass = class(data);

    h5tools.datasets.makeStringDataset(hdfName, pathName, dsetName, matlabClass);

    if isstruct(data)
        data = struct2map(data);
    end

    keys = data.keys;
    for i = 1:numel(keys)
        h5tools.writeatt(hdfName, fullPath, keys{i}, data(keys{i}));
    end
