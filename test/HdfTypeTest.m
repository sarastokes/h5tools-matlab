classdef HdfTypeTest < matlab.unittest.TestCase 

    properties
        FILE
    end

    methods (TestClassSetup)
        function obj = createFile(testCase)
            testCase.FILE = fullfile(fileparts(mfilename("fullpath")), "HdfTypeTest.h5");
            % Create the file and add some basic components
            h5tools.createFile(testCase.FILE, true);
            h5tools.createGroup(testCase.FILE, '/', 'GroupOne', 'GroupTwo');
            h5tools.write(testCase.FILE, '/', 'DatasetOne', magic(5));
            h5tools.writeatt(testCase.FILE, '/', 'AttOne', "test");
        end
    end

    methods (Test)
        function TypeFromID(testCase)
            import h5tools.util.HdfTypes
            
            fileID = h5tools.openFile(testCase.FILE);
            fileIDx = @()onCleanup(H5F.close(fileID));
            testCase.verifyEqual(HdfTypes.get(fileID), HdfTypes.FILE);

            groupID = H5G.open(fileID, '/GroupOne');
            groupIDx = @()onCleanup(H5G.close(groupID));
            testCase.verifyEqual(HdfTypes.get(groupID), HdfTypes.GROUP);

            attID = H5A.open(fileID, 'AttOne');
            attIDx = @()onCleanup(H5A.close(attID));
            testCase.verifyEqual(HdfTypes.get(attID), HdfTypes.ATTR);
        end
    end
end 