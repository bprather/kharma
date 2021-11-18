# KHARMA
KHARMA is an implementation of the HARM GRMHD algorithm in C++ based on the Parthenon AMR infrastructure, using Kokkos for parallelism and GPU support.  It is implemented via extensible "packages," which in theory make it easy to add or swap components representing different physical processes.

The project is capable of most GRMHD functions found in e.g. [iharm3d](https://github.com/AFD-Illinois/iharm3d). Support for adaptive mesh refinement is planned but not yet imlemented.

## Prerequisites
KHARMA requires that the system have a C++14-compliant compiler, MPI, and parallel HDF5.  All other dependencies are included as submodules, and can be checked out with `git` by running
```bash
$ git submodule update --init --recursive
```

## Compiling
On directly supported systems, or systems with standard install locations, you may be able to run:
```bash
./make.sh clean
```
And (possibly) the following to compile for GPU with CUDA:
```bash
./make.sh clean cuda
```
after a *successful* compile, subsequent invocations can omit `clean`.

If (when) these fail, take a look at the [wiki page](https://github.com/AFD-Illinois/kharma/wiki/Building-KHARMA), and the `make.sh` source code.  At worst this should involve running something like
```bash
PREFIX_PATH="/absolute/path/to/phdf5;/absolute/path/to/cuda" HOST_ARCH=CPUVER DEVICE_ARCH=GPUVER ./make.sh clean cuda
```
Where `CPUVER` and `GPUVER` are the strings used by Kokkos to denote a particular architecture & set of compile flags (Note `make.sh` needs only the portion of the flag *after* `Kokkos_ARCH_`).

## Running
Run a particular problem with e.g.
```bash
$ ./kharma.host -i pars/orszag_tang.par
```
KHARMA benefits from certain runtime environment variables and CPU pinning, which I've attempted to include in a short wrapper script, `run.sh`.  Some MPI implementations require that KHARMA be run using `mpirun`, even for a single process, and may cause errors or hangs otherwise.

KHARMA takes no compile-time options, so all the parameters for a simulation are provided by this input "deck."  Several sample inputs corresponding to standard tests and astrophysical systems are included in `pars/`.  Further information can be found on the [wiki page](https://github.com/AFD-Illinois/kharma/wiki/Running-KHARMA).

## Hacking
KHARMA has some preliminary documentation for developers, hosted in its GitHub [wiki](https://github.com/AFD-Illinois/kharma/wiki).
