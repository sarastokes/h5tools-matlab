classdef MoveTest < matlab.unittest.TestCase 

    properties 
        FILE 
    end

    methods (TestClassSetup)
        function createFile(testCase)
            testFolder = fileparts(mfilename('fullpath'));
            testCase.FILE = fullfile(testFolder, 'MoveTest.h5');

            % Create the file, overwriting if it already exists
            h5tools.createFile(testCase.FILE, true);

            % Create some groups
            h5tools.createGroup(testCase.FILE, '/', 'Group1', 'Group2');
            h5tools.createGroup(testCase.FILE, '/Group1', 'Group1A');

            % Create some datasets
            h5tools.write(testCase.FILE, '/Group1', 'Dataset1A', "abc");
            h5tools.write(testCase.FILE, '/Group2', 'Dataset2A', "def");
            h5tools.write(testCase.FILE, '/Group1/Group1A', 'Dataset1A1', "ghi");
        end
    end

    methods (Test)
        function moveGroup(testCase)
            h5tools.move(testCase.FILE, '/Group1/Group1A', '/Group3');
            groupNames = h5tools.collectGroups(testCase.FILE);
            dsetNames = h5tools.collectDatasets(testCase.FILE);
            
            testCase.verifyTrue(ismember("/Group3", groupNames));
            testCase.verifyTrue(~ismember("/Group1/Group1A", groupNames));
            testCase.verifyTrue(ismember("/Group3/Dataset1A1", dsetNames));

        end
    end
end 