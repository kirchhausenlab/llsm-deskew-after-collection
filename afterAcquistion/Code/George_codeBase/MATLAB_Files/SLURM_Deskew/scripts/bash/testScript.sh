#!/bin/bash
srun matlab \
-nodisplay -nosplash -nodesktop -nojvm -r \
";\
\
tic; \
disp(1);\
disp(2); \
pause(5); \
toc; \
exit()\
\
"

# chmod u+r+x testScript.sh
# sh testScript.sh 