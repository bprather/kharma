# KHARMA Make script with Homebrew ARM64 HDF5+MPI auto-detection

# Homebrew HDF5
if [[ -f /opt/homebrew/bin/h5cc ]]

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
    export CXXFLAGS="$CXXFLAGS -lsz"
  fi
fi
