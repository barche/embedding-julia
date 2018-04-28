# Embedding Julia CMake project

This example project shows how to build a C project that embeds Julia and uses CMake as the build system.

## Requirements
* CMake version 2.8.12 or higher
* An appropriate compiler (tested with clang, gcc and Visual Studio 2015)
* A Julia installation

## Usage

### CMake
From the CMake GUI, choose or create a build directory and set the source directory to the directory containing `CMakeLists.txt`. Configure and set the `Julia_EXECUTABLE` CMake variable to correspond to the Julia executable you want to build against. Configure again and then generate. On Windows, make sure you choose the appropriate 32 bit or 64 bit version of Visual Studio

### Compiling and testing
#### OS X and Linux
Go to the build directory in the terminal and run:

```
make
ctest -V
```

#### Windows
Navigate to the build directory in Explorer and open the Visual Studio Solution. Build the ALL_BUILD target. You can run the test by building the RUN_TESTS target, although this does not show any output. For this, it is also possible to run

```
ctest -V -C Debug
```

from a DOS prompt in the build directory.

## Licence
Since the bulk of the code here is the `embedding.c` file from the Julia distribution, this project is of course under the same MIT license: http://julialang.org/license
