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
                @() mustBeHdfFile(testCase.TXT_FILE),...
                Throws("mustBeHdfFile:InvalidFile"));
            
            % A file that doesn't exist
            testCase.verifyThat(...
                @() mustBeHdfFile('NotAFile.h5'),...
                Throws("mustBeHdfFile:InvalidFile"));
        end

        function HDF5FIleInvalidInput(testCase)
            import matlab.unittest.constraints.Throws
            
            testCase.verifyThat(...
                @() mustBeHdfFile(1),...
                Throws("mustBeHdfFile:InvalidInput"));
        end

        function HDF5FileID(testCase)
            import matlab.unittest.constraints.Throws

            % Passing a file ID should not error
            fileID = h5tools.files.openFile(testCase.HDF_FILE);
            fileIDx = @()onCleanup(H5G.close(groupID));
            mustBeHdfFile(fileID);

            % Passing a group ID should cause an error
            groupID = H5G.open(fileID, '/GroupOne');
            groupIDx = @()onCleanup(H5G.close(groupID));
            testCase.verifyThat(...
                @() mustBeHdfFile(groupID),...
                Throws("mustBeFileID:InvalidH5MLID"));
        end
    end

    methods (Test, TestTags=["mustBeHdfPath"])
        function HdfPath(testCase)
            import matlab.unittest.constraints.Throws
        
            % Should be error free
            mustBeHdfPath(testCase.HDF_FILE, '/GroupOne');

            % Should throw an error
            testCase.verifyThat(...
                @() mustBeHdfPath(testCase.HDF_FILE, '/GroupTwo'),...
                Throws("HdfPath:InvalidPath"));
        end
    end

    methods (Test, TestTags = ["mustBeEnum"])
        function EnumClass(testCase)
            import matlab.unittest.constraints.Throws

            testCase.verifyThat(...
                @() mustBeEnum(1),...
                Throws("mustBeEnum:InvalidInput"));
            
            % Should not throw an error (TODO)
            mustBeEnum(test.EnumClass.GROUPONE);
        end
    end
end 