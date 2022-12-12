classdef LinkTest < matlab.unittest.TestCase
% LINKTEST
%
% Description:
%   Tests support for reading and writing HDF5 object references
%
% Use:
%   results = runtests('LinkTest')
%
% See also:
%   runH5toolsTestSuite
% -------------------------------------------------------------------------

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
            h5tools.writelink(testCase.FILE, '/', 'LinkOne',... 
                '/GroupTwo/DatasetTwoA');
            testCase.verifyNumElements(...
                h5tools.collectSoftlinks(testCase.FILE), 1);

            % Test from file ID
            fileID = h5tools.files.openFile(testCase.FILE);
            fileIDx = onCleanup(@()H5F.close(fileID));
            testCase.verifyNumElements(...
                h5tools.collectSoftlinks(fileID), 1);
        end
    end

    methods (Test, TestTags=["Error"])
        function InvalidTarget(testCase)
            import matlab.unittest.constraints.Throws

            testCase.verifyThat(...
                @() h5tools.writelink(testCase.FILE, '/', 'LinkTwo', '/GroupThree'),...
                Throws("writeLink:InvalidLinkTarget"));
        end
    end
end