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

%%
% LLSM directory  = /llsm/tklab-llsm
%
%
% AO dir = /llsm/AO-LLSM


% 
%% Organize acquisitions by channels (laser and Camera)
%%

clear; clc; close all;

folder = '/net/10.117.38.184/scratch/Gokul/GU_PrivateRepository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/Gokul/GU_Repository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/George/MATLAB_Files';
addpath(genpath(folder));


%% intialize variables -- RUN AFTER CALIBRATION COMPLETE
clear; clc; close all;

dirSource = '/llsm/tklab-llsm/20210104_p5_p55_sCMOS_Gu';
dirSource = '/llsm/AO-LLSM/Ricardo/12_December/14122020';
dirSink = '/net/tkfastfs/scratch/George/deskewTest';

% transfer dirSource to dirSink
dirSink = transferCalibrationFiles(dirSource, dirSink);

I = getIllum(dirSink);
I.chan
%
clc
% get background 0
B = getBk(dirSink, I.doIllum);
%
clc
% get chromatic offset
C = getChroma(dirSink);

%%  Select which Ex to transfer, DS, CO --- CHOOSE keyword after all are transferred


keyword = 'Ex03_';
Ex =  findKeywordDFS(dirSink, keyword);
addChannels(Ex)


%transfer AFTER ACQUISITION IS COMPLETE
transferAcquisition(dirSource, dirSink,keyword)
Data.data = AutoGU_loadConditionData3D(Ex);

%

illumRt = I.dir;
illum488CamA = I.chan{1,3};
illum560CamA = I.chan{1,5};
illum642CamA = I.chan{1,8};

dark488 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';
dark560 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';
dark642 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';

doIllum = I.doIllum;

rt_488 ='';
rt_560 = '';
rt_642 = '';
FileName488camA =  char(C.chan{1,3});
FileName560camA =  char(C.chan{1,5});
FileName642camA =  char(C.chan{1,8});

Cam = {'CamA','CamB'};
Chan = {'405','445','488','514','560','592','607','642'};

if ~isempty(C.chan{1,3} ) ||  ~isempty(C.chan{2,3} )
    [~, ~, XYZ488, ~, ~] = GU_estimateSigma3D(rt_488,FileName488camA); % Get XYZ by adding a PSF
end
if ~isempty(C.chan{1,5}) ||  ~isempty(C.chan{2,5} )
    [~, ~, XYZ560, ~, ~] = GU_estimateSigma3D(rt_560,FileName560camA); % Get XYZ by adding a PSF
end
if ~isempty(C.chan{1,8})  ||  ~isempty(C.chan{2,8} )
    [~, ~, XYZ642, ~, ~] = GU_estimateSigma3D(rt_642,FileName642camA); % Get XYZ by adding a PSF
end

%     
%     

const = C.ds*sind(31.5);


%

for ii =1
%    ii = 1:length(Data)
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
    'sCMOSCameraFlip', false,... % Is there camera flip? sample moving left-right, then false. Up-down then true
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
    'sCMOSCameraFlip', false,... % Is there camera flip? sample moving left-right, then false. Up-down then true
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

      
% end
end
% GU_calcImageProjections(data)
end
% tt(ii) =toc(t)
% 
% 
% mean(tt)













%%

%%

%%
% %% Get Ex folders directory
% clear;clc
% foldir = '/net/tkfastfs/scratch/Gustavo/20201211_p5_p55_sCMOS_Gu';
% 
% % find all the Ex dirctories
% Ex_directories_temp = findExDFS(foldir);
% 
% % get rid of the Ex extention if 1. no tif inside 2. not 3D image
% 
% % check if 3D image by looking at Meta file
% check3Dacquisition(Ex_directories_temp)
% Ex_directories_temp = findExDFS(foldir);
% % Add s-plane info if you missed
% add_splane_FolName2(Ex_directories_temp)
% 
% % Get the updated folderNames
% clearvars -except foldir
% Ex_directories = findExDFS(foldir);
% 
% % Organize into ch
% % 
% % data= GU_loadConditionData3D;
% % GU_sort3Dfiles_George_inputOrganize_v3(data)
% 
% addChannels(Ex_directories)
% 
% 
% %% change iteration mode acquisitons name from Iter_1_ to Iter_0001_
% 
% 
% chdir= getChdir(Ex_directories);
% % change the tifname if iter1 to iter001
% changeIter(chdir)
% 
% %% Organize acquisitons into channels after CS folder
% 
% %% Prototype, loadCondition3D()
% % data = KGO_GU_loadConditionData3D(Ex_directories);
% 
% %% Deskew Chroma
% data = GU_loadConditionData3D;
%  deskewData(data,...
%     'sCMOSCameraFlip', false,... % Is there camera flip? sample moving left-right, then false. Up-down then true
%     'Overwrite', true,... % usually false, want to overwrite the previous data? 
%     'crop', false,... % used to limit the FOV from original size to the cropped size
%     'LLFFCorrection', false); % lattice light flat field correction (aka illumination correction)
% 
% % z0 = abs(XYZ488.z - XYZ560.z)*data.ds*sind(31.5);
% %  nF = round(zO/0.104/data.zAniso); % # of frames to add
% %     fprintf('%d frames to add\n', nF);
% 
% %%
% clear;clc
% % start=0;
% % Data(1).data = GU_loadConditionData3D;
% % dataCS1_4= GU_loadConditionData3D;
% % dataCS1_456 = GU_loadConditionData3D;
% % dataCS2 = GU_loadConditionData3D;
% % dataCS3 = GU_loadConditionData3D;
% % data5= GU_loadConditionData3D;
% % data=[data1 data2 data3 data4];
% % data= GU_loadConditionData3D;
% 
% idx = 1;
% Data = struct();
% while true
%    Data(idx).data =  GU_loadConditionData3D; idx = idx+1; disp(idx);
% end
%     
% % Data(idx).data = GU_loadConditionData3D; idx = idx+1; disp(idx);
% % Data(idx).data = GU_loadConditionData3D; idx = idx+1; disp(idx);
% % Data(idx).data = GU_loadConditionData3D; idx = idx+1; disp(idx);
% % % N
% % Data(idx).data = GU_loadConditionData3D; idx = idx+1; disp(idx);
%    
% 
% 
% %%
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
% %%
% 
% illumRt = '//net/tkfastfs/scratch/Gustavo/20201211_p5_p55_sCMOS_Gu/LLSCalibration/ilum/Dither';
% illum488CamA = 'i_CamA_ch0_stack0000_488nm_0000000msec_1378839717msecAbs.tif';
% illum560CamA = 'i_CamA_ch1_stack0000_560nm_0000000msec_1378839717msecAbs.tif';
% illum642CamA = 'i_CamA_ch1_stack0000_560nm_0000000msec_1378839717msecAbs.tif';
% 
% % rt_488 = '/net/tkfastfs/scratch/Gustavo/20201117_p5_p55_sCMOS_Gu/LLSCalibrations/chroma/original/Ex00_488_560_z0p2/ch488nmCamA/DS/';
% % rt_560 = '/net/tkfastfs/scratch/Gustavo/20201117_p5_p55_sCMOS_Gu/LLSCalibrations/chroma/original/Ex00_488_560_z0p2/ch560nmCamA/DS/';
% % 
% % FileName488camA = 'c_CamA_ch0_stack0000_488nm_0000000msec_0319766055msecAbs.tif';
% % FileName560camB = 'c_CamA_ch1_stack0000_560nm_0000000msec_0319766055msecAbs.tif';
% % % FileName642camA = 'c642.tif';
% 
% dark488 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';
% dark560 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';
% dark642 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';
% 
% doIllum = true;
% 
% % 3 color
% % illumRt = '/net/tkfastfs/scratch/Gustavo/20201110_p5_p55_sCMOS_Gu/LLSCalibrations/illum/';
% % illum488CamA = 'i_CamA_ch0_stack0000_488nm_0000000msec_0072495696msecAbs.tif';
% % illum560CamB = 'i_CamB_ch1_stack0001_560nm_0037500msec_0072533196msecAbs.tif';
% % illum642CamA ='i_CamA_ch2_stack0000_642nm_0000000msec_0072495696msecAbs.tif';
% % 
% 
% %PSF
% rt_488 = '/net/tkfastfs/scratch/Gustavo/20201211_p5_p55_sCMOS_Gu/LLSCalibration/';
% rt_560 = '/net/tkfastfs/scratch/Gustavo/20201211_p5_p55_sCMOS_Gu/LLSCalibration/';
% rt_642 = '/net/tkfastfs/scratch/Gustavo/20201211_p5_p55_sCMOS_Gu/LLSCalibration/';
% FileName488camA = '488totalPSF.tif';
% FileName560camA = '560totalPSF.tif';
% FileName642camA = '642totalPSF.tif';
% 
% [~, ~, XYZ488, ~, ~] = GU_estimateSigma3D(rt_488,FileName488camA); % Get XYZ by adding a PSF
% [~, ~, XYZ560, ~, ~] = GU_estimateSigma3D(rt_560,FileName560camA); % Get XYZ by adding a PSF
% [~, ~, XYZ642, ~, ~] = GU_estimateSigma3D(rt_642,FileName642camA); % Get XYZ by adding a PSF
% const = 0.2*sind(31.5);
% 
% disp(1)
% 
% %%
% Data(1).data = data
% data = GU_loadConditionData3D;
% 
% for ii =1
% %    ii = 1:length(Data)
%    data = Data(ii).data;
% %     if ii > 1
% %         for idx = 1:length(
%     
% counter488chan = regexp(data(1).source, '488');
% counter560chan = regexp(data(1).source, '560');
% counter642chan = regexp(data(1).source, '642'); 
% % delete(gcp('nocreate'))
% % parpool(maxNumCompThreads)
% 
% 
% camflip = false;
% 
% 
% t = tic;
% %%%%%%%%%%%%%%%%%%%%%% ONE CHANNEL %%%%%%%%%%%%%%%%%%%%%%
% if length(data(1).channels) < 2 && ~isempty(counter488chan)
%     disp('488')
%     deskewData(data,...
%     'sCMOSCameraFlip', campflie,... % Is there camera flip? sample moving left-right, then false. Up-down then true
%     'Overwrite', true,... % usually false, want to overwrite the previous data? 
%     'crop', false,... % used to limit the FOV from original size to the cropped size
%     'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
%     'LowerLimit', 0.5,...
%     'LSImageCh1', [illumRt,filesep illum488CamA],...
%     'BackgroundCh1', '/net/tkfastfs/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% elseif length(data(1).channels) < 2 && ~isempty(counter560chan)
%      disp('560')
%     deskewData(data,...
%     'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
%     'Overwrite', true,... % usually false, want to overwrite the previous data? 
%     'crop', false,... % used to limit the FOV from original size to the cropped size
%     'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
%     'LowerLimit', 0.5,...
%     'LSImageCh1', [illumRt,filesep illum560CamA],...
%     'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif')
% elseif length(data(1).channels) < 2 && ~isempty(counter642chan)
%      disp('642')
%     deskewData(data,...
%     'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
%     'Overwrite', true,... % usually false, want to overwrite the previous data? 
%     'crop', false,... % used to limit the FOV from original size to the cropped size
%     'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
%     'LowerLimit', 0.5,...
%     'LSImageCh1', [illumRt,filesep illum642CamA],...
%     'BackgroundCh1', '/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% 
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%% TWO CHANNELS %%%%%%%%%%%%%%%%%%%%%%
% 
% elseif length(data(1).channels)==2 && ~isempty(counter560chan) && ~isempty(counter488chan)
%     disp('488-560');
%     
%     deskewData(data,...
%         'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
%         'Overwrite', true,... % usually false, want to overwrite the previous data?
%         'crop', false,... % used to limit the FOV from original size to the cropped size
%         'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
%         'LowerLimit', 0.5,...
%         'LSImageCh1', [illumRt,filesep illum488CamA],...
%         'LSImageCh2', [illumRt,filesep illum560CamA],...
%         'BackgroundCh1', dark488,...
%         'BackgroundCh2', dark560)
%     
%     
% %     
%     data_multipleChan = data;
%     if length(data_multipleChan(1).channels)== 2
%         disp('2 channels')
%         if (XYZ488.z < XYZ560.z)
%             ch1_488_logical = true;
%             ch2_560_logical = false;
%         else
%             ch1_488_logical = false;
%             ch2_560_logical = true;
%         end
%         GU_zOffset3D(data_multipleChan,...
%             'zOffset', abs(XYZ488.z - XYZ560.z)*const,...
%             'RawData', false,...
%             'DS', true,...
%             'Ch1', ch1_488_logical,...
%             'Ch2', ch2_560_logical);
%     end
% 
% 
% elseif length(data(1).channels)==2 && ~isempty(counter642chan) && ~isempty(counter560chan)
%     disp('560-642');
% 
%       deskewData(data,...
%     'sCMOSCameraFlip', false,... % Is there camera flip? sample moving left-right, then false. Up-down then true
%     'Overwrite', true,... % usually false, want to overwrite the previous data? 
%     'crop', false,... % used to limit the FOV from original size to the cropped size
%     'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
%     'LowerLimit', 0.5,...
%     'LSImageCh1', [illumRt,filesep illum560CamA],...
%     'LSImageCh2', [illumRt,filesep illum642CamA],...
%     'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif',...
%     'BackgroundCh2', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% 
%   %chroma offset
%     
%     
%     
%     data_multipleChan =data;
%     if length(data_multipleChan(1).channels)== 2
%         disp('2 channels')
%         if (XYZ488.z < XYZ642.z)
%             ch1_488_logical = true;
%             ch2_642_logical = false;
%         else
%             ch1_488_logical = false;
%             ch2_642_logical = true;
%         end
%         GU_zOffset3D(data_multipleChan,...
%             'zOffset', abs(XYZ560.z - XYZ642.z)*const,...
%             'RawData', false,...
%             'DS', true,...
%             'Ch1', ch1_488_logical,...
%             'Ch2', ch2_642_logical);
%     end
% 
% elseif length(data(1).channels)==2 && ~isempty(counter642chan) && ~isempty(counter488chan)
%     disp('488-642');
% 
%       deskewData(data,...
%     'sCMOSCameraFlip', false,... % Is there camera flip? sample moving left-right, then false. Up-down then true
%     'Overwrite', true,... % usually false, want to overwrite the previous data? 
%     'crop', false,... % used to limit the FOV from original size to the cropped size
%     'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
%     'LowerLimit', 0.5,...
%     'LSImageCh1', [illumRt,filesep illum488CamA],...
%     'LSImageCh2', [illumRt,filesep illum642CamA],...
%     'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif',...
%     'BackgroundCh2', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% 
% 
%     
%     
%     data_multipleChan =data;
%     if length(data_multipleChan(1).channels)== 2
%         disp('2 channels')
%         if (XYZ488.z < XYZ642.z)
%             ch1_488_logical = true;
%             ch2_642_logical = false;
%         else
%             ch1_488_logical = false;
%             ch2_642_logical = true;
%         end
%         GU_zOffset3D(data_multipleChan,...
%             'zOffset', abs(XYZ488.z - XYZ642.z)*const,...
%             'RawData', false,...
%             'DS', true,...
%             'Ch1', ch1_488_logical,...
%             'Ch2', ch2_642_logical);
%     end
% 
%     
% else
%     disp('488-560-642')
% %     datatemp = [data,data2,data3];
% % data = datatemp
%     
%      deskewData(data,...
%     'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
%     'Overwrite', true,... % usually false, want to overwrite the previous data? 
%     'crop', false,... % used to limit the FOV from original size to the cropped size
%     'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
%     'LowerLimit', 0.5,...
%     'LSImageCh1', [illumRt,filesep illum488CamA],...
%     'LSImageCh2', [illumRt,filesep illum560CamB],...
%     'LSImageCh3', [illumRt,filesep illum642CamA],...
%     'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif',...
%     'BackgroundCh2', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif',...
%     'BackgroundCh3', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% 
%     
%     
% %     rt_488 = '/net/tkfastfs/scratch/Gustavo/20201022_P5_P55_sCMOS_Gu/LLSCalibrations/chroma/Ex00_488_560_642_z0p5/ch488nmCamA/DS/';
% %     rt_560 = '/net/tkfastfs/scratch/Gustavo/20201022_P5_P55_sCMOS_Gu/LLSCalibrations/chroma/Ex00_488_560_642_z0p5/ch560nmCamB/DS/';
% %     rt_642 = '/net/tkfastfs/scratch/Gustavo/20201022_P5_P55_sCMOS_Gu/LLSCalibrations/chroma/Ex00_488_560_642_z0p5/ch642nmCamA/DS/';
% %     
% %     FileName488camA = 'chroma_CamA_ch0_stack0000_488nm_0000000msec_0005999292msecAbs.tif';
% %     FileName560camB = 'chroma_CamB_ch1_stack0000_560nm_0000000msec_0005999292msecAbs.tif';
% %     FileName642camA = 'chroma_CamA_ch2_stack0000_642nm_0000000msec_0005999292msecAbs.tif';
%     
%     
% %     [~, ~, XYZ488, ~, ~] = GU_estimateSigma3D(rt_488,FileName488camA); % Get XYZ by adding a PSF
% %     [~, ~, XYZ560, ~, ~] = GU_estimateSigma3D(rt_560,FileName560camB); % Get XYZ by adding a PSF
% %     [~, ~, XYZ642, ~, ~] = GU_estimateSigma3D(rt_642,FileName642camA); % Get XYZ by adding a PSF
% %     const = 0.5*sind(31.5);
%     
%     disp('3 channels') 
% %     for d:data
% 
% % for jj = 1:length(data)
% %     dd = data(jj);
% %     const = 0.2*sind(31.5);
%     
%     GU_zOffset3D(dd,...
%         'zOffset', abs(XYZ488.z - XYZ560.z)*const,... 
%         'RawData', false,...
%         'DS', true,...
%         'Ch1', false,... % 488 % adds to the end of the stack (false)
%         'Ch2', true,... % 560 % adds to the start of the stack (true)
%         'Ch3', true); % 642 % adds to the start of the stack (true)
% 
%     GU_zOffset3D(dd,...
%         'zOffset', abs(XYZ560.z - XYZ642.z)*const,... 
%         'RawData', false,...
%         'DS', true,...
%         'Ch1', false,... % 488 % adds to the start of the stack (true)
%         'Ch2', false,... % 560 % adds to the end of the stack (bottom)
%         'Ch3', true); % 642 % adds to the start of the stack (true)
% 
%       
% % end
% end
% % GU_calcImageProjections(data)
% end
% % tt(ii) =toc(t)
% % 
% % 
% % mean(tt)
% % std(tt)
% 
% %% Tracking
% 
% 
% %% Decon 
% 
% dataa = Data(1).data;
% data = [dataa(1) ];
% PSFRt_488 = '/net/tkfastfs/scratch/Alex/20201113_p5_p55_sCMOS_Alex/LLSCalibrations/chroma/Ex00b_488_560_642_z0p2/cropped_DS/';
% PSFRt_560 = '/net/tkfastfs/scratch/Alex/20201113_p5_p55_sCMOS_Alex/LLSCalibrations/chroma/Ex00b_488_560_642_z0p2/cropped_DS/';
% 
% FileName488= 'c488.tif';
% FileName560 = 'c560.tif';
% 
% 
% 
% deconDir = '/net/10.117.38.184/scratch/Gokul/GU_Repository/cudaDecon/cudaDeconv';
% OTFDir = '/net/10.117.38.184/scratch/Gokul/GU_Repository/cudaDecon/radialft';
% % GU_cudaDecon(data,...
% %     'PSFfileCh1', [PSFRt_488 filesep FileName488],...
% %     'PSFfileCh2', [PSFRt_560 filesep FileName560],...
% %     'PSFfileCh3', [PSFRt_642 filesep FileName642],...
% %     'cudaDeconPath', deconDir,...
% %     'OTFGENPath', OTFDir,...
% %     'Verbose', true ,...
% %     'DS', true,...
% %     'DSR', false,...
% %     'Ch_search', {'_488nm_','_560nm_','_642nm_'},...
% %     'Background', [100, 100, 100]);
% 
% % /net/10.117.38.184/scratch/Gustavo/20201110_p5_p55_sCMOS_Gu/2color/NUP205_live/mito/m1/488-560/Ex19_3_FullScan_488_150mw_560_150mW_642_50mW_z0p2
% 
% GU_Decon(data,...
%     'PSFfileCh1', [PSFRt_488 filesep FileName488], ... 
%     'PSFfileCh2', [PSFRt_560 filesep FileName560], ... 
%     'Background', (100),...
%     'dzPSF', 0.2*sind(31.5),...
%     'DS', true );
% 
% %% 3 color filter
% % Use the next day PSF -- experiment already started when TK told us to
% % change the plane inerval
% clc
% % 
% % data = Data.data;
% % 
% % PSFRt_488 = '/net/10.117.38.184/scratch/Alex/20201111_p5_p55_sCMOS_Alex/3colorDichroics/LLSCalibrations/chroma/DOPiezoOff/Ex00_488_560_642_z0p2/ch488/DS/';
% % PSFRt_560 = '/net/10.117.38.184/scratch/Alex/20201111_p5_p55_sCMOS_Alex/3colorDichroics/LLSCalibrations/chroma/DOPiezoOff/Ex00_488_560_642_z0p2/ch560/DS/';
% % PSFRt_642 = '/net/10.117.38.184/scratch/Alex/20201111_p5_p55_sCMOS_Alex/3colorDichroics/LLSCalibrations/chroma/DOPiezoOff/Ex00_488_560_642_z0p2/ch642/DS/';
% % 
% % FileName488 = 'c_CamA_ch0_stack0000_488nm_0000000msec_0064360369msecAbs.tif';
% % FileName560 = 'c_CamB_ch1_stack0000_560nm_0000000msec_0064564574msecAbs.tif';
% % FileName642 = 'c_CamA_ch2_stack0000_642nm_0000000msec_0064564574msecAbs.tif';
% % 
% % deconDir = '/net/10.117.38.184/scratch/Gokul/GU_Repository/cudaDecon/cudaDeconv';
% % OTFDir = '/net/10.117.38.184/scratch/Gokul/GU_Repository/cudaDecon/radialft';
% % GU_cudaDecon(data,...
% %     'PSFfileCh1', [PSFRt_488 filesep FileName488],...
% %     'PSFfileCh2', [PSFRt_560 filesep FileName560],...
% %     'PSFfileCh3', [PSFRt_642 filesep FileName642],...
% %     'cudaDeconPath', deconDir,...
% %     'OTFGENPath', OTFDir,...
% %     'Verbose', true ,...
% %     'DS', true,...
% %     'DSR', false,...
% %     'Ch_search', {'_488nm_','_560nm_','_642nm_'},...
% %     'Background', [100, 100, 100]);
% 
% 
