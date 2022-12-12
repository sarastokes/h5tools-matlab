classdef EnumClassTest < matlab.unittest.TestCase 

    properties
        FILE = fullfile(fileparts(mfilename("fullpath")), "EnumClassTest.h5")
    end

    methods (TestClassSetup)
        function createFile(testCase)
            testCase.FILE 
            % Create the file and add some basic components
            h5tools.createFile(testCase.FILE, true);
            h5tools.createGroup(testCase.FILE, '/', 'GroupOne', 'GroupTwo');
            h5tools.write(testCase.FILE, '/', 'DatasetOne', magic(5));
            h5tools.write(testCase.FILE, '/', 'DatasetTwo', uint8(magic(5)));
            h5tools.writeatt(testCase.FILE, '/', 'AttOne', "test");
        end
    end

    methods (Test)
        function TypeFromID(testCase)
            import h5tools.files.HdfTypes
            
            fileID = h5tools.files.openFile(testCase.FILE);
            fileIDx = @()onCleanup(H5F.close(fileID));
            testCase.verifyEqual(HdfTypes.get(fileID), HdfTypes.FILE);

            groupID = H5G.open(fileID, '/GroupOne');
            groupIDx = @()onCleanup(H5G.close(groupID));
            testCase.verifyEqual(HdfTypes.get(groupID), HdfTypes.GROUP);

            dsetID = H5D.open(fileID, '/DatasetOne');
            dsetIDx = @()onCleanup(H5D.close(dsetID));
            testCase.verifyEqual(HdfTypes.get(dsetID), HdfTypes.DATASET);

            spaceID = H5D.get_space(dsetID);
            spaceIDx = @()onCleanup(H5S.close(spaceID));
            testCase.verifyEqual(HdfTypes.get(spaceID), HdfTypes.DATASPACE);

            typeID = H5D.get_type(dsetID);
            typeIDx = @()onCleanup(H5T.close(typeID));
            testCase.verifyEqual(HdfTypes.get(typeID), HdfTypes.DATATYPE);

            attID = H5A.open(fileID, 'AttOne');
            attIDx = @()onCleanup(H5A.close(attID));
            testCase.verifyEqual(HdfTypes.get(attID), HdfTypes.ATTR);
        end
    end
end 