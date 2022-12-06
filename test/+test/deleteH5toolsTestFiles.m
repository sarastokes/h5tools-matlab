function deleteH5toolsTestFiles()
    
    warning('off', 'MATLAB:DELETE:FileNotFound');

    testPath = fileparts(fileparts(mfilename('fullpath')));

    delete(fullfile(testPath, 'AttributeTest.h5'));
    delete(fullfile(testPath, 'Collection.h5'));
    delete(fullfile(testPath, 'Dataset.h5'));
    delete(fullfile(testPath, 'File.h5'));
    delete(fullfile(testPath, 'GroupTest.h5'));
    delete(fullfile(testPath, 'HdfTypeTest.h5'));
    delete(fullfile(testPath, 'LinkTest.h5'));
    delete(fullfile(testPath, 'UtilityTest.h5'));
    delete(fullfile(testPath, 'ValidatorTest.h5'));
    warning('on', 'MATLAB:DELETE:FileNotFound');