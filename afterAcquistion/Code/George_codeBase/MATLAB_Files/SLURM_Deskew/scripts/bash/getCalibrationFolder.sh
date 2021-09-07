#!/bin/bash
srun matlab \
-nodisplay -nosplash -nodesktop -nojvm -r \
";\
\
path = '/nfs/scratch/George/MATLAB_Files/SLURM_Deskew/scripts';\
addpath(genpath(path)); \
cmdout = getCalibrationFolder('$1'); \
exit()\
\
"; 

# chmod u+r+x testScript.sh
# sh testScript.sh 