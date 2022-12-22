function makeMatrixDataset(hdfName, pathName, dsetName, data, varargin)
% Write numeric data to an HDF5 dataset
% 
% Description:
%   Chains h5create and h5write for use with numeric data
%
% Syntax:
%   h5tools.datasets.makeMatrixDataset(hdfFile, pathName, dsetName, data, varargin)
%
% Inputs:
%   hdfName     char
%       HDF5 file name
%   pathName     char
%       Path of the group where dataset was written
%   dsetName     char
%       Name of the dataset
%   data        numeric
%       Data to write to the dataset
%   varargin    optional inputs passed to h5create
%
% Outputs:
%   N/A
%
% Examples:   
%   % Write a dataset named 'D1' in group '/G1'
%   input = magic(5);
%   h5tools.datasets.makeMatrixDataset('Test.h5', '/G1', 'D1', input);
%
%   % Write a dataset with optional inputs to h5create for appending
%   input = randn(3, 10);
%   h5tools.datasets.makeMatrixDataset('Test.h5', '/G1', 'D2', input,...
%       [Inf 10], 'ChunkSize', [1 10]);
%   % Append to the dataset (STILL BEING TESTED)
%   input2 = randn(2, 10);
%   h5tools.datasets.makeMatrixDataset('Test.h5', '/G1', 'D2', input2);
%
% Notes:
%   If no optional arguments are provided, the dataset will be created with
%   a MaxSize equal to the size of the data. 
%
% See Also:
%   h5write, h5create, h5tools.write, h5tools.datasets.writeDatasetByType

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    arguments
        hdfName             char        {mustBeFile(hdfName)} 
        pathName            char
        dsetName            char 
        data                            {mustBeNumeric(data)}
    end

    arguments (Repeating)
        varargin
    end

    fullPath = h5tools.util.buildPath(pathName, dsetName);

    % See if max size was first variable input
    if nargin > 4 && isnumeric(varargin{1})
        maxSize = varargin{1};
        startIdx = 2;
    else
        maxSize = size(data);
        startIdx = 1;
    end

    % Create the dataset (if it doesn't exist already)
    try
        h5create(hdfName, fullPath, maxSize,... 
            'Datatype', class(data), varargin{startIdx:end});
        dsetStart = ones(1, ndims(data));
        dsetCount = size(data);
    catch ME
        % If it already exists, try to proceed with the next step
        if contains(ME.message, 'already exists')
            info = h5info(hdfName, fullPath);
            curSize = info.Dataspace.Size;
            maxSize = info.Dataspace.MaxSize;
            dsetStart = ones(1, ndims(data));
            for i = 1:numel(maxSize)
                if isinf(maxSize(i))
                    dsetStart(i) = curSize(i);
                else
                    dsetStart(i) = 1;
                end
            end
            dsetCount = size(data);
        else
            rethrow(ME);
        end
    end  

    % Write the dataset
    h5write(hdfName, fullPath, data, dsetStart, dsetCount);