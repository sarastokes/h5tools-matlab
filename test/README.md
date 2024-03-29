# H5TOOLS-MATLAB Test Suite

As of 12Dec2022, there are **43** files in the ```h5tools``` package. Code coverage is:
- **90.41%** statement coverage (762 executable)
- **100%** function coverage (50 executable)

The test suite contains the following:
- ```AttributeTest``` - tests reading and writing attributes
- ```AttributesTest``` - tests reading and writing multiple attributes at once
- ```DatasetTest``` - tests reading and writing of HDF5 datasets
- ```EnumClassTest``` - tests the enumerated types included in h5tools-matlab
- ```GroupTest``` - tests operations at the group level
- ```FileTest``` - tests operations at the file level
- ```LinkTest``` - tests interface for working with soft links
- ```MoveTest``` - tests moving/renaming HDF5 groups
- ```SearchTest``` - tests the functions for searching HDF5 files
- ```ValidatorTest``` - tests validation functions


The test suite can be run with the following:
```matlab
results = runH5toolsTestSuite();
```

There are 3 optional key/value inputs to the function above, all of which are false by default:
- ```Coverage``` - whether to generate a code coverage report for the "h5tools" package
- ```KeepFiles``` - whether to keep the HDF5 files generated by the tests for inspection
- ```Debug``` - whether to stop test execution and enter debugging mode on an error