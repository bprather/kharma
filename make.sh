#!/bin/bash

# KHARMA Make script with Homebrew ARM64 HDF5+MPI auto-detection

NPROC=${NPROC:-8}
ARGS="$*"
SOURCE_DIR=$(dirname "$(readlink -f "$0")")

### Compiler setup for Apple Silicon (ARM64)
# Always use Homebrew MPI wrappers for C and C++
export CXX=mpicxx
export CC=mpicc

# Get HDF5 flags from Homebrew's h5cc (ARM64)
H5CC_PATH="/opt/homebrew/bin/h5cc"
if [[ -x "$H5CC_PATH" ]]; then
  export HDF5_FLAGS="$($H5CC_PATH -show | sed 's/^.* //')"
else
  echo "ERROR: h5cc not found at $H5CC_PATH"
  exit 1
fi

# Check for szip and add -lsz if installed
if [[ -f /opt/homebrew/lib/libsz.dylib ]]; then
  export HDF5_FLAGS="$HDF5_FLAGS -lsz"
fi

# Save arguments if we've changed them
if [[ "$ARGS" == *"clean"* ]]; then
  echo "$ARGS" > $SOURCE_DIR/make_args
fi

if [[ "$ARGS" == *"debug"* ]]; then
  TYPE=Debug
else
  TYPE=Release
fi

SCRIPT_DIR=$( dirname "$0" )
cd $SCRIPT_DIR
SCRIPT_DIR=$PWD

# Basic OpenMP setup (Apple Clang OpenMP is problematic, but Homebrew MPI is GCC)
OMP_FLAG="-fopenmp"

# Set additional flags for Kokkos device arch etc. as per your original script...

### Build KHARMA ###
if [[ "$ARGS" == *"clean"* ]]; then
  rm -rf build
fi
mkdir -p build
cd build

if [[ "$ARGS" == *"clean"* ]]; then
  cmake .. \
    -DCMAKE_C_COMPILER="$CC" \
    -DCMAKE_CXX_COMPILER="$CXX" \
    -DCMAKE_CXX_FLAGS="$HDF5_FLAGS $OMP_FLAG $CXXFLAGS" \
    -DCMAKE_BUILD_TYPE=$TYPE \
    $EXTRA_FLAGS
fi

if [[ "$ARGS" != *"dryrun"* ]]; then
  make -j$NPROC
  cp kharma/kharma.* ..
fi