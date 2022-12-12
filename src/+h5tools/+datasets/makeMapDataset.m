function makeMapDataset(hdfName, pathName, dsetName, data)
% Write a dataset as attributes
%
% Description:
%   Write a dataset as attributes of a placeholder text dataset
%
% Syntax:
%   h5tools.datasets.makeMapDataset(hdfName, pathName, dsetName, data)
%
% Inputs:
%   hdfName         char or H5ML.id
%       HDF5 file name or identifier
%   pathName        char
%       HDF5 path to group where dataset will be written
%   dsetName        char
%       Name of the dataset
%   data            struct or containers.Map
%       Data to be written
%
% Outputs:
%   N/A
%
% Examples:   
%   % Write a dataset named 'D1' in group '/G1'
%   input = struct('A', 1, 'B', 1:3);
%   h5tools.datasets.makeMapDataset('Test.h5', '/G1', 'D1', input);
%
% Notes:
%   Mapping a dataset to attributes is a last-ditch effort when compound 
%   dataset did not work due to unequal numbers of elements in each field
%
% See Also:
%   h5tools.write, h5tools.datasets.makeCompoundDataset

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
