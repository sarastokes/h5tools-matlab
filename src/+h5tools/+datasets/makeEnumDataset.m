function makeEnumDataset(hdfName, pathName, dsetName, value)
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
        value                       {h5tools.validators.mustBeEnum(value)} 
    end

    h5tools.datasets.makeTextDataset(hdfName, pathName, dsetName, char(value));