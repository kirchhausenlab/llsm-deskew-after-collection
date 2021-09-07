% Check if you can submit matlab code to slurm
% input: Number
% output: display number

function testCase1(N)
pause(10)
disp('Check sview')

disp(N)
pause(10)

end

% GO TO TERMINAL, GO TO CD OF THIS FOLDER, THEN EXECTUTE:
% srun matlab -nodisplay -nosplash -nodesktop -nojvm -r ";tic; testCase1(100); toc; exit()"
