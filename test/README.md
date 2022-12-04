# H5TOOLS-MATLAB Test Suite

As of 3Dec2022, there are **30** files in the ```h5tools``` package. Code coverage is:
- **75.69%** statement coverage (432 executable)
- **91.66%** function coverage (36 executable)

The test suite contains the following:
- ```AttributeTest``` - tests reading and writing attributes
- ```DatasetTest``` - tests reading and writing of HDF5 datasets
- ```GroupTest``` - tests operations at the group level
- ```FileTest``` - tests operations at the file level
- ```ValidatorTest``` - tests validation functions

Tests yet to be written include:
- ```LinkTest``` - tests interface for working with softlinks