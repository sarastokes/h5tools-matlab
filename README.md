# h5tools-matlab

MATLAB has some solid high-level HDF5 support, but it's limited in scope. Fortunately, MATLAB also provides access to the low-level HDF5 C API. Unfortunately, learning how to use it is challenging, time-consuming and somewhat painful, particularly for the average MATLAB user that may not have experience with languages like C. The goal of h5tools-matlab is to address this gap, expanding the built-in MATLAB support with additional high-level functions that simplify MATLAB's existing interface and provide access to features currently only available through the low-level library (e.g. searching files, creating groups, reading/writing object references, writing text and compound datasets). Users need only understand the components and basic organization of the HDF5 format (i.e. groups, datasets, attributes, object references and paths within an HDF5 file).   

h5tools-matlab provides a toolbox of high-level functions to simplify working with HDF5 files by wrapping calls to the low-level library (see support functions). Key high level functions included that are absent from MATLAB's high-level library include support for creating **groups** and **soft links** ("shortcuts") and for **indexing** the contents of HDF5 files (e.g. returning all attributes of an object or a list of all groups, datasets or softlinks within a file). There are also convenience functions for working with HDF5 paths and several validator functions for argument blocks. 

**Datasets:** MATLAB's built-in dataset support works for numeric data, especially if you understand HDF5 dataspaces. As such, the dataset support in h5tools-matlab is designed for the situations in which MATLAB's high-level functions are not sufficient: reading and writing non-numeric MATLAB data types and supporting users who do not want to deal with ```h5create``` by automating dataset creation. In addition to the MATLAB-supported **numeric** types, h5tools-matlab supports: **char**, **string**, **logical**, **cellstr**, **table**, **timetable**, **duration**, **enum**, **containers.Map,** and **struct**. There is also support for some of the datatypes in MATLAB's toolboxes like **imref2d, affine2d, simtform2d**. Their implementation demonstrates strategies that could be adapted to add more types.

**Attributes:** The added capabilities for attributes include high-level functions that allow working with multiple attributes at once and reading all attributes at once (without knowing their names). Supported datatypes include **numeric**, **char**, **string**, **enum**, **logical** and **datetime**. For the rest, the goal was to get your info into the HDF5 file if at all possible rather than throwing fatal errors. Accordingly, additional datatypes that will write, but not be read back in identically include **duration** and **cellstr**. 

The [Examples](dev/Examples.md) page contains a quick-start guide on how to uses the main h5tools functions. The documentation details how each datatype is written to the HDF5 files and any limitations. This is worth checking out because the techniques h5tools uses to write a few tricky datatypes are more like workarounds than true solutions. All functions are also documented within the code (accessible with ```help``` or ```doc```). h5tools-matlab is supported by an extensive test suite and has 83.81% statement coverage (as of 12Dec2022). See [CONTRIBUTING.md](CONTRIBUTING.md) for information on adding/requesting new features.

If you use this package, please cite the Github repository, for now. This package was developed to support a data management system for adaptive optics imaging of the eye ([AOData](https://github.com/sarastokes/AOData)). A paper is soon to be submitted and a citation will be added here once the paper is up on a preprint server.