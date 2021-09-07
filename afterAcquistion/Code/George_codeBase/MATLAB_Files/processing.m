
%% sort channels

% % Directions

% example: load the file on this address
% "Z:\George\Example_Folder_For_Simon\VSV\LowMOI\Ex02_pHrodo_G_mCherry_M_488_300mW_560_50mW_z0p4"
% Select 2 channels (channels means the laser name, so we used 488 and
% 560). 
% When they want the channel folder, select the same folder as above.
% When asked for the marker, type in "gfp"

format shortG;
tic
data = GU_loadConditionData3D;

%%

% Directions:
% Open GU_sort3Dfiles, and edit the code depending on the used excitation
% laser wavelength. This will organize the data by "channels", (eg. ch560)
% by creating a new folder.

% This looks at the data.source, and sorts the tiff by the channels
% eg. if there are tiff images with the name 560 and 488, it creates a
% folder called "ch560" and "ch488", and sorts the tiff images in the
% respective folders

% open this file and run it manually from the For_Simon folder
GU_sort3Dfiles_George_inputOrganize_v3;

%% reload data

% reload the data. 
% Condition Folder: "Z:\George\Example_Folder_For_Simon\VSV\LowMOI\Ex02_pHrodo_G_mCherry_M_488_300mW_560_50mW_z0p4"
% 3 channels
% master channel: "Zobtain:\George\Example_Folder_For_Simon\VSV\LowMOI\Ex02_pHrodo_G_mCherry_M_488_300mW_560_50mW_z0p4\ch488"
% second channel: "Z:\George\Example_Folder_For_Simon\VSV\LowMOI\Ex02_pHrodo_G_mCherry_M_488_300mW_560_50mW_z0p4\ch560"
d = GU_loadConditionData3D;


%% load controls, HAVE pz04

% Illumination correction
% Purpose: (in simple terms) inpwhen images are acquired from the lattice, the
% signals we get is not the actual signal, so we need to correct this to
% the proper value. 

illumRt = 'Z:\George\20180808_p5_p55_sCMOS_George_SUM_EPSIN1_HIP1R\LLSCalibration\illumination';
% We used both 488 and 560, so create two

illum488 = 'i_CamA_ch0_stack0000_488nm_0000000msec_0000079391msecAbs.tif\';
illum560 = 'i_CamA_ch1_stack0000_560nm_0000000msec_0000079391msecAbs.tif\'; 

% measure the PSFs (always use the total PSF!)
PSF488 = 'Z:\George\20180808_p5_p55_sCMOS_George_SUM_EPSIN1_HIP1R\LLSCalibration\488totalPSF.tif\'; 
PSF560 = 'Z:\George\20180808_p5_p55_sCMOS_George_SUM_EPSIN1_HIP1R\LLSCalibration\560totalPSF.tif\';
[sigmaXY_488, sigmaZ_488] = GU_estimateSigma3D('Z:\George\20180808_p5_p55_sCMOS_George_SUM_EPSIN1_HIP1R\LLSCalibration\','488totalPSF.tif');
[sigmaXY_560, sigmaZ_560] = GU_estimateSigma3D('Z:\George\20180808_p5_p55_sCMOS_George_SUM_EPSIN1_HIP1R\LLSCalibration\','560totalPSF.tif');

% illumination correction and deskew
delete(gcp('nocreate'))
myPool = parpool(30);
%
deskewData(data_3chan,...
    'sCMOSCameraFlip', false,... % Is there camera flip?
    'Overwrite', false,... 
    'crop', false,...
    'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
    'LowerLimit', 0.5,...
    'LSImageCh1', 'Z:\George\20180808_p5_p55_sCMOS_George_SUM_EPSIN1_HIP1R\LLSCalibration\illuminations\i_CamA_ch1_stack0000_560nm_0000000msec_0000079391msecAbs.tif',...
    'LSImageCh2', 'Z:\George\20180808_p5_p55_sCMOS_George_SUM_EPSIN1_HIP1R\LLSCalibration\illuminations\i_CamA_ch0_stack0000_488nm_0000000msec_0000079391msecAbs.tif',...
    'BackgroundCh1', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamBDC.tif',...
    'BackgroundCh2', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamADC.tif'); % For sCMOS camera
%


%
% we have CH1 and Ch2, bc we have 2 channels. If one channel, then take
% away names that has Ch2. 
% % deskewData(data_3chan,...
% %     'sCMOSCameraFlip', false,... % Is there camera flip?
% %     'Overwrite', true,... 
% %     'crop', true,...
% %     'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
% %     'LowerLimit', 0.5,...
% %     'LSImageCh1', [illumRt filesep illum488],...
% %     'LSImageCh2', [illumRt filesep illum560],...
% %     'LSImageCh3', [illumRt filesep illum560],...
% %     'BackgroundCh1', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamADC.tif',...
% %     'BackgroundCh2', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamBDC.tif',...
% %     'BackgroundCh3', 'Z:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamBDC.tif'); % For sCMOS camera

% Chromatic offset

% Purpose: (simply): different lasers have different wavelengths, so their
% focal point (where they align in the eye) is different, so different
% colors will align at a different spot, although they should superimpose.
% This code corrects this phenomenon.

clc
rt = 'Z:\George\20180808_p5_p55_sCMOS_George_SUM_EPSIN1_HIP1R\LLSCalibration\ChromaticOffset\';
FileName488 = '488totalPSF_Chroma.tif';
FileName560 = '560totalPSF_Chroma.tif';
[sigmaXY, sigmaZ, XYZ488, pstruct, mask] = GU_estimateSigma3D(rt,FileName488); % Get XYZ by adding a PSF
[sigmaXY, sigmaZ, XYZ560, pstruct, mask] = GU_estimateSigma3D(rt,FileName560); % Get XYZ by adding a PSF

if length(data_3chan(1).channels)> 1
    if (XYZ488.z < XYZ560.z)
        ch1_488_logical = true;
        ch2_560_logical = false;
    else
        ch1_488_logical = false;
        ch2_560_logical = true;
    end
    
    GU_zOffset3D(data_3chan,...
        'zOffset', abs(XYZ488.z - XYZ560.z)*0.1,...
        'RawData', false,...
        'DS', false,...
        'Ch1', ch1_560_logical, ...
        'Ch2', ch2_488_logical);
end


GU_ImageProjections



%%
data488_no2plane = [data_2chan];%, data_488(2) data_488(3)];

GU_cudaDecon(data_2chan,...
    'PSFfileCh1', PSF488,...-
    'PSFfileCh2', PSF560,...
    'cudaDeconPath', 'E:\Gokul\GU_Repository\CudaDecon_windows\cudaDeconv.exe',...
    'OTFGENPath', 'E:\Gokul\GU_Repository\CudaDecon_windows\radialft.exe',...
    'Verbose', true ,...
    'DS', false,...
    'DSR', false,...
    'Ch_search', {'_488nm_','_560nm_'},...
    'Background', [101, 101, 101, 101]);


tt = toc;
fprintf('Sim time: %dmin %1.2f sec\n', floor(tt/60), rem(tt,60));



%% detection and tracking

% @ SIMON, you dont need to run this


% first with 560 as 'master'
% ignoring 2 plane data
GU_runDetTrack3d(data488_no2plane, 'Overwrite', false,...
    'Track', false, ...
    'Sigma', [sigmaXY_488, sigmaZ_488/(4*sind(31.5))]);
% then with 642 as 'master'



% % first with 560 as 'master'
% % ignoring 2 plane data
% GU_runDetTrack3d(data488_no2plane, 'Overwrite', false,...
%     'Track', false, ...
%     'Sigma', [sigmaXY_488, sigmaZ_488/(4*sind(31.5)); sigmaXY_642_10th, sigmaZ_642_10th/(4*sind(31.5));]);
% % then with 642 as 'master'
% data642_no2plane = [data_642(1:10), data_642(16:24), data_642(26:numel(data_642))];
% 
% GU_runDetTrack3d(data642_no2plane, 'Overwrite', false,...
%     'Sigma', [sigmaXY_642_10th, sigmaZ_642_10th/(4*sind(31.5)); sigmaXY_488, sigmaZ_488/(4*sind(31.5));]);


%% bleaching rate
 % Analysis
data = data_2chan;
datasets = numel(data);
file = dir(data(1).source);
frames =0; % find the number of frames (should be 60)
for ii = 1:size(file,1)
    if numel(file(ii).name) > 6 % find if the tif images start with 'ex'
        if (file(ii).name(1:2) == 'ex')
            frames = frames + 1;
        end
    end
    
end

bk = 115;
% frames = numel(dir(data(1).source)); % all experiments have the same frame number in this case
meanIntensity = zeros(datasets,frames);

for kk = 1:datasets
    
    imag = dir(data(kk).source);
    experimentName = sprintf('ex%d',kk);
    
    counter = 1;
    for ii = 1:frames % first two files are 'Analysis' and 'DS', so skip those
        if numel(imag(ii).name) > 3 % find if the tif images start with 'ex1'
            if (imag(ii).name(1:3) == experimentName)
                im = imread([data(kk).source, imag(ii).name]);
                imc = im-bk;
                meanIntensity(kk,counter) = sum(imc(:))/sum((im(:)>0));
                counter = counter +1;
            end
        end
    end
    
    
end

% Plotting
figure(1);
set(gcf,'Units','inches','Position',[0,0,4,2]); close
set(gcf,'color','w');
set(gcf,'PaperSize', [10 10]);
set(gcf,'PaperPositionMode','auto');

hold on;
for jj = 1:size(meanIntensity,1)
    h(jj)= plot(meanIntensity(jj,:),'Marker','o');
end

ylabel('Mean Intensity');
xlabel('Frame number');

ax = gca; 
ax.FontSize = 12;

str = {'Cell_1','Cell_2','Cell_2'};
L = legend(str);
L.Box = 'off';

%% 

GU_calcImageProjections(data_2chan, ...
    'DS', true,...
    'CalcProjections', true,...
    'CopyAnalysis', false,...
    'CopySMAnalysis', false,...
    'MovieSelector', 'EX');








