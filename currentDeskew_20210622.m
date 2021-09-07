%% After Acquistion Deskew
% =========================================================================
% Description:
% =========================================================================
%   The detailed protocol for this code is ready and stored:
%       /nfs/data1expansion/datasync3/llsm-deskew/afterAcquistion_20210617/Protocols/After-Collection-deskew.pdf
%       or
%       https://docs.google.com/document/d/12wCAudD5LOY8dr9uM5kSONCDbDZjeoQ7PNIYUeII1Oo/edit?usp=sharing
%
%   This code is divided in two sections:
%       1. Computing the calibration variables
%       2. Carrying out the data preprocessing pipeline, which includes:
%           i.   Illumination Correction
%           ii.  Deskew
%           iii. Chromatic offset (if more than one channel used)
%
%   Run 1. after all the calibration acquistions are complete (illum, bk,
%   chroma)
%   Run 2. after cell/sample acquisiton for each Ex (Ex01, Ex02,...)
%
% =========================================================================
% Assumptions:
% =========================================================================
%   1. Please run the first section of the code (1 above) AFTER the
%   microscopist have acquired the following verified calibration
%   files. Please make sure that the acquisitons are good (check with
%   imageJ)
%       1. Illumination correction in illum/nB_dither folder
%           i. Dithered, collected with the correct Camera
%       2. Chromatic offset in /chroma/Ex%02d_..._z0p%d
%       3. background (dark current) in /bk
%   
%   2. Please follow the following folder structure:
%       /nfs/data1expansion/datasync3/llsm-deskew/afterAcquistion_20210617/Protocols/LLSM_Folder_Structure.pdf
%       or
%       https://docs.google.com/document/d/1BIs-AwhvWZcoKA77HgQDHzT-NPRCguaA41FyH1VW0OE/edit?usp=sharing
%  
%   3. We assume that all experiments (Ex01, Ex02,...) have been collected
%   using a calibrated microscope, and its calibration variables
%   (illumination correction, chromatic offset) are constant. 
%
%   4. Everytime the user changes any microscope variable (except AOTF and
%   laser source power), the user will need to run this code from the
%   beggining with the new /LLSCalibrations. Examples of this include:
%       i. Changing the filters
%       ii. Changing the dichorics (make sure you change the CamSave also)
%       iii. Changing the annulus NA
%       iv. Changing to a different media 
%
% =========================================================================
% Protocol
% =========================================================================
%   1. Acquire calibration acquisitions
%       i.   illumination correction
%       ii.  background (dark current)
%       iii. chromatic offset (only have one bead in the FOV)
%   2. Navigate to your scratch directory
%       ex. /nfs/scratch/George
%   2. Please change the following in the code:
%       i.  dirSource to the D-drive of the lattice computer
%           ex. dirSource = '/llsm/tklab-llsm/20210621_p5_p55_sCMOS_George';
%       ii. scratch_dirSink to the biologist's scratch
%           ex. scratch_dirSink = '/nfs/scratch/George';
%   3. Run the first section of the code
%       until disp('------------------- calibration variables saved to memory -------------------')
%   4. Save cell/sample acquisition to dirSource in LabView. Save Ex%02d
%       ex. Ex01, Ex02, Ex03
%   5. Change ExNumbers to the Ex number 
%       ex. ExNumbers = 1:3 (this means Ex01, Ex02, Ex03)
%   6. Run the second section of the code
%   7. Repeat 5 until no more acquistions
%
% =========================================================================
% Code
% =========================================================================

% clear all variables
clear; clc; close all;

% ------------------------------------------------------------------------
% ************************************************************************
% USER INPUT REQUIRED!!!
%
% dirSource is the d-drive of the lattice, where the acquisitons will be
% saved. 
%   ex. dirSource = '/llsm/tklab-llsm/20210621_p5_p55_sCMOS_George';
% ************************************************************************

dirSource = '/llsm/tklab-llsm/20210807_p5_p55_sCMOS_Alex_CoV2'
%dirSource = '/nfs/scratch/temp_gu';

% ------------------------------------------------------------------------

% ------------------------------------------------------------------------
% ************************************************************************
% USER INPUT REQUIRED!!!
%
% The biologist's scratch directory
%   ex. scratch_dirSink = '/nfs/scratch/George';
% ************************************************************************
scratch_dirSink = '/nfs/scratch/Alex';
% ------------------------------------------------------------------------

% ------------------------------------------------------------------------
% ************************************************************************
% USER INPUT REQUIRED!!!
%
% Number of CPUs you would like to allocate. A rule of thumb is that if you
% have 100 timepoints (100 tifs per channel), then N_CPU = 100. 
% ************************************************************************
N_CPU = 100;
% ------------------------------------------------------------------------

% delete the previous reservation of the CPUs
delete(gcp('nocreate'))

fprintf('------------------- Requsting %d CPUS -------------------\n', N_CPU)
% request the N_CPU from SLURM
parpool(N_CPU)

% message log to notify user
fprintf('------------------- Allocated %d CPUS -------------------\n', N_CPU)

% add the code base to Matlab's path 
folder = '/scratch/llsm-deskew/afterAcquistion_20210617/Code';
addpath(genpath(folder));

% message log to notify user

disp('------------------- code base added to path -------------------')

% datasync3 directory
% For example, the current experiment will be saved in datasync3 in
% /nfs/data1expansion/datasync3/tklab-llsm/20210621_p5_p55_sCMOS_George
datasync_dirSink = '/nfs/data1expansion/datasync3/';

% sink directory for scratch (combines the parent acquistion folder
%   ex. /nfs/scratch/George/20210618_p5_p55_sCMOS_George
scratchSinkFol = getSinkFol(dirSource, scratch_dirSink);

% get dirSink_DS3 directories 
[dirSink_ds3_raw, dirSink_ds3_processed] = getDS3Directories(dirSource, datasync_dirSink);

disp('------------------- directory info established -------------------')

% Transfer calibration folder and compute calibration variables

% transfer dirSource to scratch
transferCalibrationFiles2(dirSource, scratch_dirSink);

% transfer dirSource to datasync3
transferCalibrationFiles2_DS3(dirSource, datasync_dirSink);

disp('------------------- Calibration file transfer complete -------------------');

% Get the illumination correction directories for each channel
I_directories = getIllum(scratchSinkFol);

% Compute illumination correction variable 
I = getIllumImages(I_directories);

% Get the background (darkcurrent) directories for each channel
B_directories = getBk(scratchSinkFol, I.doIllum);

% compute the background (darkcurrent) variable
B = getBkImages(B_directories);

% Get the chromatic offset directories for each channel
C_directories = getChroma2(scratchSinkFol);
try % if you do have chroma folder (aka you did collect the chromatic offset)
    
    % compute the chromatic offset variable
    C = getChromaOffsetValues(C_directories);
catch % if you didnt collect chromatic offset beads (eg. one channel experiment)
    
    % compute the chromatic offset variable
    C.doIllum = false;
end

disp('------------------- calibration variables saved to memory -------------------')

fprintf('\n\n\nYou are now ready to carry out the preprocessing.\nProceed to next section. \nEnter the desired ExNumbers and click Run Section\n\n\n')

%% Reserve nodes, Find the acquisiton folder, preprocess and transfer files

% ------------------------------------------------------------------------
% ************************************************************************
% USER INPUT REQUIRED!!!
%
% Enter the Ex acquisiton numbers.
%   ex. ExNumbers = 3:8; % will preprocess, Ex03, Ex04, ..., Ex08
%   ex. ExNumbers = 43; % will preprocess Ex43
%   ex. ExNumbers = [1,3,12,13,17]; % will preprocess Ex01, Ex03, Ex12,
%   Ex13, Ex17
% ************************************************************************
ExNumbers = 17:19                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            ;
% ------------------------------------------------------------------------

% counter for the loop
counter = 7;
% initialize empty cell
keywords = cell(1,length(ExNumbers));

% change the Ex number here. Default set to Ex02 and Ex03. If just one
% folder, set ii=1 (Ex01)
for ii = ExNumbers
    % fill in the empty cell
    keywords{counter} = sprintf('Ex%02d',ii);
    
    % update the counter
    counter = counter + 1;
end

% show the keywords for checks
disp(keywords)


% set dirSink as scratchSinkFol
dirSink = scratchSinkFol;

% iterate the loop for each keyword
for qq = 1:length(keywords)
    
    % parse the keyword from type cell to type char
    keyword = char(keywords{qq});
    
    % run the search algorithm (depth first search) and find all folders
    % with the same keyword in all subfolders in dirSource. dirSource is
    % lattice's D-drive
    Exs =  findKeywordDFS(dirSource, keyword);
    
    % iterate over all folders (usually should just be one -- since all
    % folders should have unique Ex folder extension)
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
        
        % start the timer
        t = tic;
        
        % do the preprocessing 
        %   a. Illumination correction
        %   b. Deskew
        %   c. Chromatic offset
        preprocess3(data, sinkEx, I, B, C)
        
        % stop the timer and check how long it took
        toc(t);
        
        % transfer the preprocessed data into datasync3
        transferLocalFolderToSink(dirSink_ds3_processed, sinkEx)
    end
end


fprintf('\n\n\n\nPreprocessing completed!!\n\n\n\n');
disp('Change ExNumbers if you have acquired more data')
% disp(1);
