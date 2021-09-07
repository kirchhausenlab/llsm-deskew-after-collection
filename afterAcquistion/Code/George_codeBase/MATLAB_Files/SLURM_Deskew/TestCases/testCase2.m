% deskew one image to slurm

function testCase2()

clear; clc; close all;
disp('--------- initializing automatic deskew ----------');

folder = '/net/10.117.38.184/scratch/Gokul/GU_PrivateRepository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/Gokul/GU_Repository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/George/MATLAB_Files';
addpath(genpath(folder));

disp('------------------- Loaded paths -------------------')


disp('Pause 10: deskew an image')
pause(10)
% get the Ex directory

% get the Metadata






disp('Completed')
pause(10)

end

% GO TO TERMINAL, GO TO CD OF THIS FOLDER, THEN EXECTUTE:
% srun matlab -nodisplay -nosplash -nodesktop -nojvm -r ";tic; testCase1(100); toc; exit()"
