# CHANGELOG

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
