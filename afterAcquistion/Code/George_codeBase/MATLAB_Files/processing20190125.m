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
% % clear; clc; close all;
% % format shortG;
% % % % % tic
% % % % % data = GU_loadConditionData3D;
% % % % % dirFolder = 'Z:\George\MATLAB_Files';
% % % % % cd(dirFolder);
% % % % % GU_sort3Dfiles_George_inputOrganize_v3(data);
% % % % % 
% % % % % %% Call the data again and Save the organized [data]
% % % % % 
% % % % % Only load the volume scan
% % % % % dKangmin20190125 = GU_loadConditionData3D;
% % % % % 
% dirFolder = 'Z:\Kangmin\20190125_p5_p55_sCMOS_Kangmin_SUM_ER\';
% cd(dirFolder);
% save dataKangmin20190125;

%%  Illumination correction and deskew
% Purpose: to correct the shift in the data from the objective's angle
% (31.5d). Also to correct the signal intensities from the LLS for each
% pixel
loadDir = 'Z:\Kangmin\20190125_p5_p55_sCMOS_Kangmin_SUM_ER\';
loadData = 'dataKangmin20190125';
load(fullfile(loadDir,loadData));

% Directory of the illumination profile for each channel
illumRt = 'Z:\Kangmin\20190125_p5_p55_sCMOS_Kangmin_SUM_ER\LLSCalibration\illum\';
illum488CamB = 'i488_CamB_ch0_stack0000_488nm_0000000msec_0005225130msecAbs.tif';
illum560CamA = 'i560_CamA_ch0_stack0000_560nm_0000000msec_0005288884msecAbs.tif';

% start parallel pool for faster processing speed
delete(gcp('nocreate'))
myPool = parpool(16);

% Deskew the data (for sample scan only)
idxMitotic = [13:16,32:38,60:66];
idxInterphase = [1:12,17:31,39:59];
 opts = {'sCMOSCameraFlip', false,... % Is there camera flip? sample moving left-right, then false. Up-down then true
    'Overwrite', false,... % usually false, want to overwrite the previous data? 
    'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
    'LowerLimit', 0.5,...
    'LSImageCh1', [illumRt,illum488CamB],... % load the illumination corr. file (up to three)
    'LSImageCh2', [illumRt,illum560CamA],... % load the illumination corr. file (up to three)
    'BackgroundCh1', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamBDC.tif',...
    'BackgroundCh2', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamADC.tif'};
% deskew mitotic
deskewData( dKangmin20190125(idxMitotic),...
   opts{:},'crop', true); % for each channel, check which camera type (sCMOS/EMCCD) and camera (A/B) was used

% deskew interphase
deskewData(dKangmin20190125(idxInterphase), opts{:},'crop', false); % for each channel, check which camera type (sCMOS/EMCCD) and camera (A/B) was used

% Calculate image projections
GU_calcImageProjections(dKangmin20190125,...
    'DS', true,...
    'CalcProjections', true,...
    'CopyAnalysis', false);

%% Get the centroid of the Chromatic total PSF 
% Purpose: to obtain data to feed the chromatic offset (below)

clc
rt = 'Z:\Kangmin\20190125_p5_p55_sCMOS_Kangmin_SUM_ER\LLSCalibration\Chroma\';
FileName488_ch1 = '488c.tif';
FileName560_ch2 = '560c.tif';

% run ChromaOffset fucntion that saves txt file showing if CO has been run
% or not. 
loadDir = 'Z:\George\MATLAB_Files\';
useFunc = 'GU_zOffset3D';
cd(loadDir);

[sigmaXY488, sigmaZ488, XYZ488, ~, ~] = GU_estimateSigma3D(rt,FileName488_ch1); % Get XYZ by adding a PSF
[sigmaXY560, sigmaZ560, XYZ560, ~, ~] = GU_estimateSigma3D(rt,FileName560_ch2); % Get XYZ by adding a PSF

%  Chromatic offset, assume 2 channels w 488 and 560

% % Purpose: Correct the failure of the lens to focus all lasers channels
% into the same point. Caused by having different wavelengths - which
% causes the refractive index to differ from one another. The image
% observed from LabView is in the XY direction, not in Z. XY correction is
% camAB alignment. in Z, it is chromatic offset correction. 

% 


data_multipleChan = dKangmin20190125(idxInterphase);
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
        'DS', true,...
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



%% Deconvolution
% % 
clc
PSFRt = 'Z:\Kangmin\20190125_p5_p55_sCMOS_Kangmin_SUM_ER\LLSCalibration\';
FileName488 = '488totalPSF.tif';
FileName560 = '560totalPSF.tif';

[sigmaXY488, sigmaZ488, XYZ488, ~, ~] = GU_estimateSigma3D(PSFRt,FileName488); % Get XYZ by adding a PSF
[sigmaXY560, sigmaZ560, XYZ560, ~, ~] = GU_estimateSigma3D(PSFRt,FileName560); % Get XYZ by adding a PSF


GU_cudaDecon(dKangmin20190125(idxInterphase),...
    'PSFfileCh1', [PSFRt FileName488],...
    'PSFfileCh2', [PSFRt FileName560],...
    'cudaDeconPath', 'D:\CudaDecon_windows\cudaDeconv.exe',...
    'OTFGENPath', 'D:\CudaDecon_windows\radialft.exe',...
    'Verbose', true ,...
    'DS', true,...
    'DSR', false,...
    'Ch_search', {'_488nm_','_560nm_'},...
    'Background', [95, 95]);



tt = toc;
fprintf('Sim time: %dmin %1.2f sec\n', floor(tt/60), rem(tt,60));



%% detection

%%
idxNup107 = [13:16,60:66];
idxNup205 = [32:38];


