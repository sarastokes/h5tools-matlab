classdef ValidatorTest < matlab.unittest.TestCase 

    properties 
        TXT_FILE = 'ValidatorTest.txt';
        HDF_FILE = 'ValidatorTest.h5';
    end

    methods (TestClassSetup)
        function createFiles(testCase)
            dlmwrite(testCase.TXT_FILE, eye(3));

            % Create a minimum HDF5 file with a single group
            h5tools.createFile(testCase.HDF_FILE, true);
            h5tools.createGroup(testCase.HDF_FILE, '/', 'GroupOne');
        end
    end

    methods (TestClassTeardown)
        function deleteFiles(testCase)
            delete(testCase.TXT_FILE);
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

        function HDF5FIleInvalidInput(testCase)
            import matlab.unittest.constraints.Throws
            
            testCase.verifyThat(...
                @() h5tools.validators.mustBeHdfFile(1),...
                Throws("mustBeHdfFile:InvalidInput"));
        end

        function HDF5FileID(testCase)
            import matlab.unittest.constraints.Throws
            
            % Passing a file ID should not error
            fileID = h5tools.openFile(testCase.HDF_FILE);
            fileIDx = @()onCleanup(H5G.close(groupID));
            h5tools.validators.mustBeHdfFile(fileID);

            % Passing a group ID should cause an error
            groupID = H5G.open(fileID, '/GroupOne');
            groupIDx = @()onCleanup(H5G.close(groupID));
            testCase.verifyThat(...
                @() h5tools.validators.mustBeHdfFile(groupID),...
                Throws("mustBeFileID:InvalidH5MLID"));
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