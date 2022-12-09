function makeEnumDataset(hdfName, pathName, dsetName, data)
% MAKEENUMDATASET
%
% Description:
%   Create a pseudo enumerated type dataset (store type as a string and
%   write with an attribute specifying the MATLAB class containing the
%   enumeration for accurately reading from the HDF5 file
%
% Syntax:
%   h5tools.makeEnumDataset(hdfName, pathName, dsetName, val)
%
% Notes:
%   The enumeration will be converted to a char, with the class name
%   written as an attribute. Once read back in, the class name and 
%   enumeration type will be linked with '.' and evaluated using eval
%
% See also:
%   h5tools.write, h5tools.datasets.writeDatasetByType

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName         char        {mustBeFile(hdfName)} 
        pathName        char
        dsetName        char 
        data                        {mustBeEnum(data)} 
    end

    h5tools.datasets.makeTextDataset(hdfName, pathName, dsetName, char(data));
    h5tools.writeatt(hdfName, h5tools.util.buildPath(pathName, dsetName),... 
        'Class', 'enum', 'EnumClass', class(data));