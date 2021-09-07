#!/bin/bash
srun matlab \
-nodisplay -nosplash -nodesktop -nojvm -r \
";\
\
path = '/nfs/scratch/George/MATLAB_Files/SLURM_Deskew/scripts';\
addpath(genpath(path)); \
checkCalibrations('$1')
exit()\
\
"; 

# chmod u+r+x testScript.sh
# sh testScript.sh 

# create three child processes and make the last process wait until all is completed
