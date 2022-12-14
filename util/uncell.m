function out = uncell(data)
% Remove data from a cell
%
% Description:
%   Some functions run on multiple entities w/ arrayfun require 
%   UniformOutput = false but return only one cell containing the 
%   entities. This is a convenience function to "uncell" the output. 
%   It is also useful with a statement ending with parentheses also 
%   requires the {:} command
%
% Syntax:
%   out = uncell(data)
%
% See also:
%   aod.util.arrayfun

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------
    if ~iscell(data)
        out = data;
        return
    end

    out = vertcat(data{:});