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
            
            % Test collect groups from fileID
            fileID = h5tools.files.openFile(testCase.FILE);
            fileIDx = onCleanup(@()H5F.close(fileID));
            testCase.verifyEmpty(h5tools.collectGroups(fileID), 1);
        end
    end

    % The order of test execution is not predictable so these must be 
    % tested all together
    methods (Test, TestTags=["Group"])
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

            % Check for warning when group already exists
            testCase.verifyWarning(...
                @() h5tools.createGroup(testCase.FILE, '/', 'GroupOne'),...
                    "createGroup:GroupExists");
        end

        function DatasetToExistingGroup(testCase)
            h5tools.createGroup(testCase.FILE, '/', 'GroupFive');
            % There should be no error here:
            h5tools.write(testCase.FILE, '/GroupFour', 'Dataset', eye(3));
        end

        function SplitPath(testCase)
            h5tools.createGroup(testCase.FILE, '/', 'GroupSix', 'GroupSix/GroupSixA');
            [parentPath, endPath] = h5tools.util.splitPath('/GroupSix/GroupSixA');
            testCase.verifyEqual(parentPath, '/GroupSix');
            testCase.verifyEqual(endPath, 'GroupSixA');
        end
    end

    methods (Test, TestTags=["Deletion", "Group"])
        function DeleteGroup(testCase)
            % Create the group
            h5tools.createGroup(testCase.FILE, '/', 'GroupFour');
            out = h5tools.collectGroups(testCase.FILE);
            testCase.verifyTrue(ismember("/GroupFour", out));

            % Delete the group
            h5tools.deleteObject(testCase.FILE, '/GroupFour');
            out = h5tools.collectGroups(testCase.FILE);
            testCase.verifyFalse(ismember("/GroupFour", out));
        end
    end
end