function out = readatt(hdfName, pathName, varargin)
% READATT
%
% Description:
%   Read an HDF5 attribute
%
% Syntax:
%   out = readatt(hdfName, pathName, attName)
%
% Input:
%   hdfName             char
%       HDF5 file name
%   pathName            char
%       HDF5 path of the group/dataset containing the HDF5 attribute
%   attName             char, string, string array
%       Attribute name(s) to read or "all" for all attributes
%
%
% -------------------------------------------------------------------------
    arguments 
        hdfName         char    {mustBeFile(hdfName)}
        pathName        char 
    end

    arguments (Repeating)
        varargin
    end

    if nargin > 3
        error('readatt:NotYetImplemented',...
            'Multiple inputs not yet implemented');
    end

    inputs = convertCharsToStrings(varargin);

    if inputs(1) == "all"
        error('readatt:NotYetImplemented',...
            'Input all not yet implemented');
    end

    out = h5tools.attributes.readAttributeByType(...
        hdfName, pathName, inputs(1));