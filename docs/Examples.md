
## Main Functions
### Writing dataset(s) 
```h5tools.write``` is the equivalent of MATLAB's ```h5create``` and ```h5write```. There are a few key differences. First, you do not need to create the dataset prior to writing the data. Second, more data types are supported (see **Limitations** for the full details). Third, you can write multiple datasets at once. 

The first two arguments are always the HDF5 file name and the path of the group within the HDF5 file where the datasets will be written. The datasets created can be specified in the following ways:


```matlab
% Write a single dataset:
h5tools.write('Test.h5', '/', 'Dataset1', 1:3);

% Write multiple datasets
h5tools.write('Test.h5', '/', 'Dataset1', 1:3, 'Dataset2', "hello world");
```

The upside of handling dataset creating behind the scenes is that it is tricky (especially for non-numeric types) and the average user may have no reason to delve into the details of HDF5 dataset creation. The downside is that you lose the control of specifying your dataspace and dataset (particularly access to filtering, compression, etc.). If you do have special requirements for the created dataset, try MATLAB's built-in functions or the low-level library. 

How does h5tools-matlab implement the previously unsupported datatypes and ensure they are read back into MATLAB from HDF5 identically? The full implementation is described in the "docs" folder. First, once you understand HDF5 dataspaces (```H5S```), you'll find more types are supported than you initially thought, which is why dataset creation is bundled in with writing. Second, truly unsupported types are made possible by writing attributes to the dataset that identify the intended MATLAB data type and any additional information needed to recreate the intended data type when reading the dataset into MATLAB. 
> Disclaimer: Using attributes to support new datatypes is a workaround rather than a true solution. That being said... it does work (with some limitations described in the documentation).


### Reading dataset(s) 
```h5tools.read``` is used to read one or more HDF5 datasets. The datasets do not need to be located within the same group, as long as their names are specified relative to the 2nd input (```pathName```).
```matlab
% Syntax:
%   h5tools.writeatt(fileName, pathName, varargin)

% Read the dataset named "DatasetOne" within "/GroupOne"
out = h5tools.read('Test.h5', '/GroupOne', 'DatasetOne');
```

### Writing attributes
```h5tools.writeatt``` is the equivalent of MATLAB's ```h5writeatt```. A key addition is the ability to work with multiple attributes as once, as demonstrated below. There's also a bit more support for MATLAB datatypes. There is also support for ensuring your info makes it into the HDF5 file even if it's not going to read back in identically (e.g ```datetime``` gets converted to ```char``` and will be read back in as ```char```). See **Limitations** for more information on what can and cannot be written as an attribute. 

```matlab
% Syntax:
%   h5tools.writeatt(fileName, pathName, varargin)

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

### Reading attributes
Attributes are read with ```h5tools.readatt```. You can specify one or more attributes to return, or ask for all the attributes. The output will change depending on the input you provide, as demonstrated below and detailed further in the documentation for ```h5tools.readatt```. 
```matlab
% 1. Read a single attribute, return the value
out = readatt('File.h5', '/GroupOne', 'Attr1')

% 2. Read two attributes, return the values as two outputs
[out1, out2] = readatt('File.h5', '/GroupOne', 'Attr1', 'Attr2')

% 3. Read two attributes, return the values in a containers.Map:
out = readatt('File.h5', '/GroupOne', 'Attr1', 'Attr2')

% 4. Read all attributes, return the values in a containers.Map
out = readatt('File.h5', '/GroupOne', 'all')
```

### Creating groups
```h5tools.createGroup``` enables creation of one or more new HDF5 groups, relative to a single location within the HDF5 file. 
```matlab
% Create one group within the root group "/"
h5.createGroup('Test.h5', '/', 'GroupOne);

% Create three groups within "/GroupOne"
h5.createGroup('Test.h5', '/GroupOne', 'GroupOne1A', 'Group1B', 'Group1C');

% Create two groups, one in the root group "/" and one in "/GroupOne"
h5.createGroup('Test.h5', '/', 'GroupTwo', '/GroupOne/Group1D');
```

### Creating links
```h5tools.writelink``` creates a dataset that references another object (a group or a dataset) within the HDF5 file. The syntax mirrors that of ```h5tools.write``` and ```h5tools.writeatt```, only the HDF5 path of the object to reference is provided as the 4th argument instead of data. 
```matlab
% Write a dataset named "LinkName" in the root group "/" that references "/GroupOne"
h5tools.writelink('Test.h5', '/', 'LinkName', '/GroupOne');
```

### Creating files
```h5tools.createFile``` creates a new HDF5 file. There's an optional 2nd argument to automatically overwrite any existing file by that name. You can optionally specify an output to return the``` H5ML.id``` for the file if you need to use the low-level library.
```matlab
% Create a new file. If it already exists, return an error
h5tools.createFile('Test.h5');

% Create a new file and overwrite if it already exists
h5tools.createFile('Test.h5', true);

% Create a new file, don't overwrite and return the identifier
fileID = h5tools.createFile('Test.h5', false);
% Don't forget to close fileID when you're done using it
H5F.close(fileID);
```
> Warning: some functions have optional outputs for returning the associated ```H5ML.id```, which is used for working with the low-level library. Don't request these outputs unless you intend to use them, as you will be responsible for closing them once you're finished (as shown above). A few of the functions may throw errors if the identifiers involved are open in the base workspace. 

## Support functions
See the documentation for full information on how to use these. All take the HDF5 file name as the first input. Many will also accept the file's ```H5ML.id``` instead, in case you're using the low-level library.
- ```dsetNames = h5tools.collectAllDatasets(hdfFile)``` - returns the full paths of all datasets within an HDF5 file
- ```groupNames = h5tools.collectAllGroups(hdfFile)``` - returns the full paths of all groups within an HDF5 file.
- ```linkNames = h5tools.collectAllSoftLinks(hdfFile)``` - returns the full paths of all soft links in the HDF5 file.
- ```tf = h5tools.exist(hdfFile, hdfPath)``` - returns whether or not ```hdfPath``` exists within the HDF5 file
- ```attNames = h5tools.getAttributeNames(hdfFile, hdfPath)``` - returns the attribute names of the group/dataset at ```hdfPath```
- ```tf = h5tools.hasAttribute(hdfFile, hdfPath, attName)``` - returns whether or not the group/dataset at ```hdfPath``` has the attribute ```attName```.
- ```fileID = h5tools.files.openFile(hdfFile, readOnly)``` - if you need to work with the low-level library, this function will return the file identifier. If the 2nd input is true (default), it will be opened as read-only. To modify the file, set to false. 

The ```h5tools.util``` package contains some small functions for working with HDF5 paths (```getPathEnd```, ```buildPath```). In addition, ```h5tools.files.HdfTypes``` mimics the enumeration used for object types in the low-level library (but does not require using ```H5ML.get_constant_value()``` to interpret) and can parse ```H5ML.id``` inputs.
