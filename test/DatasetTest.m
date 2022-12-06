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

    % Main MATLAB datatypes
    methods (Test, TestTags={'Text'})
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

        function Char(testCase)
            input = 'abcdefghi';
            h5tools.write(testCase.FILE, '/', 'Char', input);
            output = h5tools.read(testCase.FILE, '/', 'Char');
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

    methods (Test, TestTags={'Numeric'})
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

        function Uint8Scalar(testCase)
            input = uint8(1);
            h5tools.write(testCase.FILE, '/', 'UInt8', input);
            output = h5tools.read(testCase.FILE, '/', 'UInt8');
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

            % fakeEnum = 'NotAnEnum.GROUPONE';
            h5tools.datasets.makeTextDataset(testCase.FILE, '/', 'EnumOffPath', 'GROUPONE');
            h5tools.writeatt(testCase.FILE, '/EnumOffPath', 'Class', 'enum',... 
                'EnumClass', 'NotAnEnum');
            testCase.verifyWarning(...
                @() h5tools.read(testCase.FILE, '/', 'EnumOffPath'),...
                "read:UnknownEnumerationClass");
        end

        function EnumBadType(testCase)
            import matlab.unittest.constraints.Throws
            
            % fakeEnum = 'EnumClass.GROUPFOUR';
            h5tools.datasets.makeTextDataset(testCase.FILE, '/', 'EnumBadType', 'GROUPFOUR');
            h5tools.writeatt(testCase.FILE, '/EnumBadType', 'Class', 'enum',... 
                'EnumClass', class(test.EnumClass.GROUPONE));
            testCase.verifyWarning(...
                @() h5tools.read(testCase.FILE, '/', 'EnumBadType'),...
                "read:UnknownEnumerationType");
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

    methods (Test, TestTags=["Error"])
        function ExistingGroup(testCase)
            % h5tools.write automatically creates a group for the dataset.
            % Confirm it can operate well when the group exists too.
            h5tools.createGroup(testCase.FILE, '/', 'Overwrite');
            h5tools.write(testCase.FILE, '/', 'Overwrite', eye(3));
            % Throws no error
        end
    end
end