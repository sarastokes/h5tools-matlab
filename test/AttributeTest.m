classdef AttributeTest < matlab.unittest.TestCase 

    properties
        FILE 
    end

    methods (TestClassSetup)
        function createFile(testCase)
            folder = fileparts(mfilename('fullpath'));
            testCase.FILE = fullfile(folder, 'AttributeTest.h5');
            h5tools.createFile(testCase.FILE, true);

            h5tools.createGroup(testCase.FILE, '/', 'Map', 'Struct');
        end
    end

    methods (Test, TestTags=["Inputs"])
        function ContainerInput(testCase)
            map = containers.Map();
            map('Att1') = 1;
            map('Att2') = "a";
            
            h5tools.writeatt(testCase.FILE, '/Map', map);
            out = h5tools.getAttributeNames(testCase.FILE, '/Map');
            testCase.verifyNumElements(out, 2);
        end

        function Struct(testCase)
            S = struct('Att1', 1, 'Att2', "a");
            h5tools.writeatt(testCase.FILE, '/Struct', S);
            out = h5tools.getAttributeNames(testCase.FILE, '/Struct');
            testCase.verifyNumElements(out, 2);
        end
    end

    methods (Test, TestTags=["Deletion"])
        function Deletion(testCase)
            h5tools.writeatt(testCase.FILE, '/', 'ToBeDeleted', "sara");
            h5tools.deleteAttribute(testCase.FILE, '/', 'ToBeDeleted');
            % TODO: verify
            output = h5tools.readatt(testCase.FILE, '/', 'ToBeDeleted');
        end
    end

    methods (Test, TestTags=["String"])
        function ScalarString(testCase)
            input = "test";
            h5tools.writeatt(testCase.FILE, '/', 'ScalarString', input);
            output = h5tools.readatt(testCase.FILE, '/', 'ScalarString');
            testCase.verifyEqual(output, input);
        end

        function ScalarVector(testCase)
            input = ["test", "string", "row"];
            h5tools.writeatt(testCase.FILE, '/', 'StringArrayRow', input);
            output = h5tools.readatt(testCase.FILE, '/', 'StringArrayRow');
            testCase.verifyEqual(output, input');

            h5tools.writeatt(testCase.FILE, '/', 'StringArrayCol', input');
            output = h5tools.readatt(testCase.FILE, '/', 'StringArrayCol');
            testCase.verifyEqual(output, input');
        end
    end

    methods (Test, TestTags = ["Logical"])
        function Logical(testCase)
            h5tools.writeatt(testCase.FILE, '/', 'Logical', true);
            testCase.verifyTrue(h5tools.readatt(testCase.FILE, '/', 'Logical'));

            h5tools.writeatt(testCase.FILE, '/', 'Logical', false);
            testCase.verifyFalse(h5tools.readatt(testCase.FILE, '/', 'Logical'));
        end

        function LogicalVector(testCase)
            input = [true, false, true, false];
            h5tools.writeatt(testCase.FILE, '/', 'LogicalArrayRow', input);
            output = h5tools.readatt(testCase.FILE, '/', 'LogicalArrayRow');
            testCase.verifyEqual(output, input');

            h5tools.writeatt(testCase.FILE, '/', 'LogicalArrayCol', input');
            output = h5tools.readatt(testCase.FILE, '/', 'LogicalArrayCol');
            testCase.verifyEqual(output, input');
        end

        function Logical2D(testCase)
            input = [true false; true true];
            h5tools.writeatt(testCase.FILE, '/', 'Logical2D', input);
            output = h5tools.readatt(testCase.FILE, '/', 'Logical2D');
            testCase.verifyEqual(output, input);
        end
    end

    methods (Test, TestTags = ["char"])
        function Char(testCase)
            input = 'test';
            h5tools.writeatt(testCase.FILE, '/', 'Char', input);
            output = h5tools.readatt(testCase.FILE, '/', 'Char');
            testCase.verifyEqual(output, input);
        end
    end

    methods (Test, TestTags = ["datetime"])
        function DatetimeScalar(testCase)
            input = datetime('24-Oct-2014 12:45:07');
            h5tools.writeatt(testCase.FILE, '/', 'DatetimeScalar', input);
            output = h5tools.readatt(testCase.FILE, '/', 'DatetimeScalar');
            testCase.verifyEqual(output, input);
        end
    end
end 