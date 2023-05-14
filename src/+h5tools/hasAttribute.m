function tf = hasAttribute(hdfName, pathName, attName)
% HASATTRIBUTE
%
% Description:
%   Determine whether a specific attribute is present
%
% Syntax:
%   tf = hasAttribute(hdfFile, pathName, paramName)
%
% Inputs:
%   hdfName         char or H5ML.id
%       The HDF5 file name or identifier
%   pathName        char
%       The path to the dataset or group within the HDF5 file
%   attName         char
%       The attribute name or names
%   
% Outputs:
%   tf              logical
%       Whether or not the attribute exists
%
% Examples:
%   tf = h5tools.hasAttribute('Test.h5', '/GroupOne', 'AttrOne');
%
% See also:
%   h5tools.getAttributeNames, h5tools.readatt

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        hdfName                     {mustBeHdfFile(hdfName)}
        pathName        char        %{mustBeHdfPath(hdfName, pathName)}
        attName         string
    end
    
    attNames = h5tools.getAttributeNames(hdfName, pathName);
    tf = ismember(attName, attNames);