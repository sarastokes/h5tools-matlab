function success = writeDatasetByType(hdfName, pathName, dsetName, data)
% WRITEDATASETBYTYPE
%
% Syntax:
%   success = writeDatasetByType(hdfName, pathName, dsetName, data)
%
%
% Supported data types:
%   numeric, char, string, logical, table, timetable, datetime, duration
%   enum, struct, containers.Map(), affine2d, imref2d, simtform2d, cfit
% See README.md for limitations
% -------------------------------------------------------------------------

    arguments
        hdfName         char        {mustBeFile(hdfName)}
        pathName        char 
        dsetName        char
        data
    end

    fullPath = h5tools.buildPath(pathName, dsetName);
    success = true;

    if isnumeric(data)
        h5tools.datasets.makeMatrixDataset(hdfName, pathName, dsetName, data);
        h5tools.writeatt(hdfName, fullPath, 'Class', class(data));
        return 
    end

    if ischar(data)
        h5tools.datasets.makeTextDataset(hdfName, pathName, dsetName, data);
        h5tools.writeatt(hdfName, fullPath, 'Class', class(data));
        return 
    end

    if isstring(data)
        h5tools.datasets.makeStringDataset(hdfName, pathName, dsetName, data);
        h5tools.writeatt(hdfName, fullPath, 'Class', class(data));
        return
    end

    if islogical(data)
        h5tools.datasets.makeMatrixDataset(hdfName, pathName, dsetName, double(data));
        h5tools.writeatt(hdfName, fullPath, 'Class', 'logical');
        return
    end

    if isstruct(data) || istable(data) || isa(data, 'containers.Map')
        h5tools.datasets.makeCompoundDataset(hdfName, pathName, dsetName, data);
        h5tools.writeatt(hdfName, fullPath, 'Class', class(data));
        return
    end

    if isdatetime(data)
        h5tools.datasets.makeDateDataset(hdfName, pathName, dsetName, data);
        h5tools.writeatt(hdfName, fullPath,...
            'Class', 'datetime', 'Format', data.Format);
        return
    end

    if istimetable(data)
        h5tools.datasets.makeCompoundDataset(hdfName, pathName, dsetName, data);
        h5tools.writeatt(hdfName, fullPath, 'Class', class(data),... 
            'Units', 'seconds');
        return
    end

    if isduration(data)
        h5tools.datasets.makeMatrixDataset(hdfName, pathName, dsetName, seconds(data));
        h5tools.writeatt(hdfName, fullPath, 'Class', class(data),...
            'Units', 'seconds');
        return
    end

    if isenum(data)
        h5tools.datasets.makeEnumDataset(hdfName, pathName, dsetName, data);
        return
    end

    % Miscellaneous data types. To get the necessary information written 
    % to the dataset, a combination of the dataset and/or the dataset's 
    % attributes are used.
    switch class(data)
        case 'affine2d'
            h5tools.makeMatrixDataset(hdfName, pathName, dsetName, data.T);
            h5tools.writeatt(hdfName, pathName, 'Class', class(data));        
        case 'imref2d'
            HDF5.makeTextDataset(hdfName, pathName, dsetName, 'imref2d');
            HDF5.writeatts(hdfName, fullPath, 'Class', class(data),...
                'XWorldLimits', data.XWorldLimits,...
                'YWorldLimits', data.YWorldLimits,...
                'ImageSize', data.ImageSize,...
                'PixelExtentInWorldX', data.PixelExtentInWorldX,...
                'PixelExtentInWorldY', data.PixelExtentInWorldY,...
                'ImageExtentInWorldX', data.ImageExtentInWorldX,...
                'ImageExtentInWorldY', data.ImageExtentInWorldY,...
                'YIntrinsicLimits', data.YIntrinsicLimits,...
                'XIntrinsicLimits', data.XIntrinsicLimits);
        case 'cfit'
            coeffNames = string(coeffnames(data));
            coeffValues = [];
            for i = 1:numel(coeffNames)
                coeffValues = cat(2, coeffValues, data.(coeffNames(i)));
            end
            HDF5.makeTextDataset(hdfName, pathName, dsetName,...
                [fitType, ' ', fit]);
            HDF5.writeatts(hdfName, fullPath, 'Class', class(data),...
                'FitType', fitType,...
                'Coefficients', coeffValues);
        otherwise
            success = false;
            warning('writeDatasetByType:UnidentifiedDataType',...
                'The datatype %s is not supported', class(data));
    end
