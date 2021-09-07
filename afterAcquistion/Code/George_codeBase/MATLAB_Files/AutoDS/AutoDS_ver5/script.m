%% add path

clear; clc; close all;
disp('--------- initializing automatic deskew ----------');

folder = '/net/10.117.38.184/scratch/Gokul/GU_PrivateRepository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/Gokul/GU_Repository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/George/MATLAB_Files';
addpath(genpath(folder));

disp('------------------- Loaded paths -------------------')

%% Input the source and the sink folders
clear; clc; close all;

dirSource = '/llsm/tklab-llsm/20210507_p5_p55_sCMOS_Alex/';
scratch_dirSink = '/scratch/George/';
datasync_dirSink = '/nfs/data1expansion/datasync3/George/';

disp('------------------- directory info established -------------------')

%% Transfer the calibration files

% transfer dirSource to scratch
transferCalibrationFiles2(dirSource, scratch_dirSink);

% transfer dirSource to datasync3
transferCalibrationFiles2_DS3(dirSource, datasync_dirSink);

disp('------------------- Calibration file transfer complete -------------------');

 %% Load input directory

scratchSinkFol = getSinkFol(dirSource, scratch_dirSink);

% [I, B, C] = getInputFiles(scratchSinkFol)

I = getIllum(scratchSinkFol);
I.chan
%
clc
% get background 
B = getBk(scratchSinkFol, I.doIllum);
%
clc
% get chromatic offset
C = getChroma2(scratchSinkFol);

%% Select the Ex folders

load('data.mat')

Exs = [1, 2];
Exs = 1;
keywords = cell(1,length(Exs));
for ii = 1:length(Exs)
    keywords{ii} = sprintf('Ex%02d_',Exs(ii));
end

%%
%{
Load the folders as [loadConditionData], 

trim the last stack
transfer to scratch/ds3
run deskew
%}
Exs_llsm_dir ={};
for qq = 1:length(keywords)
    keyword = char(keywords{qq});
    % keyword = 'Ex08_';
    Exs_llsm_dir(qq) =  findKeywordDFS(dirSource, keyword);
end
%%
clear
load('/nfs/scratch/George/AutoDS_data/data.mat');
% transfer the dirs (if the size are the same)

OnlyDeskewFirstStack = zeros(1,length(Exs_llsm_dir));

AutoDS_ver5(scratch_dirSink,datasync_dirSink, Exs_llsm_dir, OnlyDeskewFirstStack)



%%
    
    for ii=1:length(Exs)
        % Ex acquisiton folder
        Ex = Exs{ii};
        
        % transfer from local to scratch
        sinkEx = transferLocalToSink(dirSink, Ex);
        
        % transfer from local to datasync3/raw
        transferLocalToSink(dirSink_ds3_raw, Ex);
        
        % change name for scripting mode
        checkIter(Ex)
        
        % organize scartch folders into channels
        addChannels(sinkEx)
        
        % load the data
        data = AutoGU_loadConditionData3D(sinkEx);
        
        % preprocess, deskew, illum correction, chromatic offset
        preprocess(data, sinkEx, I, B, C)
        
        % save the preprocessed data into datasync3, change function name -
        % confusing
        transferLocalFolderToSink(dirSink_ds3_processed, sinkEx)
    end


disp('All compeleted');
disp(1);

