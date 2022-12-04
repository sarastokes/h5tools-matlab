classdef SearchTest < matlab.unittest.TestCase 
% SEARCHTEST
%
% Description:
%   Test collection of all groups, datasets and links
% -------------------------------------------------------------------------

    properties
        FILE 
    end

    methods (TestClassSetup)
        function createFile(testCase)
            testCase.FILE = fullfile(fileparts(mfilename("fullpath")), 'Collection.h5');
            h5tools.createFile(testCase.FILE, true);
            
            % Groups have already been tested in GroupTest. Here create 
            % some to support the other functions
            h5tools.createGroup(testCase.FILE, '/',... 
                'Group1', 'Group2', 'Group3');
            h5tools.createGroup(testCase.FILE, '/Group1',... 
                'Group1a', 'Group1b');
            % Create a dataset for the links
            h5tools.write(testCase.FILE, '/Group1', 'Dataset', eye(3));
        end
    end

    methods (Test)
        function Datasets(testCase)
            out = h5tools.collectDatasets(testCase.FILE);
            testCase.verifyNumElements(out, 1);
            testCase.verifyEqual(out, "/Group1/Dataset");
        end
    end
end 