function out = readAttributeByType(hdfName, pathName, attName)
% READATTRIBUTEBYTYPE
%
% Description:
%   Read a single HDF5 attribute
%
% Syntax:
%   out = readAttributeByType(hdfName, pathName, attName)
%
% Input:
%   hdfName             char
%       HDF5 file name
%   pathName            char
%       HDF5 path of the group/dataset containing the HDF5 attribute
%   attName             char
%       Attribute name to read
%
% See also:
%   h5tools.readatt
%
% History:
%   22Aug2022 - SSP
% -------------------------------------------------------------------------
    arguments 
        hdfName         char    {mustBeHdfFile(hdfName)} 
        pathName        char    {mustBeHdfPath(hdfName, pathName)}
        attName         char 
    end

    % Begin with h5readatt and post-process as needed
    data = h5readatt(hdfName, pathName, attName);

    if isa(data, 'int32')
        out = logical(data);
        return
    end

    if isstring(data) && numel(data) == 1
        idx = strfind(data, '.');
        if ~isempty(idx) 
            iData = char(data);
            if exist(iData(1:idx(end)), 'class') == 8
                try
                    out = eval(data);
                    return
                catch ME 
                    if ~ismember(ME.identifier, {'MATLAB:undefinedVarOrClass', 'MATLAB:subscripting:classHasNoPropertyOrMethod'})
                        rethrow(ME);
                    end
                end
            end
        end
    end
    
    if ischar(data)
        % Was it a datetime
        try
            out = datetime(data);
            return 
        catch ME
            if ~strcmp(ME.identifier, 'MATLAB:datetime:UnrecognizedDateStringSuggestLocale')
                rethrow(ME);
            end
        end
    end

    % Otherwise return 
    out = data;