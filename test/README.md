# H5TOOLS-MATLAB Test Suite

As of 3Dec2022, there are **28** files in the ```h5tools``` package. Code coverage is:
- **68.67%** statement coverage (399 executable)
- **78.78%** function coverage (33 executable)

The test suite contains the following:
- ```DatasetTest``` - tests reading and writing of HDF5 datasets
- ```GroupTest``` - tests operations at the group level
- ```FileTest``` - tests operations at the file level
- ```ValidatorTest``` - tests validation functions

Tests yet to be written include:
- ```AttributeTest``` - tests reading and writing attributes
- ```LinkTest``` - tests interface for working with softlinks