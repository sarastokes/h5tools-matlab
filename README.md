# h5tools-matlab

MATLAB has some solid high-level HDF5 support, but it's limited in scope. Fortunately, MATLAB also provides access to the low-level HDF5 C API. Unfortunately, learning how to use it is challenging, time-consuming and somewhat painful, particularly for the average MATLAB user that may not have experience with languages like C. The goal of h5tools-matlab is to address this gap, expanding the built-in MATLAB support with additional high-level functions that simplify MATLAB's existing interface and provide access to features currently only available through the low-level library (e.g. searching files, creating groups, reading/writing object references, writing text and compound datasets). Users need only understand the components and basic organization of the HDF5 format (i.e. groups, datasets, attributes, object references and paths within an HDF5 file).   

h5tools-matlab contains total of 16 high-level functions to make working with HDF5 files easier by wrapping calls to the low-level library (see support functions). There are also convenience functions for working with HDF5 paths and several validator functions for argument blocks. 


Key high level functions included that are absent from MATLAB's high-level library include support for creating groups and object references ("soft-links") and for indexing the contents of HDF5 files (see "Support Functions"). Added capabilities for reading/writing of attributes and datasets are detailed below. 

**Datasets:** While MATLAB's built-in dataset support (```h5create```, ```h5write``` and ```h5read```) are great for numeric data, especially if you understand HDF5 dataspaces. As such, the dataset support in h5tools-matlab is designed specifically the situations in which MATLAB's high-level functions are not sufficient: 
1. Reading and writing text (```char``` or ```string```) to datasets and attributes
2. MATLAB data types that do not map neatly onto an HDF5 type
3. Supporting users who do not want to deal with ```h5create```. 

In addition to the MATLAB-supported **numeric** types, h5tools-matlab supports: **char**, **string**, **logical**, **cellstr**, **table**, **timetable**, **duration, enum, containers.Map,** and **struct** (). Some of these types were already supported by MATLAB's high-level functions and h5tools-matlab acts as a wrapper; others required partial/complete use of the low-level library. There is also support for some of the datatypes in MATLAB's toolboxes like **imref2d, affine2d, simtform2d**. Their implementation demonstrates strategies that could be adapted to add more types. See [CONTRIBUTING.md](CONTRIBUTING.md) for contributing new types.

**Attributes:** The added capabilities for attributes include high-level functions that allow working with multiple attributes at once and reading all attributes at once (without knowing their names). Additional supported datatypes beyond those handled by both ```h5readatt``` and ```h5writeatt``` include **char**, **string** and **enum**. For the rest, the goal was to get your info into the HDF5 file if at all possible rather than throwing fatal errors. Accordingly, additional datatypes that will write, but not be read back in identically include **datetime**, **duration** and **cellstr**. 


All functions are documented within the code (accessible with ```help``` or ```doc```).  h5tools-matlab is supported by an extensive test suite and has **89.06%** statement coverage (as of 6Dec2022).

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

### Citation
If you use this package, please cite the Github repository, for now. This package was developed to support a data management system for adaptive optics imaging of the eye ([AOData](https://github.com/sarastokes/AOData)). A paper is soon to be submitted and a citation will be added here once the paper is up on a preprint server. Please return here to find the citation if you use h5tools-matlab in your own work. 