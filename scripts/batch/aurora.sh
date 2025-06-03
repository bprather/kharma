#!/bin/bash -l
#PBS -A eh_resolution
#PBS -N KHARMA
#PBS -l select=1
#PBS -l walltime=3:00:00
#PBS -l filesystems=flare
#PBS -k doe
#PBS -l place=scatter
#PBS -q prod
#PBS -j oe

# What the actual hell, PBS.  Just start in the submit dir
cd ${PBS_O_WORKDIR}

# List nodes, because PBS also doesn't do that
cat $PBS_NODEFILE

# 12 is hard-coded in run.sh right now
NNODES=`wc -l < $PBS_NODEFILE`
NRANKS=12
NTOTRANKS=$(( $NNODES * $NRANKS ))

# Nominally you can pass args with, e.g., `qsub -F "-i params.par"`
# but PBS command-line arguments are janky on Aurora I think.
# So add the args here:
$HOME/Code/kharma/run.sh -n $NTOTRANKS -t 50:00 
