
#!/bin/bash

FAIL=0

# matlab get illum
# ./sleeper.pl 2 0 &
srun matlab \
-nodisplay -nosplash -nodesktop -nojvm -r \
";\
\
path = '/nfs/scratch/George/MATLAB_Files/SLURM_Deskew/scripts';\
addpath(genpath(path)); \
saveIllumParam('$1', '$2')
exit()\
\
"; 

# matlab get bk
# ./sleeper.pl 3 0 &

# matlab get chroma
# ./sleeper.pl 2 0 &

for job in `jobs -p`
do
echo $job
    wait $job || let "FAIL+=1"
done

echo $FAIL


if [ "$FAIL" == "0" ];
then
    echo "YAY!"
else
    echo "FAIL! ($FAIL)"
fi