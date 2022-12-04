classdef GroupTest < matlab.unittest.TestCase

    properties
        FILE  
    end

    methods (TestClassSetup)
        function createFile(testCase)
            testFolder = fileparts(mfilename('fullpath'));
            testCase.FILE = fullfile(testFolder, 'GroupTest.h5');
            % Create the file, overwriting if it already exists
            h5tools.createFile(testCase.FILE, true);
        end
    end

    % The order of test execution is not predictable so these must be 
    % tested all together
    methods (Test)
        function RootGroupIO(testCase)
            out = h5tools.collectGroups(testCase.FILE);
            testCase.verifyEmpty(out);

            % Create a single group
            h5tools.createGroup(testCase.FILE, '/', 'GroupOne');
            out = h5tools.collectGroups(testCase.FILE);
            testCase.verifyNumElements(out, 1);

            % Create multiple groups
            h5tools.createGroup(testCase.FILE, '/', 'GroupTwo', 'GroupThree');
            out = h5tools.collectGroups(testCase.FILE);
            testCase.verifyNumElements(out, 3);
        end

        function DatasetToExistingGroup(testCase)
            h5tools.createGroup(testCase.FILE, '/', 'GroupFour');
            % There should be no error here:
            h5tools.write(testCase.FILE, '/GroupFour', 'Dataset', eye(3));
        end
    end
end