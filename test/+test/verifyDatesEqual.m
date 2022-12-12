function verifyDatesEqual(testCase, actual, expected)
% VERIFYDATESEQUAL
%
% Syntax:
%   verifyDatesEqual(testCase, actual, expected)

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    testCase.verifyEqual(actual.Year, expected.Year);
    testCase.verifyEqual(actual.Month, expected.Month);
    testCase.verifyEqual(actual.Day, expected.Day);
    testCase.verifyEqual(actual.Hour, expected.Hour);
    testCase.verifyEqual(actual.Minute, expected.Minute);
    testCase.verifyEqual(actual.Second, expected.Second, 'AbsTol', 0.5);
    testCase.verifyEqual(actual.TimeZone, expected.TimeZone);