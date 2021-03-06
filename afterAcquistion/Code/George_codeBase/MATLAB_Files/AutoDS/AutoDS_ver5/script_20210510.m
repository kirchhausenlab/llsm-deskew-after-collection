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

disp('------------------ directory info established -------------------')


%% 


% get dirSink_DS3 directories 
[dirSink_ds3_raw, dirSink_ds3_processed] = getDS3Directories(dirSource, datasync_dirSink);

% transfer dirSource to scratch
transferCalibrationFiles2(dirSource, scratch_dirSink);

% transfer dirSource to datasync3
transferCalibrationFiles2_DS3(dirSource, datasync_dirSink);

disp('------------------- Calibration file transfer complete -------------------');

%% 

scratchSinkFol = getSinkFol(dirSource, scratch_dirSink)

I_directories = getIllum(scratchSinkFol);
% I_directory.chan
I = getIllumImages(I_directories);

% % get background 
B_directories = getBk(scratchSinkFol, I.doIllum);
B = getBkImages(B_directories);

% % get chromatic offset
C_directories = getChroma2(scratchSinkFol);
C = getChromaOffsetValues(C_directories);

disp(1)

%% FIND THE ACQUISITION FOLDER





%% LOAD THE DATA INTO A DATA STRUCTURE

% load('/nfs/scratch/George/MATLAB_Files/AutoDS/AutoDS_ver5/data.mat')

Exs = 6;
keywords = cell(1,length(Exs));
for ii = 1:length(Exs)
    keywords{ii} = sprintf('Ex%02d_',Exs(ii));
end

Exs_llsm_dir ={};
for qq = 1:length(keywords)
    keyword = char(keywords{qq});
    % keyword = 'Ex08_';
    Exs_llsm_dir=  findKeywordDFS(dirSource, keyword);
end

[data_original] = AutoSLURM_GU_loadConditionData3D(char(Exs_llsm_dir{1}));
data = Unwrap_loadConditionData(data_original)

%%
sourceEx = Exs_llsm_dir{1}
for ii = 1:length(data)
  preprocess5(data(ii), sourceEx, I, B, C)
% preprocess3(data, sinkEx, I, B, C)
    
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

