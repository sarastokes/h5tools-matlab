classdef LinkTest < matlab.unittest.TestCase

    properties 
        FILE
    end

    methods (TestClassSetup)
        function createFile(testCase)
            testCase.FILE = fullfile(fileparts(mfilename("fullpath")), 'LinkTest.h5');
            h5tools.createFile(testCase.FILE, true);

            % Add some misc groups and datasets for the links to use
            h5tools.createGroup(testCase.FILE, '/', 'GroupOne', 'GroupTwo');
            h5tools.createGroup(testCase.FILE, '/GroupOne', 'GroupOneA');
            h5tools.write(testCase.FILE, '/GroupTwo', 'DatasetTwoA', magic(5));
            h5tools.write(testCase.FILE, '/', 'DatasetOne', "test");
        end
    end

    methods (Test)
        function DatasetGroupLink(testCase)
            h5tools.writelink(testCase.FILE, '/',  '/GroupTwo/DatasetTwoA', 'LinkOne');
            testCase.verifyNumElements(h5tools.collectSoftLinks(testCase.FILE), 1);
        end
    end
end