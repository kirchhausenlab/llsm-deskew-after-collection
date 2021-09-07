%%
folder = '/net/10.117.38.184/scratch/Gokul/GU_PrivateRepository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/Gokul/GU_Repository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/George/MATLAB_Files';
addpath(genpath(folder));

%% Deskew per each image

clear; clc; close all;

d = dir('/nfs/scratch/George/LoadBalancer/_sh/compiled/20210405/matlabcode/source/Ex01_488nm_100mW_560nm_200mW_642nm_50mW_z0p5/*.tif');
d = dir('/scratch/Gustavo/20210408/Ex00_488nm_300mW_z0p1/*.tif');

% dirSink = '/nfs/scratch/George/LoadBalancer/_sh/compiled/20210331/source/Ex01_488nm_100mW_560nm_200mW_642nm_50mW_z0p5';

for ii = 1:length(d)
    % system(srun deskew)
    tif = [d(ii).folder filesep d(ii).name];
    deskewImage(tif)
    
end