%% LLSM Preprocessing file

% --- --- General preprocessing --- --- --- --- --- --- --- --- --- 
% Flowchart (using these files as an example):          
%   Sort acquisivtons into channels                      -   GU_sort3Dfiles_George_inputOrganize_v3
%   Call the data again and Save the organized [data]   -   save data20180927
%   Illumination correction and deskew                  -   deskewData
%   Get XYZ sigmas for each channel                     -   GU_estimateSigma3D(totalPSF for calibration)
%   Get the centroid of the total PSF                   -   GU_estimateSigma3D(totPSF for chroma offset)
%   Apply chromatic offset (i3f multi chan)              -   GU_zOffset3D

% --- --- Extra preprocessing (if requested) --- --- --- --- --- --- --- --- ---
%   Deconvolution                                       -   GU_cudaDecon


% 
%% Organize acquisitions by channels (laser an1d Camera)
%%
clear; clc; close all;

folder = '/net/10.117.38.184/scratch/Gokul/GU_PrivateRepository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/Gokul/GU_Repository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/George/MATLAB_Files';
addpath(genpath(folder));

%% Get Ex folders directory
foldir = '/net/tkfastfs/scratch/David/20210107_p5_p55_sCMOS_David';
% find all the Ex dirctories
Ex_directories_temp = findExDFS(foldir);

%% get rid of the Ex extention if 1. no tif inside 2. not 3D image
check3Dacquisition(Ex_directories_temp)
Ex_directories_temp = findExDFS(foldir);
%% Add s-plane info if you missed
add_splane_FolName(Ex_directories_temp)

%% Get the updated folderNames
clearvars -except foldir
Ex_directories = findExDFS(foldir);

%% Organize into ch
% 
% data= GU_loadConditionData3D;
% GU_sort3Dfiles_George_inputOrganize_v3(data)

addChannels(Ex_directories)


%% change iteration mode acquisitons name from Iter_1_ to Iter_0001_


chdir= getChdir(Ex_directories);
% change the tifname if iter1 to iter001
changeIter(chdir)

%% Organize acquisitons into channels after CS folder

%% Prototype, loadCondition3D()
% data = KGO_GU_loadConditionData3D(Ex_directories);
%%
% clear;clc
% start=0;
% Data(1).data = GU_loadConditionData3D;
% dataCS1_4= GU_loadConditionData3D;
% dataCS1_456 = GU_loadConditionData3D;
% dataCS2 = GU_loadConditionData3D;
% dataCS3 = GU_loadConditionData3D;
% data5= GU_loadConditionData3D;
% data=[data1 data2 data3 data4];
% data= GU_loadConditionData3D;

idx = 1;
while true
Data(idx).data = GU_loadConditionData3D; idx = idx+1; disp(idx);
% disp(Data(idx-1).data.source);
end
% Data(idx).data = GU_loadConditionData3D; idx = idx+1; disp(idx);
% Data(idx).data = GU_loadConditionData3D; idx = idx+1; disp(idx);
% Data(idx).data = GU_loadConditionData3D; idx = idx+1; disp(idx);
% % N
% Data(idx).data = GU_loadConditionData3D; idx = idx+1; disp(idx);


%%
clc
if start
    t =tic;
    delete(gcp('nocreate'));
    p = parcluster;
    parpool((p.NumWorkers))
    fprintf('Time to intialize %d workers: %dmin %1.2fsec',p.NumWorkers, floor(toc(t)/60), rem(toc(t),60));
    start = 0;
end
%%
illumRt = '/net/tkfastfs/scratch/Gustavo/20201106_p5_p55_sCMOS_Gu/LLSCalibrations/illum/';
illum488CamA = 'i_CamA_ch0_stack0000_488nm_0000000msec_0247664528msecAbs.tif';
illum560CamB = 'i_CamB_ch1_stack0000_560nm_0000000msec_0247664528msecAbs.tif';
illum642CamA ='i_CamA_ch2_stack0000_642nm_0000000msec_0247664528msecAbs.tif';

rt_488 = '/net/tkfastfs/scratch/Alex/20200913_p5_p55_sCMOS_Alex/LLScalibration/chroma/Ex01_488_300mW_560_500mW_642_500mW_z0p5/original/ch488nmCamA/DS/';
rt_560 = '/net/tkfastfs/scratch/Alex/20200913_p5_p55_sCMOS_Alex/LLScalibration/chroma/Ex01_488_300mW_560_500mW_642_500mW_z0p5/original/ch560nmCamB/DS/';
rt_642 = '/net/tkfastfs/scratch/Alex/20200913_p5_p55_sCMOS_Alex/LLScalibration/chroma/Ex01_488_300mW_560_500mW_642_500mW_z0p5/original/ch642nmCamA/DS/';

FileName488camA = 'c_CamA_ch0_stack0000_488nm_0000000msec_0007962586msecAbs.tif';
FileName560camB = 'c_CamB_ch1_stack0000_560nm_0000000msec_0007962586msecAbs.tif';
FileName642camA = 'c_CamA_ch2_stack0000_642nm_0000000msec_0007962586msecAbs.tif';

[~, ~, XYZ488, ~, ~] = GU_estimateSigma3D(rt_488,FileName488camA); % Get XYZ by adding a PSF
[~, ~, XYZ560, ~, ~] = GU_estimateSigma3D(rt_560,FileName560camB); % Get XYZ by adding a PSF
[~, ~, XYZ642, ~, ~] = GU_estimateSigma3D(rt_642,FileName642camA); % Get XYZ by adding a PSF
const = 0.5*sind(31.5);


for ii = 1:length(Data)
    data = Data(ii).data;
%     if ii > 1
%         for idx = 1:length(
    
counter488chan = regexp(data(1).source, '488');
counter560chan = regexp(data(1).source, '560');
counter642chan = regexp(data(1).source, '642');

% delete(gcp('nocreate'))
% parpool(maxNumCompThreads)


camflip = false;


t = tic;
%%%%%%%%%%%%%%%%%%%%%% ONE CHANNEL %%%%%%%%%%%%%%%%%%%%%%
if length(data(1).channels) < 2 && ~isempty(counter488chan)
    disp('488')
    deskewData(data,...
    'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
    'Overwrite', true,... % usually false, want to overwrite the previous data? 
    'crop', false,... % used to limit the FOV from original size to the cropped size
    'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
    'LowerLimit', 0.5,...
    'LSImageCh1', [illumRt,filesep illum488CamA],...
    'BackgroundCh1', '/net/tkfastfs/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
elseif length(data(1).channels) < 2 && ~isempty(counter560chan)
     disp('560')
    deskewData(data,...
    'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
    'Overwrite', true,... % usually false, want to overwrite the previous data? 
    'crop', false,... % used to limit the FOV from original size to the cropped size
    'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
    'LowerLimit', 0.5,...
    'LSImageCh1', [illumRt,filesep illum560CamB],...
    'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif')
elseif length(data(1).channels) < 2 && ~isempty(counter642chan)
     disp('642')
    deskewData(data,...
    'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
    'Overwrite', true,... % usually false, want to overwrite the previous data? 
    'crop', false,... % used to limit the FOV from original size to the cropped size
    'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
    'LowerLimit', 0.5,...
    'LSImageCh1', [illumRt,filesep illum642CamA],...
    'BackgroundCh1', '/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')




%%%%%%%%%%%%%%%%%%%%%% TWO CHANNELS %%%%%%%%%%%%%%%%%%%%%%

elseif length(data(1).channels)==2 && ~isempty(counter560chan) && ~isempty(counter488chan)
    disp('488-560');
    
    deskewData(data,...
        'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
        'Overwrite', true,... % usually false, want to overwrite the previous data?
        'crop', false,... % used to limit the FOV from original size to the cropped size
        'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
        'LowerLimit', 0.5,...
        'LSImageCh1', [illumRt,filesep illum488CamA],...
        'LSImageCh2', [illumRt,filesep illum560CamB],...
        'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif',...
        'BackgroundCh2', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif')
    
    
    
    data_multipleChan = data;
    if length(data_multipleChan(1).channels)== 2
        disp('2 channels')
        if (XYZ488.z < XYZ560.z)
            ch1_488_logical = true;
            ch2_560_logical = false;
        else
            ch1_488_logical = false;
            ch2_560_logical = true;
        end
        GU_zOffset3D(data_multipleChan,...
            'zOffset', abs(XYZ488.z - XYZ560.z)*const,...
            'RawData', false,...
            'DS', true,...
            'Ch1', ch1_488_logical,...
            'Ch2', ch2_560_logical);
    end


elseif length(data(1).channels)==2 && ~isempty(counter642chan) && ~isempty(counter560chan)
    disp('560-642');

      deskewData(data,...
    'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
    'Overwrite', true,... % usually false, want to overwrite the previous data? 
    'crop', false,... % used to limit the FOV from original size to the cropped size
    'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
    'LowerLimit', 0.5,...
    'LSImageCh1', [illumRt,filesep illum560CamB],...
    'LSImageCh2', [illumRt,filesep illum642CamA],...
    'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif',...
    'BackgroundCh2', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')

  %chroma offset
    
    
    
    data_multipleChan =data;
    if length(data_multipleChan(1).channels)== 2
        disp('2 channels')
        if (XYZ488.z < XYZ642.z)
            ch1_488_logical = true;
            ch2_642_logical = false;
        else
            ch1_488_logical = false;
            ch2_642_logical = true;
        end
        GU_zOffset3D(data_multipleChan,...
            'zOffset', abs(XYZ560.z - XYZ642.z)*const,...
            'RawData', false,...
            'DS', true,...
            'Ch1', ch1_488_logical,...
            'Ch2', ch2_642_logical);
    end

elseif length(data(1).channels)==2 && ~isempty(counter642chan) && ~isempty(counter488chan)
    disp('488-642');

      deskewData(data,...
    'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
    'Overwrite', true,... % usually false, want to overwrite the previous data? 
    'crop', false,... % used to limit the FOV from original size to the cropped size
    'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
    'LowerLimit', 0.5,...
    'LSImageCh1', [illumRt,filesep illum488CamA],...
    'LSImageCh2', [illumRt,filesep illum642CamA],...
    'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif',...
    'BackgroundCh2', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')


    
    
    data_multipleChan =data;
    if length(data_multipleChan(1).channels)== 2
        disp('2 channels')
        if (XYZ488.z < XYZ642.z)
            ch1_488_logical = true;
            ch2_642_logical = false;
        else
            ch1_488_logical = false;
            ch2_642_logical = true;
        end
        GU_zOffset3D(data_multipleChan,...
            'zOffset', abs(XYZ488.z - XYZ642.z)*const,...
            'RawData', false,...
            'DS', true,...
            'Ch1', ch1_488_logical,...
            'Ch2', ch2_642_logical);
    end

    
else
    disp('488-560-642')
%     datatemp = [data,data2,data3];
% data = datatemp
     deskewData(data,...
    'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
    'Overwrite', true,... % usually false, want to overwrite the previous data? 
    'crop', false,... % used to limit the FOV from original size to the cropped size
    'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
    'LowerLimit', 0.5,...
    'LSImageCh1', [illumRt,filesep illum488CamA],...
    'LSImageCh2', [illumRt,filesep illum560CamB],...
    'LSImageCh3', [illumRt,filesep illum642CamA],...
    'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif',...
    'BackgroundCh2', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif',...
    'BackgroundCh3', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')

    
    
%     rt_488 = '/net/tkfastfs/scratch/Gustavo/20201022_P5_P55_sCMOS_Gu/LLSCalibrations/chroma/Ex00_488_560_642_z0p5/ch488nmCamA/DS/';
%     rt_560 = '/net/tkfastfs/scratch/Gustavo/20201022_P5_P55_sCMOS_Gu/LLSCalibrations/chroma/Ex00_488_560_642_z0p5/ch560nmCamB/DS/';
%     rt_642 = '/net/tkfastfs/scratch/Gustavo/20201022_P5_P55_sCMOS_Gu/LLSCalibrations/chroma/Ex00_488_560_642_z0p5/ch642nmCamA/DS/';
%     
%     FileName488camA = 'chroma_CamA_ch0_stack0000_488nm_0000000msec_0005999292msecAbs.tif';
%     FileName560camB = 'chroma_CamB_ch1_stack0000_560nm_0000000msec_0005999292msecAbs.tif';
%     FileName642camA = 'chroma_CamA_ch2_stack0000_642nm_0000000msec_0005999292msecAbs.tif';
    
    
%     [~, ~, XYZ488, ~, ~] = GU_estimateSigma3D(rt_488,FileName488camA); % Get XYZ by adding a PSF
%     [~, ~, XYZ560, ~, ~] = GU_estimateSigma3D(rt_560,FileName560camB); % Get XYZ by adding a PSF
%     [~, ~, XYZ642, ~, ~] = GU_estimateSigma3D(rt_642,FileName642camA); % Get XYZ by adding a PSF
%     const = 0.5*sind(31.5);
    
    disp('3 channels') 
    GU_zOffset3D(data,...
        'zOffset', abs(XYZ488.z - XYZ560.z)*const,... 
        'RawData', false,...
        'DS', true,...
        'Ch1', false,... % 488 % adds to the end of the stack (false)
        'Ch2', true,... % 560 % adds to the start of the stack (true)
        'Ch3', true); % 642 % adds to the start of the stack (true)

    GU_zOffset3D(data,...
        'zOffset', abs(XYZ560.z - XYZ642.z)*const,... 
        'RawData', false,...
        'DS', true,...
        'Ch1', false,... % 488 % adds to the start of the stack (true)
        'Ch2', false,... % 560 % adds to the end of the stack (bottom)
        'Ch3', true); % 642 % adds to the start of the stack (true)

      
     
end
% GU_calcImageProjections(data)
end
% tt(ii) =toc(t)
% 
% 
% mean(tt)
% std(tt)

%% Tracking


%%
PSFRt = '/scratch/Alex/20200918_p5_p55_sCMOS_Alex/LLSCalibrations/';
FileName488 = '488totalPSF.tif';
FileName560 = '560totalPSF.tif';
FileName642 = '642totalPSF.tif';



deconDir = '/scratch/Gokul/GU_Repository/cudaDecon/cudaDeconv';
OTFDir = '/scratch/Gokul/GU_Repository/cudaDecon/radialft';
GU_cudaDecon(data,...
    'PSFfileCh1', [PSFRt filesep FileName488],...
    'cudaDeconPath', deconDir,...
    'OTFGENPath', OTFDir,...
    'Verbose', true ,...
    'DS', true,...
    'DSR', false,...
    'Ch_search', {'_560nm_'},...
    'Background', [100]);


