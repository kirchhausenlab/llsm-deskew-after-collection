% Optimization of the exisitng software
%{

Couple imporvements can be made 
1. Improve the chromatic offset calculations
O(n) to O(1): hashMap
2. illumination correction computation imprivement
O(n) to O(1) -> probably hashmap
3. Backgrodun hashmap
O(n) to O(1)


%}

clear; clc; close all;

folder = '/net/10.117.38.184/scratch/Gokul/GU_PrivateRepository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/Gokul/GU_Repository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/George/MATLAB_Files';
addpath(genpath(folder));

disp(1)

%%

clear; clc; close all;

dirSource = '/llsm/tklab-llsm/20210423_p5_p55_sCMOS_Alex';
scratch_dirSink = '/nfs/scratch/Gustavo';
datasync_dirSink = '/nfs/data1expansion/datasync3/';


disp('------------------- directory info established -------------------')

%%

% get dirSink_DS3 directories 
[dirSink_ds3_raw, dirSink_ds3_processed] = getDS3Directories(dirSource, datasync_dirSink);

% transfer dirSource to scratch
transferCalibrationFiles2(dirSource, scratch_dirSink);

% transfer dirSource to datasync3
transferCalibrationFiles2_DS3(dirSource, datasync_dirSink);

disp('------------------- Calibration file transfer complete -------------------');

%%

scratchSinkFol = getSinkFol(dirSource, scratch_dirSink);

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

counter =1;
keywords = {};
for ii = 1
    keywords{counter} = sprintf('Ex%02d',ii);
    counter = counter + 1;
end

keywords



%

%

dirSink = scratchSinkFol;

for qq = 1:length(keywords)
keyword = char(keywords{qq});
% keyword = 'Ex08_';
Exs =  findKeywordDFS(dirSource, keyword);

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
    t = tic;
%     preprocess(data, sinkEx, I, B_directories, C)

    preprocess3(data, sinkEx, I, B, C)
    toc(t)
%     
% % % % %     % save the preprocessed data into datasync3, change function name -
% % % % %     % confusing
% % % % %     transferLocalFolderToSink(dirSink_ds3_processed, sinkEx)   
end
end

disp('All compeleted');
disp(1);
