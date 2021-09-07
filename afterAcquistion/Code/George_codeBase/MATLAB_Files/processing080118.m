
%% sort channels
clc;clear;close all;

% Load acquried data from the microscope. In the next step, sort the data
% based on the laser used. 

data = GU_loadConditionData3D;

%% 

% Directions:
% Open GU_sort3Dfiles, and edit the code depending on the used excitation 
% laser wavelength. This will organize the data by "channels", (eg. ch560) 
% by creating a new folder.

GU_sort3Dfiles 

%% reload data

% 560 as 'master' colocalization analysis-> detect object and read out a
% value in a corresponding channel. Channel that im using to run the
% detection is called the master. Anything else is the secondary channels
%   Load the 560, 642 channels you created in the below

data_488_9th = GU_loadConditionData3D;
% % 
% % data_560_10th = GU_loadConditionData3D;  % requires cam flip
% % data_560_15th = GU_loadConditionData3D;  % does not require camera flip
% % data_560 = [data_560_10th data_560_15th];
% % % '642' as 'master'
% % data_642 = [GU_loadC    ASAonditionData3D GU_loadConditionData3D];

%% load controls

% NOTE! illumination correction for 10th (704x360) was smaller than the
% acquired data (704x512). Therefore, we are using the 15th's illumination
% for both days. The images were inspected and the illumination is very
% similar, so this seems valid. 
illumRt_10th = 'Z:\Yi-ying\20180510_p5-p55_sCMOS_Yi-ying_nup-halo_mitotic\LLSCalibrations\illuminations';
illum560_10th = 'i_CamB_ch0_CAM1_stack0000_560nm_0000000msec_0009544603msecAbs_000x_000y_000z_0000t';
illum642_10th = 'i_CamA_ch1_CAM1_stack0000_642nm_0000000msec_0009544603msecAbs_000x_000y_000z_0000t';
illumRt_15th = 'Z:\Yi-ying\20180515_p5-p55_sCMOS_Yi-ying_nup-halo_mitotic\LLSCalibrations\illuminations';
illum560_15th = 'i_CamB_ch0_CAM1_stack0000_560nm_0000000msec_0027985545msecAbs_000x_000y_000z_0000t';
illum642_15th = 'i_CamA_ch1_CAM1_stack0000_642nm_0000000msec_0027985545msecAbs_000x_000y_000z_0000t';

%% measure the PSFs

%  just using PSF values for day 1
PSF560 = 'Z:\Yi-ying\20180510_p5-p55_sCMOS_Yi-ying_nup-halo_mitotic\LLSCalibrations\560totalPSF.tif';
PSF642 = 'Z:\Yi-ying\20180510_p5-p55_sCMOS_Yi-ying_nup-halo_mitotic\LLSCalibrations\642totalPSF.tif';
 [sigmaXY_560_10th, sigmaZ_560_10th] = GU_estimateSigma3D('Z:\Yi-ying\20180510_p5-p55_sCMOS_Yi-ying_nup-halo_mitotic\LLSCalibrations\','560totalPSF.tif');
 [sigmaXY_642_10th, sigmaZ_642_10th] = GU_estimateSigma3D('Z:\Yi-ying\20180510_p5-p55_sCMOS_Yi-ying_nup-halo_mitotic\LLSCalibrations\','642totalPSF.tif');

%% illumination correction and deskew

delete(gcp('nocreate'))
myPool = parpool(30);

deskewData(data_560_15th,...
    'sCMOSCameraFlip', false,...
    'Overwrite', true,...
    'crop', false,...
    'LLFFCorrection', true,...
    'LowerLimit', 0.5,...
    'LSImageCh1', [illumRt_15th filesep illum560_15th '.tif'],...
    'LSImageCh2', [illumRt_15th filesep illum642_15th '.tif'],...
    'BackgroundCh1', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamADC.tif',...
    'BackgroundCh2', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamADC.tif');

deskewData(data_560_10th,...
    'sCMOSCameraFlip', true,...
    'Overwrite', true,...
    'crop', false,...
    'LLFFCorrection', true,...
    'LowerLimit', 0.5,...
    'LSImageCh1', [illumRt_15th filesep illum560_15th '.tif'],...
    'LSImageCh2', [illumRt_15th filesep illum642_15th '.tif'],...
    'BackgroundCh1', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamBDC.tif',...
    'BackgroundCh2', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamADC.tif');

%% z offset correction

GU_zOffset3D(data_560,...
    'zOffset', 0.150,...
    'RawData', false,...
    'DS', true,...
    'Ch1', false,...
    'Ch2', true);



%% deconvolve

delete(gcp('nocreate'))
myPool = parpool(8);

data560_no2plane = [data_560(1:10), data_560(16:24), data_560(26:numel(data_560))];

GU_cudaDecon(data560_no2plane,...
    'PSFfileCh1', PSF560,...
    'PSFfileCh2', PSF642,...
    'cudaDeconPath', 'D:\CudaDecon_windows\cudaDeconv.exe',...
    'OTFGENPath', 'D:\CudaDecon_windows\radialft.exe',...
    'Verbose', false ,...
    'DS', true,...
    'DSR', false,...
    'Ch_search', {'_560nm_', '_642nm_','_642nm_', '_405nm_'},...
    'Background', [101, 101, 101, 101]);

% CPU decon/alternate (better for larger data (more planes), 
% but slower by 1 to 2 order of magnitude (less parralelization)
% GU_Decon


%% detection and tracking 

% first with 560 as 'master'
% ignoring 2 plane data
GU_runDetTrack3d(data560_no2plane, 'Overwrite', false,... 
    'Track', false, ...
    'Sigma', [sigmaXY_560_10th, sigmaZ_560_10th/(4*sind(31.5)); sigmaXY_642_10th, sigmaZ_642_10th/(4*sind(31.5));]);
% then with 642 as 'master'
data642_no2plane = [data_642(1:10), data_642(16:24), data_642(26:numel(data_642))];

GU_runDetTrack3d(data642_no2plane, 'Overwrite', false,...
    'Sigma', [sigmaXY_642_10th, sigmaZ_642_10th/(4*sind(31.5)); sigmaXY_560_10th, sigmaZ_560_10th/(4*sind(31.5));]);


