#!/bin/bash
#SBATCH --job-name=Fe3GaTe2   # this is just a name, it will be shown in the queue handler. Makes it easier to 
#SBATCH --nodes=1             # number of nodes, you want to perform the calculation. Unless, your calculation does not fit in the max job limit, it is advised to keep it on 1 node.
#SBATCH --ntasks=4            # total number of mpi threads.
#SBATCH --ntasks-per-node=4   # this is the numer of mpi threads on a node. Maximum 128. It speeds up things, but for small systems, it may rise error. Also, there are partially available nodes, so lowering it might give a better chance to start your job.
#SBATCH --cpus-per-task=1     # should be 1 unless you know what you are doing.
#SBATCH --time=05:00:00       # important too tune. After this amount of time the job is killed. Format: hh:mm:ss. Max 5 days.
#SBATCH --mem-per-cpu 2000    # memory per cpu in kB. unless there is a memory problem, it should not be changed. 1 node has 256GB mem. 
#SBATCH --partition=cpu       # this is the name of the queue, should not be changed.
#SBATCH --output=run.%a.out   # the standard output redirection



## reading your personal bash configuration

source ~/.bashrc

##  some modules to load, do not change this

module purge
module load intel/tbb/latest intel/compiler-rt/latest intel/mkl/latest PrgEnv-gnu cray-pals
module load gcc-native/11.2
module load cray-hdf5/1.12.2.5
module load cray-netcdf/4.9.0.5

## number on openMP threads. this is less efficient paralelisation compared to mpi. Unless there is a memory problem, you do not switch to openMP paralelisation

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK


## this runs the siesta code. the name of the fdf is assumed to be input.fdf and the output is named out.out
# changed this part according to your needs.

time srun /project/p_trildft/bin/siesta < Fe3GaTe2_relax.fdf > output.out
