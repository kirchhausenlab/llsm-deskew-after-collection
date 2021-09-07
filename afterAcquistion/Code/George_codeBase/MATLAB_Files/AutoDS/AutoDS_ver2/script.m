
%% lattice light sheet automatic deskew


%% ------------------------ Load Calibration files  -----------------------------
clear; clc; close all;

folder = '/net/10.117.38.184/scratch/Gokul/GU_PrivateRepository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/Gokul/GU_Repository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/George/MATLAB_Files';
addpath(genpath(folder));

%%
clear; clc; close all;

dirSource = '/llsm/tklab-llsm/20201214_p5_p55_sCMOS_Gu';
dirSink = '/net/tkfastfs/scratch/Gustavo';

% transfer dirSource to dirSink1
dirSink = transferCalibrationFiles(dirSource, dirSink);
%%

% get the illumination correction 
clc

I = getIllum(dirSink);
I.chan
%
clc
% get background 0
B = getBk(dirSink, I.doIllum);
%
clc
% get chromatic offset
C = getChroma(dirSink);

%% ----------------------------- Transfer and deskew files ---------------------------
% Manually select which folder to transfer

dirSource;
dirSink;

transfer = 1;
deskew = 0;

% transferDeskew(dirSource, dirSink, I, B, C, transfer, deskew)    
transferDeskew(dirSource, dirSink, [], [], [], transfer, deskew)   


