classdef Classes
% CLASSES
%
% Description:
%   Creates a human-readable representation of the HDF5 class enumeration
%
% Static Methods:
%   obj = Classes.getByID(ID)
%       Creates object from H5ML.id for dataset or datatype
%   obj = Classes.getByPath(hdfName, pathName)
%       Creates object from dataset path within the HDF5 file 

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    enumeration
        INTEGER
        FLOAT
        STRING
        BITFIELD
        OPAQUE
        COMPOUND
        ENUM
        VLEN 
        ARRAY
    end

    methods (Static)
        function obj = getByPath(hdfName, pathName, attName)
            % GETBYID
            % 
            % Description:
            %   Return data class from datatype ID
            %
            % Inputs:
            %   ID          H5ML.id
            %       Datatype identifier
            % 
            % Examples:
            %   % Get a dataset's type
            %   obj = getByPath('File.h5', '/Dset1')
            %
            %   % Get an attribute's type
            %   obj = getByPath('File.h5', '/Dset1', 'Att1');
            % -------------------------------------------------------------

            import h5tools.files.HdfTypes

            if isa(hdfName, 'H5ML.id')
                fileID = hdfName;
            else
                fileID = H5F.open(hdfName);
                fileIDx = onCleanup(@()H5F.close(fileID));
            end

            if nargin < 3
                try % Dataset
                    objID = H5D.open(fileID, pathName);
                    objIDx = onCleanup(@()H5D.close(objID));
                    typeID = H5D.get_type(objID);
                catch  % TODO: Find exact error message...
                    error("getByPath:DatasetPathError",...
                        "Could not open dataset at path %s", pathName);
                end
            else  
                %try % Attribute
                if strcmp(pathName, '/')
                    objID = H5A.open(fileID, attName);
                    objIDx = onCleanup(@()H5A.close(objID));
                else
                    parentID = H5O.open(fileID, pathName, 'H5P_DEFAULT');
                    parentIDx = onCleanup(@() H5O.close(parentID));
                    objID = H5A.open(parentID, attName);
                    objIDx = onCleanup(@()H5A.close(objID));
                end
                typeID = H5A.get_type(objID);
                %catch
                    %error("getByPath:PathOrAttError",...
                %        "Could not open attribute %s at path %s", attName, pathName);
                %end
            end

            typeIDx = onCleanup(@()H5T.close(typeID));

            obj = h5tools.datatypes.Classes.getByID(typeID);
        end

        function obj = getByID(ID)
            % GETBYID
            % 
            % Description:
            %   Return data class from datatype ID
            %
            % Inputs:
            %   ID          H5ML.id
            %       Datatype identifier
            % ------------------------------------------------------------- 
            import h5tools.datatypes.Classes
            import h5tools.files.HdfTypes

            assert(HdfTypes.get(ID) == HdfTypes.DATATYPE,...
                'Input H5ML.id must be a datatype identifier');

            dataClass = H5T.get_class(ID);
            
            switch dataClass
                case H5ML.get_constant_value('H5T_INTEGER')
                    obj = Classes.INTEGER;
                case H5ML.get_constant_value('H5T_FLOAT')
                    obj = Classes.FLOAT;
                case H5ML.get_constant_value('H5T_STRING')
                    obj = Classes.STRING;
                case H5ML.get_constant_value('H5T_BITFIELD')
                    obj = Classes.BITFIELD;
                case H5ML.get_constant_value('H5T_OPAQUE')
                    obj = Classes.OPAQUE;
                case H5ML.get_constant_value('H5T_COMPOUND')
                    obj = Classes.COMPOUND;
                case H5ML.get_constant_value('H5T_ENUM')
                    obj = Classes.ENUM;
                case H5ML.get_constant_value('H5T_VLEN')
                    obj = Classes.VLEN;
                case H5ML.get_constant_value('H5T_ARRAY')
                    obj = Classes.ARRAY;
            end
        end
    end
end 