function mustBeEnum(input)
% MUSTBEENUM
% 
% Description:
%   Validates that input is an enumeration
%
% Syntax:
%   mustBeEnum(input)
% -------------------------------------------------------------------------

    if ~isenum(input)
        eid = "mustBeEnum:InvalidInput";
        msg = "Input must be an enumerated type";
        throwAsCaller(MException(eid, msg));
    end
