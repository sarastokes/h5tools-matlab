classdef HdfTypes
% HDFTYPES
%
% Description:
%    A readable verion of the enumerated values returned by H5I.get_type
%
% Static methods:
%   obj = h5tools.files.HdfTypes.get(ID)
%       Returns the HdfTypes value for a given H5ML.id

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    enumeration
        FILE 
        GROUP 
        DATATYPE
        DATASPACE
        DATASET 
        ATTR 
        BADID
    end

    methods (Static)
        function obj = get(ID)
            % Returns the HdfTypes value for a giving H5ML.id
            % -------------------------------------------------------------

            arguments
                ID      {mustBeA(ID, 'H5ML.id')}
            end

            import h5tools.files.HdfTypes

            objType = H5I.get_type(ID);
            switch objType 
                case H5ML.get_constant_value('H5I_FILE')
                    obj = HdfTypes.FILE;
                case H5ML.get_constant_value('H5I_GROUP')
                    obj = HdfTypes.GROUP;
                case H5ML.get_constant_value('H5I_DATATYPE')
                    obj = HdfTypes.DATATYPE;
                case H5ML.get_constant_value('H5I_DATASPACE')
                    obj = HdfTypes.DATASPACE;
                case H5ML.get_constant_value('H5I_DATASET')
                    obj = HdfTypes.DATASET;
                case H5ML.get_constant_value('H5I_ATTR')
                    obj = HdfTypes.ATTR;
                case H5ML.get_constant_value('H5I_BADID')
                    obj = HdfTypes.BADID;
            end
        end
    end
end
