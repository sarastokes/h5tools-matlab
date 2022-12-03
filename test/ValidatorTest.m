classdef ValidatorTest < matlab.unittest.TestCase 

    properties 
        TXT_FILE = 'ValidatorTest.txt';
        HDF_FILE = 'ValidatorTest.h5';
    end

    methods (TestClassSetup)
        function createFiles(testCase)
            dlmwrite(testCase.TXT_FILE, eye(3));
            h5tools.createFile(testCase.HDF_FILE, true);
        end
    end

    methods (TestClassTeardown)
        function deleteFiles(testCase)
            delete(testCase.TXT_FILE);
            delete(testCase.HDF_FILE);
        end
    end

    methods (Test, TestTags = ["mustBeHdfFile"])
        function HDF5FileNames(testCase)
            import matlab.unittest.constraints.Throws

            % A file that isn't HDF5
            testCase.verifyThat(...
                @() h5tools.validators.mustBeHdfFile(testCase.TXT_FILE),...
                Throws("mustBeHdfFile:InvalidFile"));
            
            % A file that doesn't exist
            testCase.verifyThat(...
                @() h5tools.validators.mustBeHdfFile('NotAFile.h5'),...
                Throws("mustBeHdfFile:InvalidFile"));
        end

        function HDF5FileID(testCase)
            import matlab.unittest.constraints.Throws
            
            testCase.verifyThat(...
                @() h5tools.validators.mustBeHdfFile(1),...
                Throws("mustBeHdfFile:InvalidInput"));

            fileID = h5tools.openFile(testCase.HDF_FILE);
            % Should not throw an error (TODO)
            h5tools.validators.mustBeHdfFile(fileID);
        end
    end

    methods (Test, TestTags = ["mustBeEnum"])
        function EnumClass(testCase)
            import matlab.unittest.constraints.Throws

            testCase.verifyThat(...
                @() h5tools.validators.mustBeEnum(1),...
                Throws("mustBeEnum:InvalidInput"));
            
            % Should not throw an error (TODO)
            h5tools.validators.mustBeEnum(test.EnumClass.GROUPONE);
        end
    end
end 