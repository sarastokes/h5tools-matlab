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

    properties
        FILE 
    end

    methods (TestClassSetup)
        function createFile(testCase)
            testCase.FILE = fullfile(fileparts(mfilename("fullpath")), 'UtilityTest.h5');
            h5tools.createFile(testCase.FILE, true);

            % Add a group and a dataset
            h5tools.createGroup(testCase.FILE, '/', 'GroupOne');
            h5tools.write(testCase.FILE, '/GroupOne', 'DatasetOne', magic(5));
        end
    end

    methods (Test)

    end

    methods (Test)
        function ExistGroup(testCase)
            % Look something in a group that doesn't exist
            testCase.verifyFalse(h5tools.exist(testCase.FILE, '/GroupFour/Dset1'));
        end
    end
end