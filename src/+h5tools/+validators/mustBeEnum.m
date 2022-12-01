function mustBeEnum(input)
    % Validates that input is an enumeration
    if ~isenum(input)
        eid = "mustBeEnum:InvalidInput";
        msg = "Input must be an enumerated type";
        throwAsCaller(MException(eid, msg));
    end
