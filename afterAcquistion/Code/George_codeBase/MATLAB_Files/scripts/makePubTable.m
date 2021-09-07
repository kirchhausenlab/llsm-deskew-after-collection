%% Make table from LLSM folder
% 
% Input: Folder directory acquired by the LLSM
% Output: Table that is used for publication/ documentation online

% sample 
% https://docs.google.com/spreadsheets/d/1kqab9kVX5Li44cw3JqCJWc48982sXFkMINOHO8nuZXY/edit#gid=61518901

% SUCCESS on
% foldir = '/Volumes/scratch/Gustavo/20201022_P5_P55_sCMOS_Gu';

%%
clear; clc; close all;

% foldir = '/Volumes/scratch/Gustavo/20201022_P5_P55_sCMOS_Gu';
foldir = '/net/tkfastfs/scratch/Gustavo/20201222_p5_p55_sCMOS_Gu';


% find all the Ex dirctories
Ex_directories = findExDFS(foldir);
% %
% 
% % get MetaData for each Ex
Meta = getMeta(Ex_directories);

%% get camera type:
camType = getCameraType(foldir);

%% Lattice Mode
Mode = getMode(Meta);

%% Cell Samples and Flouresent Labels
% cellTags = getCellTags(Ex_directories)

%% Filters, Dicrhoics


%% get voxel volume
% for each acquisitions, get the voxel information
% output: 104.5nm x 104.5nm x [dz-nm]/[ds-nm] 
vox = getVoxelVolume(Meta);

%% Get Image pixels (Raw and DS)
imPixRawDS = getImagePix(Meta);

%% get the # of timepoints (stacks), imaging time + wait time

N = gettimepoints(Ex_directories, Meta);

Time = getImWaitTime(Meta, N); % output in milliseconds

% adjust for multiple exposure time


%% Make table 
% example 1

% load patients.mat
% T = table(LastName,Age,Weight,Smoker);
% filename = 'patientdata.xlsx';
% 
% writetable(T,filename,'Sheet','MyNewSheet','WriteVariableNames',false);
% T = table(camType
% filename = 'test.xlsx';
% T = table(Mode)
% writetable(T,filename,'Sheet','MyNewSheet','WriteVariableNames',false);



