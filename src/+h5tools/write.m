function write(hdfName, pathName, dsetName, data)

    h5tools.datasets.writeDatasetByType(hdfName, pathName, dsetName, data);