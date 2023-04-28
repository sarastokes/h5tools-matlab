function success = writeDatasetByType(hdfName, pathName, dsetName, data, varargin)
% WRITEDATASETBYTYPE
%
% Syntax:
%   success = writeDatasetByType(hdfName, pathName, dsetName, data)
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
% Supported data types:
%   numeric, char, string, logical, table, timetable, datetime, duration
%   cellstr, enum, struct, containers.Map, affine2d, imref2d, simtform2d
%
% Notes:
%   See README.md for limitations
%
% See Also:
%   h5tools.write

% By Sara Patterson, 2023 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName         char        {mustBeFile(hdfName)}
        pathName        char 
        dsetName        char
        data
    end

    arguments (Repeating)
        varargin
    end

    fullPath = h5tools.util.buildPath(pathName, dsetName);
    success = true;

    if isnumeric(data)
        h5tools.datasets.makeMatrixDataset(hdfName, pathName, dsetName, data, varargin{:});
        h5tools.writeatt(hdfName, fullPath, 'Class', class(data));
        return 
    end

    if ischar(data)
        h5tools.datasets.makeCharDataset(hdfName, pathName, dsetName, data);
        h5tools.writeatt(hdfName, fullPath, 'Class', 'char');
        return 
    end

    if isstring(data)
        h5tools.datasets.makeStringDataset(hdfName, pathName, dsetName, data);
        h5tools.writeatt(hdfName, fullPath, 'Class', 'string');
        return
    end
    
    if iscellstr(data) %#ok<ISCLSTR> 
        h5tools.datasets.makeStringDataset(hdfName, pathName, dsetName, string(data));
        h5tools.writeatt(hdfName, fullPath, 'Class', 'cellstr');
        return
    end

    if islogical(data)
        h5tools.datasets.makeLogicalDataset(hdfName, pathName, dsetName, data);
        h5tools.writeatt(hdfName, fullPath, 'Class', 'logical');
        return
    end

    if isstruct(data) || istable(data) || isa(data, 'containers.Map')
        try
            h5tools.datasets.makeCompoundDataset(hdfName, pathName, dsetName, data);
            h5tools.writeatt(hdfName, fullPath, 'Class', class(data));
        catch ME 
            if strcmp(ME.identifier, 'makeCompoundDataset:DifferentFieldSizes')
                h5tools.datasets.makeMapDataset(hdfName, pathName, dsetName, data);
            else
                rethrow(ME);
            end
        end
        return
    end

    if istimetable(data)
        h5tools.datasets.makeCompoundDataset(hdfName, pathName, dsetName, data);
        h5tools.writeatt(hdfName, fullPath, 'Class', class(data),... 
            'Units', 'seconds');
        return
    end

    if isdatetime(data)
        h5tools.datasets.makeDateDataset(hdfName, pathName, dsetName, data);
        h5tools.writeatt(hdfName, fullPath, 'Class', class(data));
        return
    end

    if isduration(data)
        h5tools.datasets.makeMatrixDataset(hdfName, pathName, dsetName, seconds(data), varargin{:});
        h5tools.writeatt(hdfName, fullPath, 'Class', class(data),...
            'Units', 'seconds');
        return
    end

    if isenum(data)
        h5tools.datasets.makeEnumTypeDataset(hdfName, pathName, dsetName, data);
        return
    end

    % Miscellaneous data types. To get the necessary information written 
    % to the dataset, a combination of the dataset and/or the dataset's 
    % attributes are used. These can serve as resources for users to write 
    % additional functions for any datatypes not currently covered.
    switch class(data)
        case 'affine2d'
            h5tools.datasets.makeMatrixDataset(hdfName, pathName, dsetName, data.T);
            h5tools.writeatt(hdfName, fullPath, 'Class', class(data));        
        case 'imref2d'
            h5tools.datasets.makeCharDataset(hdfName, pathName, dsetName, 'imref2d');
            h5tools.writeatt(hdfName, fullPath, 'Class', class(data),...
                'XWorldLimits', data.XWorldLimits,...
                'YWorldLimits', data.YWorldLimits,...
                'ImageSize', data.ImageSize,...
                'PixelExtentInWorldX', data.PixelExtentInWorldX,...
                'PixelExtentInWorldY', data.PixelExtentInWorldY,...
                'ImageExtentInWorldX', data.ImageExtentInWorldX,...
                'ImageExtentInWorldY', data.ImageExtentInWorldY,...
                'YIntrinsicLimits', data.YIntrinsicLimits,...
                'XIntrinsicLimits', data.XIntrinsicLimits);
        case 'simtform2d'
            h5tools.datasets.makeCharDataset(hdfName, pathName, dsetName, 'simtform2d');
            h5tools.writeatt(hdfName, fullPath, 'Class', class(data),...
                'Dimensionality', data.Dimensionality,...
                'Scale', data.Scale,...
                'RotationAngle', data.RotationAngle,...
                'Translation', data.Translation);
        otherwise
            success = false;
            warning('writeDatasetByType:UnidentifiedDataType',...
                'The datatype %s is not supported', class(data));
    end
