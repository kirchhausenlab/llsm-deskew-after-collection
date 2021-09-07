%% After acquisiton deskew

%{
Description:
    Preprocesses images acquired from the llsm and transfers it to scratch
    and datasync3 servers. datasync3 is divided into two: raw and
    processed. Only raw will be flagged

Assumption:
    1. the user should run the code after all calibration files are
    acquired (illum, chroma, bk)

    2. run the deskew only after all of the tif files have finished
    collecting on the d-drive

    3. When running deskew, the keyword used to find the acquisiton folder
    is unique -- no duplicates (eg. Ex02_ and Ex02afterexperiment_. keyword
    = Ex02. This will process and overwrite both folders with Ex02)

    4. The user follows the determined folder structure when acquiring data

%}

%% Set path 
% clear everything in cache
clear; clc; close all;


% add Gokul's private repo into the path
folder = '/net/10.117.38.184/scratch/Gokul/GU_PrivateRepository';
addpath(genpath(folder));

% add Gokul's repo to the path
folder = '/net/10.117.38.184/scratch/Gokul/GU_Repository';
addpath(genpath(folder));

% add George's repo into the path
folder = '/net/10.117.38.184/scratch/George/MATLAB_Files';
addpath(genpath(folder));

disp(1)

%% Set source and sink directories

% clear cache
clear; clc; close all;


% set the source directory -- lattice D drive
dirSource = '/llsm/tklab-llsm/20210615_p5_p55_sCMOS_George';

% set the scratch sink directory -- set to the biologists scratch
scratch_dirSink = '/nfs/scratch/George';

% datasync3 sink directory -- DO NOT TOUCH
datasync_dirSink = '/nfs/data1expansion/datasync3/';

% get dirSink_DS3 directories -- you will have both 
%   datasync3-raw and datasync3-processed
[dirSink_ds3_raw, dirSink_ds3_processed] = getDS3Directories(dirSource, datasync_dirSink);


% get the Sink folder for scratch 
scratchSinkFol = getSinkFol(dirSource, scratch_dirSink);


disp('------------------- directory info established -------------------')

%% Transfer the calibration folders


% transfer the calibration files from dirSource to scratch
transferCalibrationFiles2(dirSource, scratch_dirSink);

% transfer the calibration folders from dirSource to datasync3
transferCalibrationFiles2_DS3(dirSource, datasync_dirSink);

disp('------------------- Calibration file transfer complete -------------------');

%% get the calibration variables


I_directories = getIllum(scratchSinkFol);
% I_directory.chan
I = getIllumImages(I_directories);

% % get background 
B_directories = getBk(scratchSinkFol, I.doIllum);
B = getBkImages(B_directories);

%
% clc
% IF YOU DONT HAVE CHROMATIC BEADS, DONT RUN LINE 72, 73, EXECUTE 69 ONLY
% C.doChroma = false
% 
% % get chromatic offset
C_directories = getChroma2(scratchSinkFol);
C = getChromaOffsetValues(C_directories);

disp(1)

%%
%{
Depending on the size of your tif files, the user should request the number
of CPUS to reserve for your usage. Execute the command

parpool(N)

where N is the number of CPUS
Once you are done, make sure to relinquish the cpus from your reservation.

You can also check how many are in the cluster, available, who is using it
by opening Termina > execute "sview"


%}

%% Preprocess the acquisition per Ex folder

%{
To deskew Ex01, set ii = 1.
To deskew Ex03, Ex04, Ex05, set ii=3:5
%}

% load('/nfs/scratch/George/MATLAB_Files/SLURM_Deskew/20210616/testing/data')
counter =1;

keywords = {};
for ii = 2
    keywords{counter} = sprintf('Ex%02d_',ii);
    counter = counter + 1;
end

disp(keywords)



%%


%{
1. Find the acquistion folder
2. Check if the settings file are there
    true: transfer to scratch, ds3_raw, ds3_processed
    false: wait, check again every second (should be quick)
3. Check which tif files are compelted, load all tif into memory

------------- SLURM part --------------------------------------------------

while loop, until all tif is transferred 
    - from settings file or
    - wait time too long (lets say five consecutive 1 mins)

    4. For each tif, do:
        i. async transfer to the scratch sink. Once one of the tif is transferred do async:
            a. Transfer to datasync3_raw
            b. Start the preprocess for current tif. Once this is compelte, do
            using the same cpu:
                1. Transfer to ds3_processed

%}
dirSink = scratchSinkFol;
%
% loop through each keyword sequentially
for qq = 1:length(keywords)
    % change the keyword from type cell to type char
    keyword = char(keywords{qq});
    
    % find all acquisition folder with the keyword (can be more than one)
    Exs =  findKeywordDFS(dirSource, keyword);
    
    for ii=1:length(Exs)
        
        % Ex acquisiton folder
        Ex = Exs{ii};
        
        
        % check settings file. Transfer if found
        transferSettingsFile(Ex, scratchSinkFol, dirSink_ds3_raw, dirSink_ds3_processed)
        
        while true
            
            % check if the settings file has been populated in the
            % acquistion folder, transfer if true. Wait if false
            
            
            % get all the tif images
            
            
            
            
        end
        
        
        
        % get all the tif files into the acquisiton folder
% % % %         
% % % %         % transfer from local to scratch
% % % %         sinkEx = transferLocalToSink(dirSink, Ex);
% % % %         
% % % %         % transfer from local to datasync3/raw, add flag
% % % %         transferLocalToSink(dirSink_ds3_raw, Ex);
% % % %         
% % % %         % change name for scripting mode
% % % %         checkIter(Ex)
% % % %         
% % % %         % organize scartch folders into channels
% % % %         addChannels(sinkEx)
% % % %         
% % % %         % load the data
% % % %         data = AutoGU_loadConditionData3D(sinkEx);
% % % %         
% % % %         % preprocess, deskew, illum correction, chromatic offset
% % % %         t = tic;
% % % %         %     preprocess(data, sinkEx, I, B_directories, C)
% % % %         
% % % %         % preprocess
% % % %         preprocess3(data, sinkEx, I, B, C)
% % % %         toc(t)
% % % %         %
% % % %         
% % % %         % transfer the raw and the preprocessed files to datasync3/processed, no flag
% % % %         transferLocalFolderToSink(dirSink_ds3_processed, sinkEx)
    end
end


disp('\n\n\n')
disp('All compeleted');
disp(1);
