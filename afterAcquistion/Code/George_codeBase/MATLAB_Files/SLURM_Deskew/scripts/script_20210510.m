
%% Load Balancer / SLURM Deskew

clc; clear; close all;

% Input the source and the sink folders
dirSource = '/llsm/tklab-llsm/20210507_p5_p55_sCMOS_Alex/';
scratch_dirSink = '/scratch/George/';
datasync_dirSink = '/nfs/data1expansion/datasync3/George/';

% set paths of the code
path = '/nfs/scratch/George/MATLAB_Files/SLURM_Deskew/scripts';
addpath(genpath(path));
%% Initialize for the acquisition

% % add path
% paths = {
%      '/net/10.117.38.184/scratch/Gokul/GU_PrivateRepository',...
%      '/net/10.117.38.184/scratch/Gokul/GU_Repository',...
% %      '/net/10.117.38.184/scratch/George/MATLAB_Files'
%     };
% setPath(paths)




Calib = getCalibrationParams(dirSource, scratch_dirSink, datasync_dirSink);













% get the sink directories
dirSink = getSinkDirectories(dirSource, scratch_dirSink, datasync_dirSink);


% Check if the calibration files are acquired
checkCalibrationsComplete(dirSource)



 intialize(dirSource, scratch_dirSink, datasync_dirSink)


%%

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








%{

srun matlab -nodisplay -nosplash -nodesktop -nojvm -r ";tic; disp(1); disp(2); pause(5); toc; exit()"


XR_deskewRotateFrame({'/nfs/scratch/George/George_AutoDS_SampleData/CS1/CS1_SVGAhAce2EEA1ScarletteNPC1HaloJFX646_VSVPeGFPSARSCoV2/Ex10fifteenGFPBleach30min_488nm_50mW_560nm_200mW_642nm_50mW_z0p5/ex10_CamA_ch0_stack0000_488nm_0000000msec_0628594071msecAbs.tif'},1.07999999999999998779e-01,2.99999999999999988898e-01,'SkewAngle',3.24500000000000028422e+01,'ObjectiveScan',false,'Reverse',true,'LLFFCorrection',false,'BKRemoval',false,'LowerLimit',4.00000000000000022204e-01,'LSImage','','BackgroundImage','','Rotate',false,'resample',[1,1,1,],'DSRCombined',false,'flipZstack',true,'Save16bit',true);

matlab -nodisplay -nosplash -nodesktop -nojvm -r \";tic;XR_deskewRotateFrame({'/nfs/scratch/George/George_AutoDS_SampleData/CS1/CS1_SVGAhAce2EEA1ScarletteNPC1HaloJFX646_VSVPeGFPSARSCoV2/Ex10fifteenGFPBleach30min_488nm_50mW_560nm_200mW_642nm_50mW_z0p5/ex10_CamA_ch0_stack0000_488nm_0000000msec_0628594071msecAbs.tif'},1.07999999999999998779e-01,2.99999999999999988898e-01,'SkewAngle',3.24500000000000028422e+01,'ObjectiveScan',false,'Reverse',true,'LLFFCorrection',false,'BKRemoval',false,'LowerLimit',4.00000000000000022204e-01,'LSImage','','BackgroundImage','','Rotate',true,'resample',[1,1,1,],'DSRCombined',false,'flipZstack',false,'Save16bit',true);toc\"


srun matlab -nodisplay -nosplash -nodesktop -nojvm -r"; print(1); exit()"


















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

%}