classdef FileTest < matlab.unittest.TestCase

    properties
        FOLDER
        FILE  
    end

    methods (TestClassSetup)
        function identifyTestFolder(testCase)
            testCase.FOLDER = fileparts(mfilename('fullpath'));
            testCase.FILE = fullfile(testCase.FOLDER, 'FileTest.h5');
            if exist(testCase.FILE, 'file')
                delete(testCase.FILE);
            end
        end
    end

    methods (Test)
        function createFile(testCase)
            import matlab.unittest.constraints.Throws

            fileID = h5tools.createFile(testCase.FILE, false);
            testCase.verifyTrue(isfile(testCase.FILE), 'file');
            testCase.verifyClass(fileID, "H5ML.id");

            % Force close of HDF5 file
            H5F.close(fileID);

            % Test for errors when file exists
            testCase.verifyThat(...
                @() h5tools.createFile(testCase.FILE, false),...
                Throws("createFile:FileExists"));
            
            % Overwrite existing file (no error)
            h5tools.createFile(testCase.FILE, true);
        end
    end
end