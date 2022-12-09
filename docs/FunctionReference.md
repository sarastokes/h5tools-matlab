## Function Reference

A list to help keep track of low-level library functions and any h5tools-matlab high-level wrapper functions. 

### H5F - File 
```H5F.get_name(objID)``` - return the file name (with full path) HDF5 containing objID, which can be any H5ML.id 

### H5D - Dataset
```spaceID = H5D.get_space(dsetID)``` - get the dataspace for the given dataset.

```typeID = H5D.get_type(dsetID)``` - get the datatype for the given dataset.

