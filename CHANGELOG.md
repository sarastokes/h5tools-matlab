# CHANGELOG

### v1.1.7
- Removed time-consuming `mustBeHdfPath` validation

### v1.1.6
- Added `h5tools.files.copyFile`, a wrapper for `copyfile` tailored to HDF5 files

### v1.1.5
- Added `h5tools.move` wrapper for `H5L.move`

### v1.1.4
- Fixed bugs in `h5tools.deleteObject`

### v1.1.3
- Appending MATLAB class even for numeric datatypes supported by MATLAB's built-in ``h5read``

### v1.1.2
- Conversion of table properties (row names, units) to string to avoid cellstr attribute warning in ``h5tools.datasets.writeCompoundDataset``

### v1.1.1
- Support for optional arguments to ```h5create``` for numeric datasets 
- Improved datetime strategy for more precise seconds. 
- Working on support for datetime in compound datasets. Currently datetime is handled as a string and cannot convert back to datetime when reading the dataset.
- Removed some unnecessary argument validation 
- Added check to ensure file name provided to ```h5tools.createFile``` ends with ".h5"

### v1.0.1
- Removed use of function from a different repo in ```h5tools.deleteObject```
- Added link to documentation in the README

### v1.0.0
- Initial release
