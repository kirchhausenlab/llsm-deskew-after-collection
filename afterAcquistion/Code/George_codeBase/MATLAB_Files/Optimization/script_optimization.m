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

dirSource = '/llsm/tklab-llsm/George_AutoDS_SampleData';
scratch_dirSink = '/nfs/scratch/George';
datasync_dirSink = '/nfs/data1expansion/datasync3/George/';


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

% [I, B, C] = getInputFiles(scratchSinkFol)

I_directories = getIllum(scratchSinkFol);
% I_directory.chan
I = getIllumImages(I_directories);

% % get background 
B_directories = getBk(scratchSinkFol, I.doIllum);
B = getBkImages(B_directories);

% %
% clc
% get chromatic offset
C_directories = getChroma2(scratchSinkFol);
C = getChromaOffsetValues(C_directories);

disp(1)

%%

counter =1;
keywords = {};
for ii = 12
    keywords{counter} = sprintf('Ex%02d',ii-1);
    counter = counter + 1;
end

keywords

%% 


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
    preprocess(data, sinkEx, I, B_directories, C)

%     preprocess3(data, sinkEx, I, B, C)
    toc(t)

%     transferLocalFolderToSink(dirSink_ds3_processed, sinkEx)   
end
end

disp('All compeleted');
disp(1);


%% OPTMIZATION
load('/nfs/scratch/George/MATLAB_Files/Optimization/optimizationData.mat')
% parpool(1)
%%
% save
clc
n=1;

preOpt = zeros(1,n);
postOpt = zeros(1,n);
for ii = 1:n
    t = tic;
    preprocess(data, sinkEx, I, B_directories, C)
    
    preOpt(ii) = toc(t);

end

for ii = 1:n
    
    t = tic;
    preprocess3(data, sinkEx, I, B, C)
    
    postOpt(ii) = toc(t);
end

mpre = mean(preOpt)
mpost = mean(postOpt)
