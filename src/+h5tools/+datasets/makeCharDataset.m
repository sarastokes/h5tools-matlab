function makeCharDataset(hdfName, pathName, dsetName, txt) 
% Create & write char to an HDF5 dataset
%
% Description:
%   Create and write an HDF5 dataset for char
%
% Syntax:
%   h5tools.datasets.makeCharDataset(fileName, pathName, dsetName, txt)
%
% Inputs:
%   hdfName     char
%       HDF5 file name
%   pathName    char
%       Path of the group where dataset was written
%   dsetName    char
%       Name of the dataset
%   txt         char
%       Data to write to the dataset
%
% Outputs:
%   N/A
%
% Examples:   
%   % Write a dataset named 'D1' in group '/G1'
%   input = 'test';
%   h5tools.datasets.makeCharDataset('Test.h5', '/G1', 'D1', input);
%
% See Also:
%   h5tools.write, h5tools.datasets.makeStringDataset

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName                     {mustBeHdfFile(hdfName)}
        pathName            char    {mustBeHdfPath(hdfName, pathName)}
        dsetName            char 
        txt                 char
    end

    if isa(hdfName, 'H5ML.id')
        fileID = hdfName;
    else
        fileID = h5tools.files.openFile(hdfName, false);
        fileIDx = onCleanup(@()H5F.close(fileID));
    end
        
    typeID = H5T.copy('H5T_C_S1');
    typeIDx = onCleanup(@()H5T.close(typeID));
    H5T.set_size(typeID, 'H5T_VARIABLE');
    H5T.set_strpad(typeID, 'H5T_STR_NULLTERM');

    dspaceID = H5S.create('H5S_SCALAR');
    dspaceIDx = onCleanup(@()H5S.close(dspaceID));
    
    % Get the parent group
    groupID = H5G.open(fileID, pathName);
    groupIDx = onCleanup(@()H5G.close(groupID));

    % Get the dataset
    try
        dsetID = H5D.create(groupID, dsetName, typeID, dspaceID, 'H5P_DEFAULT');
        dsetIDx = onCleanup(@()H5D.close(dsetID));
    catch ME
        if contains(ME.message, 'name already exists')
            dsetID = H5D.open(groupID, dsetName, 'H5P_DEFAULT');
            dsetIDx = onCleanup(@()H5D.close(dsetID));
        else
            rethrow(ME);
        end
    end
    H5D.write(dsetID, 'H5ML_DEFAULT', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT', txt);
end