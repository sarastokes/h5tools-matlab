# h5tools-matlab
A toolbox for working with HDF5 files in MATLAB

MATLAB has some HDF5 support, but it's limited. Fortunately, MATLAB also provides access to the hdf5 C library. Unfortunately, it's super confusing to learn. The goal of h5tools-matlab is to expand the built-in MATLAB support and to make user-friendly functions for aspects that currently require the C API. 

h5-tools is designed for reading and writing HDF5 files using MATLAB. To facilitate this process, all datasets written with h5tools-matlab includes attribute describing the intended MATLAB data type and any additional information needed for seamless conversion into the intended data type when reading HDF5 files back into MATLAB. Currently the following data types are supported: **numeric, char, string, table, timetable, duration, enum, containers.Map, struct**. Some of these were already supported by ```h5write```, others were not. There is also support for some of the datatypes in MATLAB's toolboxes like **cfit, imref2d, affine2d, simtform2d**. More of these could easily be added, I just haven't needed any additional ones. 
To add new data types, create an issue or, even better, a pull request adding the type to ```readDatasetByType``` and the test suite (specifically ```DatasetIOTest```). 


### Main Functions
##### Writing dataset(s) 
```h5tools.write``` is the equivalent of MATLAB's ```h5write```. There are a few key differences. First, you do not need to create the group prior to writing a dataset - if the group specified is not found, it will be created. If the group(s) containing that group aren't found, they will also be created. Second, more data types are supported (see **Limitations** for the full details). Third, you can write multiple datasets at once. 
Datasets can be written in the following ways:


```matlab
% Write a single dataset:
h5tools.write('Test.h5', '/', 'Dataset1', 1:3);

% Write multiple datasets
h5tools.write('Test.h5', '/', 'Dataset1', 1:3, 'Dataset2', "hello world");
```

##### Writing attributes
```h5tools.writeatt``` is the equivalent of MATLAB's ```h5writeatt```. As above, there's a bit more support for MATLAB datatypes. There is also support for ensuring your info makes it into the HDF5 file even if it's not going to read back in identically (e.g ```datetime``` gets converted to ```char``` and will be read back in as ```char```). See **Limitations** for more information on what can and cannot be written as an attribute.

```matlab
% Write a single attribute:
h5tools.writeatt('Test.h5', '/', 'A', 1);

% Write multiple attributes:
h5tools.writeatt('Test.h5', '/', 'A', 1, 'B', 2);

% Write all the fields of a struct as attributes
attStruct = struct('A', 1, 'B', 2);
h5tools.writeatt('Test.h5', '/', attStruct);

% Write all the key/value pairs in a containers.Map:
attMap = containers.Map('A', 1, 'B', 2);
h5tools.writeatt('Test.h5', '/', attMap);

% Write a struct or containers.Map followed by additional attributes:
h5tools.writeatt('Test.h5', '/', attMap, 'C', 3);
h5tools.writeatt('Test.h5', '/', attStruct, 'C', 3);
```




### Additional functions
See the documentation
- ```collectAllDatasets``` - returns the full paths of all datasets within an HDF5 file
- ```collectAllGroups``` - returns the full paths of all groups within an HDF5 file.
- ```collectAllSoftLinks``` - returns the full paths of all soft links in the HDF5 file.


##### Resources
- The compound data type writing was largely borrowed from NeurodataWithoutBorders. 
- For more information on working with HDF5 in MATLAB, see MATLAB's documentation for their high-level support and low-level support.
