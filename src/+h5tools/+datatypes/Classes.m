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
        function obj = getByPath(hdfName, pathName)
            % GETBYID
            % 
            % Description:
            %   Return data class from datatype ID
            %
            % Inputs:
            %   ID          H5ML.id
            %       Datatype identifier
            % -------------------------------------------------------------

            if isa(hdfName, 'H5ML.id')
                fileID = hdfName;
            else
                fileID = H5F.open(hdfName);
                fileIDx = onCleanup(@()H5F.close(fileID));
            end

            try
                dsetID = H5D.open(fileID, pathName);
                dsetIDx = onCleanup(@()H5D.close(dsetID));
            catch  % TODO: Find exact error message...
                error("getByPath:DatasetPathError",...
                    "Could not open dataset at path %s", pathName);
            end

            typeID = H5D.get_type(dsetID);
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
            import h5tools.util.HdfTypes

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