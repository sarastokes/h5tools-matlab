function makeDateDataset(hdfName, pathName, dsetName, data)
    % MAKEDATEDATASET
    % 
    % Description:
    %   Saves datetime as text dataset with class and date format
    %   stored as attributes 
    %
    % Syntax:
    %   makeDateDataset(hdfFile, pathName, data)
    % ---------------------------------------------------------------------

    arguments
        hdfName            {mustBeFile(hdfName)} 
        pathName            char
        dsetName            char 
        data                datetime
    end

    h5tools.datasets.makeTextDataset(hdfName, pathName,... 
        dsetName, datestr(data)); %#ok<DATST> 
end