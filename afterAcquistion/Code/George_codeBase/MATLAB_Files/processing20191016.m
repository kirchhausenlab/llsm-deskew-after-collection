%% LLSM Preprocessing file
% Rasmus -- 20181217, 1218, 1219

% --- --- General preprocessing --- --- --- --- --- --- --- --- --- 
% Flowchart (using these files as an example):
%   Sort acquisitons into channels                      -   GU_sort3Dfiles_George_inputOrganize_v3
%   Call the data again and Save the organized [data]   -   save data20180927
%   Illumination correction and deskew                  -   deskewData
%   Get XYZ sigmas for each channel                     -   GU_estimateSigma3D(totalPSF for calibration)
%   Get the centroid of the total PSF                   -   GU_estimateSigma3D(totPSF for chroma offset)
%   Apply chromatic offset (if multi chan)              -   GU_zOffset3D

% --- --- Extra preprocessing (if requested) --- --- --- --- --- --- --- --- ---
%   Deconvolution                                       -   GU_cudaDecon



%% Organize acquisitions by channels (laser and Camera)
clear; clc; close all;
format shortG;
tic
data = GU_loadConditionData3D;
dirFolder = 'Z:\George\MATLAB_Files';
cd(dirFolder);
GU_sort3Dfiles_George_inputOrganize_v3(data);

%% Call the data again and Save the organized [data]

% Only load the volume scan
disp('Rasmus_20181217'); dRasmus20181217 = GU_loadConditionData3D;

dirFolder = 'Z:\Rasmus\20181217_p5_p55_sCMOS_Rasmus_SVGA3p1_Florin_Arch3_Inside_JF646_Arch3_Outside';
cd(dirFolder);
% save dataRasmus20181217;

%%  Illumination correction and deskew
% Purpose: to correct the shift in the data from the objective's angle
% (31.5d). Also to correct the signal intensities from the LLS for each
% pixel
loadDir = 'Z:\Rasmus\20181217_p5_p55_sCMOS_Rasmus_SVGA3p1_Florin_Arch3_Inside_JF646_Arch3_Outside\';
loadData = 'dataRasmus20181217';

load(fullfile(loadDir,loadData));

% Directory of the illumination profile for each channel
illumRt = 'Z:\Rasmus\20181217_p5_p55_sCMOS_Rasmus_SVGA3p1_Florin_Arch3_Inside_JF646_Arch3_Outside\LLSCalibration\illum\';
illum488CamA = 'i_CamA_ch0_CAM1_stack0000_488nm_0000000msec_0002582352msecAbs_000x_000y_000z_0000t.tif';
illum560CamB = 'i_CamB_ch1_CAM1_stack0000_560nm_0000000msec_0002582352msecAbs_000x_000y_000z_0000t.tif';
illum642CamA = 'i_CamA_ch2_CAM1_stack0000_642nm_0000000msec_0002582352msecAbs_000x_000y_000z_0000t.tif';
% start parallel pool for faster processing speed
delete(gcp('nocreate'))
myPool = parpool(16);

% Deskew the data (for sample scan only)
deskewData(dRasmus20181217(2:end),...
    'sCMOSCameraFlip', true,... % Is there camera flip? sample moving left-right, then false. Up-down then true
    'Overwrite', false,... % usually false, want to overwrite the previous data? 
    'crop', false,... % used to limit the FOV from original size to the cropped size
    'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
    'LowerLimit', 0.5,...
    'LSImageCh1', [illumRt,illum488CamA],... % load the illumination corr. file (up to three)
    'LSImageCh2', [illumRt,illum560CamB],... % load the illumination corr. file (up to three)
    'LSImageCh3', [illumRt,illum642CamA],... % load the illumination corr. file (up to three)
    'BackgroundCh1', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamADC.tif',...
    'BackgroundCh2', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamBDC.tif',...
    'BackgroundCh3', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamADC.tif'); % for each channel, check which camera type (sCMOS/EMCCD) and camera (A/B) was used

%% Calculate image projections


GU_calcImageProjections(dRasmus20181217,...
    'DS', true,...
    'CalcProjections', true,...
    'CopyAnalysis', false);

%% Get XYZ sigmas for each channel 
% % Purpose: to understand the PSF quantitatively
% PSFRt = 'Z:\Mithun\20181101_p5_p55_sCMOS_Mithun_SUM_D50laminae_Progerin_WT_eGFP\LLSCalibrations\';
% PSF488 = '488totalPSF.tif';
% 
% [sigmaXY_488, sigmaZ_488] = GU_estimateSigma3D(PSFRt,PSF488);
% [sigmaXY_560, sigmaZ_560] = GU_estimateSigma3D(PSFRt,PSF560);
% 
% %% Get the centroid of the total PSF 
% % Purpose: to obtain data to feed the chromatic offset (below)
% 
% clc
% rt = 'Z:\Kangmin\20180924_p5_p55_sCMOS_Kangmin_NUP205_Halo549\Day3\LLSCalibrations\Chroma\';
% FileName488 = 'PSF_Chroma_CamB_ch1_stack0000_488nm_0000000msec_0002969229msecAbs.tif';
% FileName560 = 'PSF_Chroma_CamA_ch0_stack0000_560nm_0000000msec_0002969229msecAbs.tif';
% [sigmaXY, sigmaZ, XYZ488, pstruct, mask] = GU_estimateSigma3D(rt,FileName488); % Get XYZ by adding a PSF
% [sigmaXY, sigmaZ, XYZ560, pstruct, mask] = GU_estimateSigma3D(rt,FileName560); % Get XYZ by adding a PSF

%%  Chromatic offset, assume 2 channels w 488 and 560

% % Purpose: (simply): different lasers have different wavelengths, so their
% % focal point (where they align in the eye) is different, so different
% % colors will align at a different spot, although they superimpose in Labview.
% % This code corrects this phenomenon.
% 
% if length(data_2chan_vol(1).channels)> 1
%     if (XYZ488.z < XYZ560.z)
%         ch1_488_logical = true;
%         ch2_560_logical = false;
%     else
%         ch1_488_logical = false;
%         ch2_560_logical = true;
%     end
%     
%     GU_zOffset3D(data_2chan_vol,...
%         'zOffset', abs(XYZ488.z - XYZ560.z)*0.1,...
%         'RawData', false,...
%         'DS', false,...
%         'Ch1', ch1_488_logical, ...
%         'Ch2', ch2_560_logical);
%     
%     GU_zOffset3D(data_2chan_plane,...
%         'zOffset', abs(XYZ488.z - XYZ560.z)*0.1,...
%         'RawData', false,...
%         'DS', false,...
%         'Ch1', ch1_488_logical, ...
%         'Ch2', ch2_560_logical);
% end




%% Deconvolution
% % 
% % clc
% % PSFRt = 'Z:\Kangmin\20180924_p5_p55_sCMOS_Kangmin_NUP205_Halo549\Day0_CalibrationsOnly\LLSCalibration\';
% % FileName488 = '488totalPSF.tif';
% % FileName560 = '560totalPSF.tif';
% % 
% % GU_cudaDecon(data,...
% %     'PSFfileCh1', [PSFRt PSF488],...
% %     'PSFfileCh2', [PSFRt PSF560],...
% %     'cudaDeconPath', 'E:\Gokul\GU_Repository\CudaDecon_windows\cudaDeconv.exe',...
% %     'OTFGENPath', 'E:\Gokul\GU_Repository\CudaDecon_windows\radialft.exe',...
% %     'Verbose', true ,...
% %     'DS', true,...
% %     'DSR', false,...
% %     'Ch_search', {'_488nm_','_560nm_'},...
% %     'Background', [102, 118]);
% % 
% % 
% % 
% % tt = toc;
% % fprintf('Sim time: %dmin %1.2f sec\n', floor(tt/60), rem(tt,60));
% % 




