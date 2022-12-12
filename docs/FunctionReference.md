## Function Reference

A list to help keep track of low-level library functions and any h5tools-matlab high-level wrapper functions. 

### H5F - File 
```H5F.get_name(objID)``` - return the file name (with full path) HDF5 containing objID, which can be any H5ML.id 

### H5D - Dataset
```spaceID = H5D.get_space(dsetID)``` - get the dataspace for the given dataset.

```typeID = H5D.get_type(dsetID)``` - get the datatype for the given dataset.

### H5O - Object
```objID = H5O.open(fileID, path, 'H5P_DEFAULT')``` - open a group OR dataset within the HDF5 file.

```info = H5O.get_info(objID)``` - returns struct with information about the object including type (e.g. "GROUP", "DATASET"). ```h5tools.files.HdfTypes.get()``` extracts the type information. ```get_info``` is also useful in ```H5O.visit()``` loops.
```