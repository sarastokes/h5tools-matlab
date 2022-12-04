function makeEnumDataset(hdfName, pathName, dsetName, data)
    % MAKEENUMDATASET
    %
    % Description:
    %   Create a pseudo enumerated type dataset
    %
    % Syntax:
    %   makeEnumDataset(hdfName, pathName, dsetName, val)
    %
    % Notes:
    %   The enumeration will be converted to a char, with the class name
    %   written as an attribute. Once read back in, the class name and 
    %   enumeration type will be linked with '.' and evaluated using eval
    % ---------------------------------------------------------------------
    arguments
        hdfName         char        {mustBeFile(hdfName)} 
        pathName        char
        dsetName        char 
        data                        {h5tools.validators.mustBeEnum(data)} 
    end

    h5tools.datasets.makeTextDataset(hdfName, pathName, dsetName, char(data));
    h5tools.writeatt(hdfName, h5tools.buildPath(pathName, dsetName),... 
        'Class', 'enum', 'EnumClass', class(data));