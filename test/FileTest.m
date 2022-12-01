classdef FileTest < matlab.unittest.TestCase

    properties
        FOLDER 
    end

    methods (TestClassSetup)
        function identifyTestFolder(testCase)
            testCase.FOLDER = fileparts(mfilename('fullpath'));
        end
    end

    methods (Test)
        function createFile(testCase)
            fileName = fullfile(testCase.FOLDER, 'FileTest.h5');
            fileID = h5tools.createFile(fileName, true);
            fileIDx = onCleanup(@()H5F.close(fileID));
            testCase.verifyTrue(isfile('FileTest.h5'), 'file');
            testCase.verifyClass(fileID, "H5ML.id");
        end
    end
end