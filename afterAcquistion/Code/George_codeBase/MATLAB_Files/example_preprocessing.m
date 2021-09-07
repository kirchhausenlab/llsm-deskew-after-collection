%% LLSM Preprocessing file

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
data = GU_loadConditionData3D;
dirFolder = 'Z:\George\MATLAB_Files';
cd(dirFolder);
GU_sort3Dfiles_George_inputOrganize_v3(data);
%%
clear; clc;
data3chan = GU_loadConditionData3D;

% the directory where the user wants to save the .mat file
dirFolder = 'Z:\Rasmus\20200115_p5_p55_sCMOS_RH';
cd(dirFolder);

% name of th e.mat file
save dataRH20200115_mod;

%%  Illumination correction and deskew
% Purpose: to correct the shift in the data from the objective's angle
% (31.5d). Also to correct the signal intensities from the LLS for each
% pixel\
clear; clc; close all;
loadDir = 'Z:\Rasmus\20200115_p5_p55_sCMOS_RH\';
loadData = 'dataRH20200115_mod';
load(fullfile(loadDir,loadData));

% Directory of the illumination profile for each channel
illumRt = 'Z:\Rasmus\20200115_p5_p55_sCMOS_RH\LLSCalibration\illum\';
illum488CamA = 'i_CamA_ch0_stack0000_488nm_0000000msec_0001066895msecAbs.tif';
illum560CamB = 'i_CamB_ch1_stack0000_560nm_0000000msec_0001066895msecAbs.tif';
illum642CamA = 'i_CamA_ch2_stack0000_642nm_0000000msec_0001066895msecAbs.tif';

% start parallel pool for faster processing speed
delete(gcp('nocreate'))
myPool = parpool(36);

% Deskew the data (for sample scan only)5
deskewData(data3chan(14),...
    'sCMOSCameraFlip', true,... % Is there camera flip? sample moving left-right, then false. Up-down then true
    'Overwrite', true,... % usually false, want to overwrite the previous data? 
    'crop', false,... % used to limit the FOV from original size to the cropped size
    'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
    'LowerLimit', 0.5,...
    'LSImageCh1', [illumRt,illum488CamA],... % load the illumination corr. file (up to three)
    'LSImageCh2', [illumRt,illum560CamB],... % load the illumination corr. file (up to three)
    'LSImageCh3', [illumRt,illum642CamA],... % load the illumination corr. file (up to three
    'BackgroundCh1', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamADC.tif',...
    'BackgroundCh2', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamBDC.tif',...
    'BackgroundCh3', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamADC.tif'); % for each channel, check which camera type (sCMOS/EMCCD) and camera (A/B) was used
%
clc
rt = 'Z:\Rasmus\20200115_p5_p55_sCMOS_RH\LLSCalibration\chroma\';
FileName488_ch1 = 'c_CamA_ch0_stack0000_488nm_0000000msec_0004495946msecAbs.tif';
FileName560_ch2 = 'c_CamB_ch1_stack0000_560nm_0000000msec_0004495946msecAbs.tif';
FileName642_ch3 = 'c_CamA_ch2_stack0000_642nm_0000000msec_0004495946msecAbs.tif';

[~, ~, XYZ488, ~, ~] = GU_estimateSigma3D(rt,FileName488_ch1); % Get XYZ by adding a PSF
[~, ~, XYZ560, ~, ~] = GU_estimateSigma3D(rt,FileName560_ch2); % Get XYZ by adding a PSF
[~, ~, XYZ642, ~, ~] = GU_estimateSigma3D(rt,FileName642_ch3); % Get XYZ by adding a PSF

%  Chromatic offset, assume 2 channels w 488 and 560

% % Purpose: Correct the failure of the lens to focus all lasers channels
% into the same point. Caused by having different wavelengths - which
% causes the refractive index to differ from one another. The image
% observed from LabView is in the XY direction, not in Z. XY correction is
% camAB alignment. in Z, it is chromatic offset correction. 
%
data_multipleChan = data3chan(12:end);
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
        'zOffset', abs(XYZ488.z - XYZ560.z)*0.1,...
        'RawData', false,...
        'DS', false,...
        'Ch1', ch1_488_logical,...
        'Ch2', ch2_560_logical);
    
elseif length(data_multipleChan(1).channels)== 3
    disp('3 channels') 
    GU_zOffset3D(data_multipleChan,...
        'zOffset', abs(XYZ488.z - XYZ560.z)*0.1,... 
        'RawData', false,...
        'DS', true,...
        'Ch1', false,... % 488 % adds to the end of the stack (false)
        'Ch2', true,... % 560 % adds to the start of the stack (true)
        'Ch3', true); % 642 % adds to the start of the stack (true)

    GU_zOffset3D(data_multipleChan,...
        'zOffset', abs(XYZ560.z - XYZ642.z)*0.1,... 
        'RawData', false,...
        'DS', true,...
        'Ch1', false,... % 488 % adds to the start of the stack (true)
        'Ch2', false,... % 560 % adds to the end of the stack (bottom)
        'Ch3', true); % 642 % adds to the start of the stack (true)
end
cd('Z:\George\MATLAB_Files')
addChromatxt(data_multipleChan(1))

% cd('Z:\George\MATLAB_Files')
% deleteChromatxt(data_multipleChan)


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




