function deleteH5toolsTestFiles()
    
    testPath = fileparts(mfilename('fullpath'));

    if isfile(fullfile(testPath, 'FileTest.h5'))
        delete(fullfile(testPath, 'FileTest.h5'));
    end

    if isfile(fullfile(testPath, 'DatasetTest.h5'))
        delete(fullfile(testPath, 'DatasetTest.h5'));
    end

    if isfile(fullfile(testPath, 'AttributeTest.h5'))
        delete(fullfile(testPath, 'AttributeTest.h5'));
    end

    if isfile(fullfile(testPath, 'GroupTest.h5'))
        delete(fullfile(testPath, 'GroupTest.h5'));
    end
    
