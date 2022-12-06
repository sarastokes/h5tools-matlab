classdef AttributesTest < matlab.unittest.TestCase 
% ATTRIBUTESTEST
%
% Description:
%   Tests reading multiple attributes at once. Because test order is not 
%   guarenteed in MATLAB and this test requires knowing the exact number of
%   attributes an entity has, it needs to be separate from AttributeTest.
%
% Use:
%   results = runtests('AttributesTest.m')
%
% See also:
%   runH5toolsTestSuite
% -------------------------------------------------------------------------
    
    properties
        FILE 
        INPUT
    end

    methods (TestClassSetup)
        function createFile(testCase)
            folder = fileparts(mfilename('fullpath'));
            testCase.FILE = fullfile(folder, 'AttributesTest.h5');
            h5tools.createFile(testCase.FILE, true);

            % Create a group and a dataset to support testing
            h5tools.createGroup(testCase.FILE, '/', 'G1');
            h5tools.write(testCase.FILE, '/', 'D1', magic(5));

            % Create a diverse set of attributes, write to dataset & group
            testCase.INPUT = struct('A', [1; 2; 3], 'B', "test",...
                'C', 'test', 'D', ["test1"; "test2"]);
            h5tools.writeatt(testCase.FILE, '/G1', testCase.INPUT);
            h5tools.writeatt(testCase.FILE, '/D1', testCase.INPUT);
        end
    end

    methods (Test, TestTags=["Group"])
        function Group(testCase)
            % Test accessing just the attribute names
            attNames = h5tools.getAttributeNames(testCase.FILE, '/G1');
            testCase.verifyNumElements(attNames, 4);
            testCase.verifyEmpty(setdiff(attNames, ["A","B","C","D"]));

            % Read a single attribute
            A = h5tools.readatt(testCase.FILE, '/G1', 'A');
            testCase.verifyEqual(A, testCase.INPUT.A);

            % Read two attributes, return two outputs
            [A, B] = h5tools.readatt(testCase.FILE, '/G1', 'A','B');
            testCase.verifyEqual(A, testCase.INPUT.A);
            testCase.verifyEqual(B, testCase.INPUT.B);

            % Read two attributes, return containers.Map
            map1 = h5tools.readatt(testCase.FILE, '/G1', 'A','B');
            testCase.verifyEqual(map1.Count, uint64(2));
            testCase.verifyEqual(map1('A'), testCase.INPUT.A);
            testCase.verifyEqual(map1('B'), testCase.INPUT.B);

            % Read all attributes, return containers.Map
            map2 = h5tools.readatt(testCase.FILE, '/G1', 'all');
            testCase.verifyEqual(map2.Count, uint64(4));
            testCase.verifyEqual(map2('A'), testCase.INPUT.A);
            testCase.verifyEqual(map2('B'), testCase.INPUT.B);
            testCase.verifyEqual(map2('C'), testCase.INPUT.C);
            testCase.verifyEqual(map2('D'), testCase.INPUT.D);
        end
    end

    methods (Test, TestTags=["Dataset"])
        function Dataset(testCase)
            % Test accessing just the attribute names
            attNames = h5tools.getAttributeNames(testCase.FILE, '/D1');
            testCase.verifyNumElements(attNames, 5);
            testCase.verifyEmpty(setdiff(attNames, ["A","B","C","D", "Class"]));
            % Dataset has one extra, the MATLAB Class ("Class")

            % Read a single attribute
            A = h5tools.readatt(testCase.FILE, '/D1', 'A');
            testCase.verifyEqual(A, testCase.INPUT.A);

            % Read two attributes, return two outputs
            [A, B] = h5tools.readatt(testCase.FILE, '/D1', 'A','B');
            testCase.verifyEqual(A, testCase.INPUT.A);
            testCase.verifyEqual(B, testCase.INPUT.B);

            % Read two attributes, return containers.Map
            map1 = h5tools.readatt(testCase.FILE, '/D1', 'A','B');
            testCase.verifyEqual(map1.Count, uint64(2));
            testCase.verifyEqual(map1('A'), testCase.INPUT.A);
            testCase.verifyEqual(map1('B'), testCase.INPUT.B);

            % Read all attributes, return containers.Map
            map2 = h5tools.readatt(testCase.FILE, '/D1', 'all');
            testCase.verifyEqual(map2.Count, uint64(5));
            testCase.verifyEqual(map2('A'), testCase.INPUT.A);
            testCase.verifyEqual(map2('B'), testCase.INPUT.B);
            testCase.verifyEqual(map2('C'), testCase.INPUT.C);
            testCase.verifyEqual(map2('D'), testCase.INPUT.D);
            

        end
    end
end 