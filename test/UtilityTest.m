classdef UtilityTest < matlab.unittest.TestCase

    methods (Test)
        function PathDividers(testCase)
            testPath = '/GroupOne/GroupTwo/Dataset';
            testCase.verifyEqual(h5tools.getPathEnd(testPath), 'Dataset');
            
            testPath = '/GroupOne/GroupTwo/Dataset';
            testCase.verifyEqual(h5tools.getParentPath(testPath),... 
                '/GroupOne/GroupTwo');
        end
    end
end