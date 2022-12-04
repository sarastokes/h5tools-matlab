classdef UtilityTest < matlab.unittest.TestCase
% UTILITYTEST
%
% Description:
%   Test h5tools utility functions
%
% Use:
%   results = runtests('UtilityTest')
%
% See also:
%   runH5toolsTestSuite
% -------------------------------------------------------------------------

    methods (Test)
        function PathDividers(testCase)
            testPath = '/GroupOne/GroupTwo/Dataset';
            testCase.verifyEqual(h5tools.getPathEnd(testPath), 'Dataset');
            
            testPath = '/GroupOne/GroupTwo/Dataset';
            testCase.verifyEqual(h5tools.getParentPath(testPath),... 
                '/GroupOne/GroupTwo');
        end

        function PathOrder(testCase)
            % Single input
            path = "/GroupOne/GroupTwo/Dataset";
            testCase.verifyEqual(h5tools.getPathOrder(path), 3);

            % Multiple inputs
            paths = [path; "/GroupOne"];
            testCase.verifyEqual(h5tools.getPathOrder(paths), [3, 1]');
        end
    end
end