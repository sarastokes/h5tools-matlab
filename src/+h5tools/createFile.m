function fileID = createFile(hdfName, overwrite)
% CREATEFILE
%
% Syntax:
%   createFile(hdfFile)
%   fileID = createFile(hdfFile)
%   fileID = createFile(hdfFile, overwrite)
%
% Inputs:
%   hdfFile            char
%       Name of the HDF5 file
% Optional inputs:
%   overwrite           logical, default = false
%       Whether to overwrite the file if it exists
%
% Optional outputs:
%   fileID
%       The file identifier. If no output is specified, the 
%       file will be closed
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