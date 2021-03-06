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
clear;clc
foldir = '/scratch/Ricardo/02042021/check';
% find all the Ex dirctories
% % % Ex_directories_temp = findExDFS(foldir);
% % % 
% % % % get rid of the Ex extention if 1. no tif inside 2. not 3D image
% % % 
% % % % check if 3D image by looking at Meta file
% % % check3Dacquisition(Ex_directories_temp)
% % % Ex_directories_temp = findExDFS(foldir);
% % % % Add s-plane info if you missed
% % % add_splane_FolName2(Ex_directories_temp)

% Get the updated folderNames
clearvars -except foldir
%
Ex_directories = findExDFS(foldir);

% Organize into ch
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

%% Deskew Chroma
clc
data = AutoGU_loadConditionData3D(Ex_directories{1});
%data = GU_loadConditionData3D
 deskewData(data,...
    'sCMOSCameraFlip', false,... % Is there camera flip? sample moving left-right, then false. Up-down then true
    'Overwrite', true,... % usually false, want to overwrite the previous data? 
    'crop', false,... % used to limit the FOV from original size to the cropped size
    'LLFFCorrection', false); % lattice light flat field correction (aka illumination correction)

% z0 = abs(XYZ488.z - XYZ560.z)*data.ds*sind(31.5);
%  nF = round(zO/0.104/data.zAniso); % # of frames to add
%     fprintf('%d frames to add\n', nF);

%%
clear;clc
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
Data = struct();
while true
   Data(idx).data =  GU_loadConditionData3D; idx = idx+1; disp(idx);
end
    
% Data(idx).data = GU_loadConditionData3D; idx = idx+1; disp(idx);
% Data(idx).data = GU_loadConditionData3D; idx = idx+1; disp(idx);
% Data(idx).data = GU_loadConditionData3D; idx = idx+1; disp(idx);
% % N
% Data(idx).data = GU_loadConditionData3D; idx = idx+1; disp(idx);
   %%
   foldir = '/net/tkfastfs/scratch/Gustavo/20201203_p5_p55_sCMOS_Gu';
Ex_directories = findExDFS(foldir);
addChannels(Ex_directories)

   for ii = 1:length(Ex_directories)
       
       Data.data(ii) = AutoGU_loadConditionData3D(Ex_directories{ii});
   end
% data = AutoGU_loadConditionData3D(Ex_directories{1});



%%
% clc
% if start
%     t =tic;
%     delete(gcp('nocreate'));
%     p = parcluster;
% %     parpool((p.NumWorkers))
%     parpool((48*4))
%     fprintf('Time to intialize %d workers: %dmin %1.2fsec',p.NumWorkers, floor(toc(t)/60), rem(toc(t),60));
%     start = 0;
% end
%%
clc
illumRt = '/scratch/Ricardo/02042021/Fish1_with_488_560_642/LLSCalibration/illum/';
illum488CamA = '488nm_Dither_2048__CamA_ch0_CAM1_stack0000_488nm_0000000msec_0000470502msecAbs_000x_000y_000z_0000t.tif';
illum560CamA = '560nm_Dither_2048__CamB_ch0_CAM1_stack0000_560nm_0000000msec_0000335633msecAbs_000x_000y_000z_0000t.tif';
% illum642CamA = 'i_CamA_ch1_stack0000_642nm_0000000msec_1138399748msecAbs.tif';

% rt_488 = '/net/tkfastfs/scratch/Gustavo/20201117_p5_p55_sCMOS_Gu/LLSCalibrations/chroma/original/Ex00_488_560_z0p2/ch488nmCamA/DS/';
% rt_560 = '/net/tkfastfs/scratch/Gustavo/20201117_p5_p55_sCMOS_Gu/LLSCalibrations/chroma/original/Ex00_488_560_z0p2/ch560nmCamA/DS/';
% 
% FileName488camA = 'c_CamA_ch0_stack0000_488nm_0000000msec_0319766055msecAbs.tif';
% FileName560camB = 'c_CamA_ch1_stack0000_560nm_0000000msec_0319766055msecAbs.tif';
% % FileName642camA = 'c642.tif';

dark488 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';
dark560 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';
dark642 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';

doIllum = true;

% 3 color
% illumRt = '/net/tkfastfs/scratch/Gustavo/20201110_p5_p55_sCMOS_Gu/LLSCalibrations/illum/';
% illum488CamA = 'i_CamA_ch0_stack0000_488nm_0000000msec_0072495696msecAbs.tif';
% illum560CamB = 'i_CamB_ch1_stack0001_560nm_0037500msec_0072533196msecAbs.tif';
% illum642CamA ='i_CamA_ch2_stack0000_642nm_0000000msec_0072495696msecAbs.tif';
% 
rt_488 = '/scratch/Ricardo/02042021/Fish1_with_488_560_642/LLSCalibration/chroma/Ex02_chroma_488_560_z0p4/ch488nmCamA/DS/';
rt_560 = '/scratch/Ricardo/02042021/Fish1_with_488_560_642/LLSCalibration/chroma/Ex02_chroma_488_560_z0p4/ch560nmCamB/DS/';
rt_642 = '/net/tkfastfs/scratch/Gustavo/20201125_p5_p55_sCMOS_Anwesha/LLSCalibrations/chroma/original_x00_488_560_z0p2/ch642nmCamA/DS/';
FileName488camA = 'chroma_488_560_Z0p4__CamA_ch1_CAM1_stack0001_488nm_0005831msec_0011205067msecAbs_000x_000y_000z_0000t.tif';
FileName560camB = 'chroma_488_560_Z0p4__CamB_ch0_CAM1_stack0000_560nm_0000000msec_0011199236msecAbs_000x_000y_000z_0000t.tif';
FileName642camA = 'ex00_CamA_ch2_stack0000_642nm_0000000msec_0000581658msecAbs.tif';

[~, ~, XYZ488, ~, ~] = GU_estimateSigma3D(rt_488,FileName488camA); % Get XYZ by adding a PSF
[~, ~, XYZ560, ~, ~] = GU_estimateSigma3D(rt_560,FileName560camB); % Get XYZ by adding a PSF
% [~, ~, XYZ642, ~, ~] = GU_estimateSigma3D(rt_642,FileName642camA); % Get XYZ by adding a PSF
const = 0.4*sind(31.5);

disp(1)


for ii = 1:length(Data)
    data = Data(ii).data;

    
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
    'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
    'LowerLimit', 0.5,...
    'LSImageCh1', [illumRt,filesep illum488CamA],...
    'BackgroundCh1', '/net/tkfastfs/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
elseif length(data(1).channels) < 2 && ~isempty(counter560chan)
     disp('560')
    deskewData(data,...
    'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
    'Overwrite', true,... % usually false, want to overwrite the previous data? 
    'crop', false,... % used to limit the FOV from original size to the cropped size
    'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
    'LowerLimit', 0.5,...
    'LSImageCh1', [illumRt,filesep illum560CamA],...
    'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif')
elseif length(data(1).channels) < 2 && ~isempty(counter642chan)
     disp('642')
    deskewData(data,...
    'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
    'Overwrite', true,... % usually false, want to overwrite the previous data? 
    'crop', false,... % used to limit the FOV from original size to the cropped size
    'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
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
        'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
        'LowerLimit', 0.5,...
        'LSImageCh1', [illumRt,filesep illum488CamA],...
        'LSImageCh2', [illumRt,filesep illum560CamA],...
        'BackgroundCh1', dark488,...
        'BackgroundCh2', dark560)
    
    
%     
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
    'LSImageCh1', [illumRt,filesep illum560CamA],...
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
    'LSImageCh2', [illumRt,filesep illum560CamA],...
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
%     for d:data

% for jj = 1:length(data)
%     dd = data(jj);
%     const = 0.2*sind(31.5);
    
    GU_zOffset3D(dd,...
        'zOffset', abs(XYZ488.z - XYZ560.z)*const,... 
        'RawData', false,...
        'DS', true,...
        'Ch1', false,... % 488 % adds to the end of the stack (false)
        'Ch2', true,... % 560 % adds to the start of the stack (true)
        'Ch3', true); % 642 % adds to the start of the stack (true)

    GU_zOffset3D(dd,...
        'zOffset', abs(XYZ560.z - XYZ642.z)*const,... 
        'RawData', false,...
        'DS', true,...
        'Ch1', false,... % 488 % adds to the start of the stack (true)
        'Ch2', false,... % 560 % adds to the end of the stack (bottom)
        'Ch3', true); % 642 % adds to the start of the stack (true)

      
% end
end
% GU_calcImageProjections(data)
end
% tt(ii) =toc(t)
% 
% 
% mean(tt)
% std(tt)

%% Tracking


%% Decon 

dataa = Data(1).data;
data = [dataa(1) ];
PSFRt_488 = '/net/tkfastfs/scratch/Alex/20201113_p5_p55_sCMOS_Alex/LLSCalibrations/chroma/Ex00b_488_560_642_z0p2/cropped_DS/';
PSFRt_560 = '/net/tkfastfs/scratch/Alex/20201113_p5_p55_sCMOS_Alex/LLSCalibrations/chroma/Ex00b_488_560_642_z0p2/cropped_DS/';

FileName488= 'c488.tif';
FileName560 = 'c560.tif';



deconDir = '/net/10.117.38.184/scratch/Gokul/GU_Repository/cudaDecon/cudaDeconv';
OTFDir = '/net/10.117.38.184/scratch/Gokul/GU_Repository/cudaDecon/radialft';
% GU_cudaDecon(data,...
%     'PSFfileCh1', [PSFRt_488 filesep FileName488],...
%     'PSFfileCh2', [PSFRt_560 filesep FileName560],...
%     'PSFfileCh3', [PSFRt_642 filesep FileName642],...
%     'cudaDeconPath', deconDir,...
%     'OTFGENPath', OTFDir,...
%     'Verbose', true ,...
%     'DS', true,...
%     'DSR', false,...
%     'Ch_search', {'_488nm_','_560nm_','_642nm_'},...
%     'Background', [100, 100, 100]);

% /net/10.117.38.184/scratch/Gustavo/20201110_p5_p55_sCMOS_Gu/2color/NUP205_live/mito/m1/488-560/Ex19_3_FullScan_488_150mw_560_150mW_642_50mW_z0p2

GU_Decon(data,...
    'PSFfileCh1', [PSFRt_488 filesep FileName488], ... 
    'PSFfileCh2', [PSFRt_560 filesep FileName560], ... 
    'Background', (100),...
    'dzPSF', 0.2*sind(31.5),...
    'DS', true );

%% 3 color filter
% Use the next day PSF -- experiment already started when TK told us to
% change the plane inerval
clc
% 
% data = Data.data;
% 
% PSFRt_488 = '/net/10.117.38.184/scratch/Alex/20201111_p5_p55_sCMOS_Alex/3colorDichroics/LLSCalibrations/chroma/DOPiezoOff/Ex00_488_560_642_z0p2/ch488/DS/';
% PSFRt_560 = '/net/10.117.38.184/scratch/Alex/20201111_p5_p55_sCMOS_Alex/3colorDichroics/LLSCalibrations/chroma/DOPiezoOff/Ex00_488_560_642_z0p2/ch560/DS/';
% PSFRt_642 = '/net/10.117.38.184/scratch/Alex/20201111_p5_p55_sCMOS_Alex/3colorDichroics/LLSCalibrations/chroma/DOPiezoOff/Ex00_488_560_642_z0p2/ch642/DS/';
% 
% FileName488 = 'c_CamA_ch0_stack0000_488nm_0000000msec_0064360369msecAbs.tif';
% FileName560 = 'c_CamB_ch1_stack0000_560nm_0000000msec_0064564574msecAbs.tif';
% FileName642 = 'c_CamA_ch2_stack0000_642nm_0000000msec_0064564574msecAbs.tif';
% 
% deconDir = '/net/10.117.38.184/scratch/Gokul/GU_Repository/cudaDecon/cudaDeconv';
% OTFDir = '/net/10.117.38.184/scratch/Gokul/GU_Repository/cudaDecon/radialft';
% GU_cudaDecon(data,...
%     'PSFfileCh1', [PSFRt_488 filesep FileName488],...
%     'PSFfileCh2', [PSFRt_560 filesep FileName560],...
%     'PSFfileCh3', [PSFRt_642 filesep FileName642],...
%     'cudaDeconPath', deconDir,...
%     'OTFGENPath', OTFDir,...
%     'Verbose', true ,...
%     'DS', true,...
%     'DSR', false,...
%     'Ch_search', {'_488nm_','_560nm_','_642nm_'},...
%     'Background', [100, 100, 100]);


