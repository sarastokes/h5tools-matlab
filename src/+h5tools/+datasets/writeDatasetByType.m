function success = writeDatasetByType(hdfName, pathName, dsetName, data)
% WRITEDATASETBYTYPE
%
% Syntax:
%   success = writeDatasetByType(hdfName, pathName, dsetName, data)
%
%
% Supported data types:
%   numeric, char, string, logical, table, timetable, datetime, duration
%   cellstr, enum, struct, containers.Map, affine2d, imref2d, simtform2d
%
% Notes:
%   See README.md for limitations
% -------------------------------------------------------------------------

    arguments
        hdfName         char        {mustBeFile(hdfName)}
        pathName        char 
        dsetName        char
        data
    end

    fullPath = h5tools.util.buildPath(pathName, dsetName);
    success = true;

    if isnumeric(data)
        h5tools.datasets.makeMatrixDataset(hdfName, pathName, dsetName, data);
        h5tools.writeatt(hdfName, fullPath, 'Class', class(data));
        return 
    end

    if iscellstr(data) %#ok<ISCLSTR> 
        fprintf('%s is a cellstr\n', dsetName);
        h5tools.datasets.makeStringDataset(hdfName, pathName, dsetName, string(data));
        h5tools.writeatt(hdfName, fullPath, 'Class', 'cellstr');
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
    % attributes are used. These can serve as resources for users to write 
    % additional functions for any datatypes not currently covered.
    
    switch class(data)
        case 'affine2d'
            h5tools.datasets.makeMatrixDataset(hdfName, pathName, dsetName, data.T);
            h5tools.writeatt(hdfName, fullPath, 'Class', class(data));        
        case 'imref2d'
            h5tools.datasets.makeTextDataset(hdfName, pathName, dsetName, 'imref2d');
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
            h5tools.datasets.makeTextDataset(hdfName, pathName, dsetName, 'simtform2d');
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
