function results = runH5toolsTestSuite(options)
% RUNH5TOOLSTESTSUITE
%
% Description:
%   Runs the full test suite with options for code coverage reports, 
%   debugging and keeping files produced during testing
%
% Syntax:
%   results = runH5toolsTestSuite()
%   results = runH5toolsTestSuite(options)
%
% Optional key/value inputs:
%   Coverage            logical (default = false)
%       Whether to output coverage report
%   KeepFiles           logical (default = false)
%       Whether to keep HDF5 files produced by the test suite
%   Debug               logical (default = false)
%       Whether to stop on failures
%
% See Also:
%   test.deleteH5toolsTestFiles

% By Sara Patterson, 2022 (h5tools-matlab)
% -------------------------------------------------------------------------

    arguments
        options.Coverage        logical = false 
        options.KeepFiles       logical = false 
        options.Debug           logical = false
    end

    % Save current directory for return after test suite completes
    currentCD = pwd();

    % Run the suite in the "tests" folder
    cd(fileparts(mfilename('fullpath')));

    % Delete files kept from a previous run, if necessary
    test.deleteH5toolsTestFiles();

    % Run the test suite
    if options.Coverage
        results = testWithCoverageReport(options.Debug);
    else
        results = testWithoutCoverageReport(options.Debug);
    end

    % Clean up files produced by tests, if necessary
    if ~options.KeepFiles
        test.deleteH5toolsTestFiles();
    end

    % Return to user's previous working directory
    cd(currentCD);
end

function results = testWithoutCoverageReport(debugFlag)
    import matlab.unittest.plugins.StopOnFailuresPlugin

    suite = testsuite(pwd);
    runner = testrunner("textoutput");
    if debugFlag
        runner.addPlugin(StopOnFailuresPlugin);
    end
    results = runner.run(suite);
end

function results = testWithCoverageReport(debugFlag)
    import matlab.unittest.plugins.CodeCoveragePlugin
    import matlab.unittest.plugins.codecoverage.CoverageReport    
    import matlab.unittest.plugins.StopOnFailuresPlugin

    if ~exist('coverage', 'dir')
        mkdir('coverage');
    end

    suite = testsuite(pwd);
    runner = testrunner("textoutput");
    if debugFlag
        runner.addPlugin(StopOnFailuresPlugin);
    end

    p = CodeCoveragePlugin.forPackage("h5tools",...
        'IncludingSubpackages', true,...
        'Producing', CoverageReport(fullfile(pwd, 'coverage')));
    runner.addPlugin(p);
    results = runner.run(suite);
    open(fullfile('coverage', 'index.html'));
end
