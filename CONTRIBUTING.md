# CONTRIBUTING

The HDF5 low-level library is tricky and I'm happy for contributions that add new capabilities to h5tools-matlab or significantly improve existing ones. In the initial release, I added a few specialized MATLAB datatypes that I frequently use, but there are many more that others would find useful and contributions adding those are also welcome. For any added capabilities, also add some tests to the test suite (use code coverage reports to make sure everything is being tested) and make sure the appropriate documentation is included with the code (see existing files for formatting). Then submit a pull request for me to review.

A few areas where h5tools-matlab could improve is the addition of object and region references, solving the issue with row vectors converting to column for numeric attributes and better support for datetime that includes nonscalar inputs. 

If you find an error and can solve it, make a pull request that includes information about the error. Otherwise, add an issue with as much information as possible about the error (code to replicate it, error message content, etc). Same goes for help requests (use "troubleshooting" tag) that aren't resolved by checking through the information and examples in the documentation. If you'd like to request a feature, create an Issue using with the tag "enhancement". Pull requests solving errors or addressing Issues are welcome too. 

I'll try to address issues and pull requests as soon as I can and I'll make sure contributors are acknowledged. 
