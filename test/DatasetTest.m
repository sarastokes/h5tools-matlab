classdef DatasetTest < matlab.unittest.TestCase 
% HDFTEST
%
% Description:
%   Tests MATLAB datatype I/O to HDF5
%
% Parent:
%    matlab.unittest.TestCase
%
% Use:
%   result = runtests('DatasetTest.m')
%
% Datatypes tested
% - double (scalar, 2D, 3D)
% - uint8 (scalar)
% - logical (true, false)
% - string (scalar, 2D)
% - char
% - enum
%
% See also:
%   runH5toolsTestSuite
% -------------------------------------------------------------------------

    properties
        FILE = [fullfile(cd, 'Dataset.h5')];
    end

    methods (TestClassSetup)
        function createFile(testCase)
            h5tools.createFile(testCase.FILE, true);
        end
    end

    % MATLAB text datatypes
    methods (Test, TestTags=["String", "Text"])
        function StringScalar(testCase)
            input = "abc";
            h5tools.write(testCase.FILE, '/', 'StringScalar', input);
            output = h5tools.read(testCase.FILE, '/', 'StringScalar');
            testCase.verifyEqual(output, input);
        end

        function StringArray(testCase)
            input = ["abc", "def", "ghi"];
            h5tools.write(testCase.FILE, '/', 'StringArray', input);
            output = h5tools.read(testCase.FILE, '/', 'StringArray');
            testCase.verifyEqual(output, input);
        end
    end

    methods (Test, TestTags=["Char", "Text"])
        function Char(testCase)
            input = 'abcdefghi';
            h5tools.write(testCase.FILE, '/', 'Char', input);
            output = h5tools.read(testCase.FILE, '/', 'Char');
            testCase.verifyEqual(output, input);
        end
    end

    methods (Test, TestTags=["CellStr", "Text"])
        function CellstrRow(testCase)
            input = {'abc', 'def', 'ghi'};
            h5tools.write(testCase.FILE, '/', 'CellstrRow', input);
            output = h5tools.read(testCase.FILE, '/', 'CellstrRow');
            testCase.verifyEqual(output, input);
        end

        
        function CellstrCol(testCase)
            input = {'abc', 'def', 'ghi'}';
            h5tools.write(testCase.FILE, '/', 'CellstrCol', input);
            output = h5tools.read(testCase.FILE, '/', 'CellstrCol');
            testCase.verifyEqual(output, input);
        end
        
        function CellstrScalar(testCase)
            input = {'abc'};
            h5tools.write(testCase.FILE, '/', 'CellstrScalar', input);
            output = h5tools.read(testCase.FILE, '/', 'CellstrScalar');
            testCase.verifyEqual(output, input);
        end
        
        
        function Cellstr2D(testCase)
            input = {'abc', 'def', 'ghi'; 'jkl', 'mno', 'pqr'};
            h5tools.write(testCase.FILE, '/', 'Cellstr2D', input);
            output = h5tools.read(testCase.FILE, '/', 'Cellstr2D');
            testCase.verifyEqual(output, input);
        end
    end

    methods (Test, TestTags={'Boolean'})
        function Logical(testCase)
            input = true;
            h5tools.write(testCase.FILE, '/', 'LogicalTrue', input);
            output = h5tools.read(testCase.FILE, '/', 'LogicalTrue');
            testCase.verifyEqual(output, input);

            input = false;
            h5tools.write(testCase.FILE, '/', 'LogicalFalse', input);
            output = h5tools.read(testCase.FILE, '/', 'LogicalFalse');
            testCase.verifyEqual(output, input);
        end
    end

    methods (Test, TestTags=["Datetime"])
        function Datetime(testCase)
            input = datetime('now', 'Format', 'yyyyMMdd');
            h5tools.write(testCase.FILE, '/', 'Datetime', input);
            output = h5tools.read(testCase.FILE, '/', 'Datetime');
            testCase.verifyTrue(isdatetime(output));
        end
    end

    methods (Test, TestTags=["Numeric", "Float"])
        function DoubleScalar(testCase)
            input = 2;
            h5tools.write(testCase.FILE, '/', 'DoubleScalar', input);
            output = h5tools.read(testCase.FILE, '/', 'DoubleScalar');
            testCase.verifyEqual(output, input);
        end

        function Double2D(testCase)
            input = [1.5 2.5 3.5; 4.2 3.2 1.2];
            h5tools.write(testCase.FILE, '/', 'Double2D', input);
            output = h5tools.read(testCase.FILE, '/', 'Double2D');
            testCase.verifyEqual(output, input);
        end

        function Double3D(testCase)
            input = cat(3, [1 2 3; 4 5 6], [7 8 9; 10 11 12]);
            h5tools.write(testCase.FILE, '/', 'Double3D', input);
            output = h5tools.read(testCase.FILE, '/', 'Double3D');
            testCase.verifyEqual(output, input);
        end
        
        function SingleArray(testCase)
            input = single(magic(5));
            %input = double(magic(5));
            h5tools.write(testCase.FILE, '/', 'SingleArray', input);
            output = h5tools.read(testCase.FILE, '/', 'SingleArray');
            testCase.verifyEqual(output, input);
        end
    end

    methods (Test, TestTags=["Numeric", "Integer"])
        function Uint8Scalar(testCase)
            input = uint8(1);
            h5tools.write(testCase.FILE, '/', 'UInt8', input);
            output = h5tools.read(testCase.FILE, '/', 'UInt8');
            testCase.verifyEqual(output, input);
        end

        function Uint8Array(testCase)
            input = uint8(magic(5));
            h5tools.write(testCase.FILE, '/', 'UInt8Array', input);
            output = h5tools.read(testCase.FILE, '/', 'UInt8Array');
            testCase.verifyEqual(output, input);
        end

        function Int8Array(testCase)
            input = int8(magic(5));
            h5tools.write(testCase.FILE, '/', 'Int8Array', input);
            output = h5tools.read(testCase.FILE, '/', 'Int8Array');
            testCase.verifyEqual(output, input);
        end
        
        function Int16Array(testCase)
            input = int16(magic(5));
            h5tools.write(testCase.FILE, '/', 'Int16Array', input);
            output = h5tools.read(testCase.FILE, '/', 'Int16Array');
            testCase.verifyEqual(output, input);
        end

        function UInt16Array(testCase)
            input = uint16(magic(5));
            h5tools.write(testCase.FILE, '/', 'UInt16Array', input);
            output = h5tools.read(testCase.FILE, '/', 'UInt16Array');
            testCase.verifyEqual(output, input);
        end

        function Int32Array(testCase)
            input = int32(magic(5));
            h5tools.write(testCase.FILE, '/', 'Int32Array', input);
            output = h5tools.read(testCase.FILE, '/', 'Int32Array');
            testCase.verifyEqual(output, input);
        end

        function UInt32Array(testCase)
            input = uint32(magic(5));
            h5tools.write(testCase.FILE, '/', 'UInt32Array', input);
            output = h5tools.read(testCase.FILE, '/', 'UInt32Array');
            testCase.verifyEqual(output, input);
        end
    end

    methods (Test, TestTags={'Struct'})
        function ScalarStruct(testCase)
            input = struct('A', 1, 'B', 2);
            h5tools.write(testCase.FILE, '/', 'ScalarStruct', input);
            output = h5tools.read(testCase.FILE, '/', 'ScalarStruct');
            testCase.verifyEqual(output, input);
        end

        function ScalarStructMultiType(testCase)
            input = struct('A', 1, 'B', "hello");
            h5tools.write(testCase.FILE, '/', 'ScalarStructMulti', input);
            output = h5tools.read(testCase.FILE, '/', 'ScalarStructMulti');
            testCase.verifyEqual(output, input);
        end

        function UnequalStruct(testCase)
            import matlab.unittest.constraints.Throws

            input = struct('A', 1:3, 'B', 2);
            h5tools.write(testCase.FILE, '/', 'UnequalStruct', input);
            output = h5tools.read(testCase.FILE, '/', 'UnequalStruct');
            testCase.verifyEqual(output, input);
            %testCase.verifyThat(...
            %    @() h5tools.write(testCase.FILE, '/', 'UnequalStruct', input),...
            %    Throws("makeCompoundDataset:DifferentFieldSizes"));
        end
    end

    methods (Test, TestTags=["Table"])
        function testTable(testCase)
            input = table(...
                rangeCol(1,4), {'a'; 'b'; 'c'; 'd'}, ["a", "b", "c", "d"]',...
                'VariableNames', {'Numbers', 'Characters', 'Strings'});
            h5tools.write(testCase.FILE, '/', 'Table', input);
            output = h5tools.read(testCase.FILE, '/', 'Table');
            testCase.verifyEqual(output, input);
        end

        function testTimeTable(testCase)
            input = timetable(...
                seconds(1:4)', {'a'; 'b'; 'c'; 'd'}, ["a", "b", "c", "d"]',...
                'VariableNames', {'Characters', 'Strings'});
            h5tools.write(testCase.FILE, '/', 'TimeTable', input);
            output = h5tools.read(testCase.FILE, '/', 'TimeTable');
            testCase.verifyEqual(output, input);
        end
    end

    methods (Test, TestTags={'Enum'})
        function EnumScalar(testCase)
            input = test.EnumClass.GROUPTWO;
            h5tools.write(testCase.FILE, '/', 'EnumScalar', input);
            output = h5tools.read(testCase.FILE, '/', 'EnumScalar');
            testCase.verifyEqual(output, input);
        end

        function EnumOffPath(testCase)
            import matlab.unittest.constraints.Throws
            import matlab.unittest.constraints.IssuesWarnings

            % fakeEnum = 'NotAnEnum.GROUPONE';
            h5tools.datasets.makeTextDataset(testCase.FILE, '/', 'EnumOffPath', 'GROUPONE');
            h5tools.writeatt(testCase.FILE, '/EnumOffPath', 'Class', 'enum',... 
                'EnumClass', 'NotAnEnum');
            testCase.verifyThat(...
                @() h5tools.datasets.readDatasetByType(testCase.FILE, '/', 'EnumOffPath'),...
                IssuesWarnings("read:UnknownEnumerationClass"));
        end

        function EnumBadType(testCase)
            import matlab.unittest.constraints.Throws
            import matlab.unittest.constraints.IssuesWarnings
            
            % fakeEnum = 'EnumClass.GROUPFOUR';
            h5tools.datasets.makeTextDataset(testCase.FILE, '/', 'EnumBadType', 'GROUPFOUR');
            h5tools.writeatt(testCase.FILE, '/EnumBadType', 'Class', 'enum',... 
                'EnumClass', class(test.EnumClass.GROUPONE));
            testCase.verifyThat(...
                @() h5tools.datasets.readDatasetByType(testCase.FILE, '/', 'EnumBadType'),...
                IssuesWarnings("read:UnknownEnumerationType"));
        end
    end

    methods (Test, TestTags={'Duration'})
        function Seconds2D(testCase)
            input = seconds(1:5);
            h5tools.write(testCase.FILE, '/', 'Seconds2D', input);
            output = h5tools.read(testCase.FILE, '/', 'Seconds2D');
            testCase.verifyEqual(output, input);
        end
    end

    methods (Test, TestTags=["Misc"])

        function Imref2d(testCase)
            input = imref2d([242, 360]);
            h5tools.write(testCase.FILE, '/', 'Imref2d', input);
            output = h5tools.read(testCase.FILE, '/', 'Imref2d');
            testCase.verifyEqual(output, input);
        end

        function Simtform2d(testCase)
            input = simtform2d(3, 30, [10 20.5]);
            h5tools.write(testCase.FILE, '/', 'Simtform2d', input);
            output = h5tools.read(testCase.FILE, '/', 'Simtform2d');
            testCase.verifyEqual(output, input);
        end

        function Affine2d(testCase)
            input = affine2d(eye(3));
            h5tools.write(testCase.FILE, '/', 'Affine2d', input);
            output = h5tools.read(testCase.FILE, '/', 'Affine2d');
            testCase.verifyEqual(output, input);
        end
    end

    methods (Test, TestTags=["Group"])
        function AutoCreateGroup(testCase)
            % Test auto creation of parent group
            h5tools.write(testCase.FILE, '/NewGroup', 'Dataset', magic(5));
            groupNames = h5tools.collectGroups(testCase.FILE);
            testCase.verifyEqual(nnz(endsWith(groupNames, 'NewGroup')), 1);
        end
    end
end