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

            % Test for errors when file exists & overwrite is defaul (false)
            testCase.verifyThat(...
                @() h5tools.createFile(testCase.FILE),...
                Throws("createFile:FileExists"));
            
            % Overwrite existing file (no error)
            h5tools.createFile(testCase.FILE, true);

            % Look something in a group that doesn't exist
            testCase.verifyFalse(h5tools.exist(testCase.FILE, '/GroupFour/Dset1'));
        end
    end

    methods (Test)

        function PathOrder(testCase)
            % Single input
            path = "/GroupOne/GroupTwo/Dataset";
            testCase.verifyEqual(h5tools.getPathOrder(path), 3);

            % Multiple inputs
            paths = [path; "/GroupOne"];
            testCase.verifyEqual(h5tools.getPathOrder(paths), [3, 1]');
        end

        function PathDividers(testCase)
            testPath = '/GroupOne/GroupTwo/Dataset';
            testCase.verifyEqual(h5tools.getPathEnd(testPath), 'Dataset');
            
            testPath = '/GroupOne/GroupTwo/Dataset';
            testCase.verifyEqual(h5tools.getParentPath(testPath),... 
                '/GroupOne/GroupTwo');

            % Check special case: Group in root group
            testCase.verifyEqual(h5tools.getParentPath('/GroupOne'), '/');
        end
    end
end