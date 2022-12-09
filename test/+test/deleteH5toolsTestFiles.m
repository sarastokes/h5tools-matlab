function deleteH5toolsTestFiles()
% DELETEH5TOOLSTESTFILES
%
% Description:
%   Deletes all the files created by the test suite 
%
% Syntax:
%   test.deleteH5ToolsTestFiles()
% -------------------------------------------------------------------------

    % Suppress warnings for when the file doesn't exist
    warning('off', 'MATLAB:DELETE:FileNotFound');

    testPath = fileparts(fileparts(mfilename('fullpath')));
    delete(fullfile(testPath, 'AttributeTest.h5'));
    delete(fullfile(testPath, 'AttributesTest.h5'));
    delete(fullfile(testPath, 'Collection.h5'));
    delete(fullfile(testPath, 'Dataset.h5'));
    delete(fullfile(testPath, 'File.h5'));
    delete(fullfile(testPath, 'GroupTest.h5'));
    delete(fullfile(testPath, 'HdfTypeTest.h5'));
    delete(fullfile(testPath, 'LinkTest.h5'));
    delete(fullfile(testPath, 'ValidatorTest.h5'));

    % Restore the normal warning settings
    warning('on', 'MATLAB:DELETE:FileNotFound');