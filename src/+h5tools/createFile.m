function fileID = createFile(hdfName, overwrite)
% Create a new HDF5 file
%
% Description:
%   Create an HDF5 file with optional overwriting of existing file
%
% Syntax:
%   h5tools.createFile(hdfFile)
%   fileID = h5tools.createFile(hdfFile)
%   fileID = h5tools.createFile(hdfFile, overwrite)
%
% Inputs:
%   hdfFile            char
%       Name of the HDF5 file
% Optional inputs:
%   overwrite           logical, default = false
%       Whether to overwrite the file if it exists
%
% Optional outputs:
%   fileID              H5ML.id
%       File Identifier
%
% Examples:
%   % Create an HDF5 file
%   h5tools.createFile('File.h5');
%
%   % Create an HDF5 file, overwrite if existing
%   h5tools.createFile('File.h5', true)
%
%   % Create file and return identifier to use with low-level library
%   fileID = h5tools.createFile('File.h5');
%
% See also:
%   h5tools.files.openFile, h5create

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName         char        
        overwrite       logical                             = false
    end

    if overwrite
        fileID = H5F.create(hdfName, 'H5F_ACC_TRUNC',...
            H5P.create('H5P_FILE_CREATE'), H5P.create('H5P_FILE_ACCESS'));
    else
        try
            fileID = H5F.create(hdfName);
        catch ME
            if strcmp(ME.identifier, 'MATLAB:imagesci:hdf5io:resourceAlreadyExists')
                error("createFile:FileExists",...
                    "File already exists, set overwrite=true to recreate");
            else
                rethrow(ME);
            end
        end
    end

    if nargout == 0
        H5F.close(fileID);
    end
    fprintf('Created HDF5 file: %s\n', hdfName);