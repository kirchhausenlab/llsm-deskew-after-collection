open%% LLSM Preprocessing file

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
%% add repository

clear; clc; close all;

folder = '/net/10.117.38.184/scratch/Gokul/GU_PrivateRepository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/Gokul/GU_Repository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/George/MATLAB_Files';
addpath(genpath(folder));

disp(1)

%% intialize variables -- RUN AFTER CALIBRATION COMPLETE

%{
Flowchart + assumptions
1. We need to input soruce and sink folder
2. We need to input datasync3 folders for archiving
3. We assume that in the source directory, we have a file called
"LLSCalibrations".
    This includes
        1. Chroma
        2. Illum
        3. bk or background or dark
        4. PSF
        5. XZPSF



%}
clear; clc; close all;

dirSource = '/llsm/tklab-llsm/20210219_p5_p55_sCMOS_Alex';
scratch_dirSink = '/scratch/George';
datasync_dirSink = '/tkstorage/data1expansion/datasync3';

% transfer dirSource to dirSink
disp("Transferring LLSCalib folder to scratch");
dirSink = transferCalibrationFiles(dirSource, scratch_dirSink,true);

disp("Transferring LLSCalib folder to Datasync3");
dirSink_ds3 = transferCalibrationFiles(dirSource, datasync_dirSink,true);

% raw and processed folders in datasink3
dirSink_ds3_raw = [dirSink_ds3 filesep 'raw'];
dirSink_ds3_processed = [dirSink_ds3 filesep 'processed'];

% copy calibration folders to raw and processed only and make processed directory
transferRawProcessedDS3(dirSink_ds3, dirSink_ds3_raw, dirSink_ds3_processed)

disp('Calibration file transfer complete');
%%
I = getIllum(dirSink);
I.chan
%
clc
% get background 
B = getBk(dirSink, I.doIllum);
%
clc
% get chromatic offset
C = getChroma(dirSink, true);


%%  Select which Ex to transfer, DS, CO --- CHOOSE keyword after all are transferred

% load('/net/10.117.38.184/scratch/Alex/20210219_p5_p55_sCMOS_Alex/data.mat');
keywords = {'Ex11'};
TT = tic;
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
%     checkIter(Ex)
    checkIter(sinkEx)

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
end

disp('All compeleted');
disp(1);

toc(TT)
%% If data is not in llsm D drive. Just preprocess, no copy


dirSink = '/scratch/Alex/20210108_p5_p55_sCMOS_Alex/ToTrack_Giusseppe';
dirSource = dirSink;
I = getIllum(dirSink);
I.chan
%
clc
% get background 
B = getBk(dirSink, I.doIllum);
%
clc
% get chromatic offset
C = getChroma(dirSink, false, true);
%%

keywords = {'Ex08_','Ex09_','Ex10_','Ex11_','Ex12_','Ex13_','Ex14_','Ex16_','Ex17_','Ex18_','Ex19_','Ex20_',...
    'Ex21_','Ex22_','Ex23_','Ex24_','Ex25_','Ex26_','Ex27_','Ex28_','Ex29_','Ex30_','Ex31_',};

% keywords = {'Ex01p'};

tic
for qq = 1:length(keywords)
keyword = char(keywords{qq});
% keyword = 'Ex08_';
Exs =  findKeywordDFS(dirSource, keyword);

for ii=1:length(Exs)
    % Ex acquisiton folder
    Ex = Exs{ii}; 
    sinkEx= char(Ex);
    
% %     transfer from local to scratch
%     sinkEx = transferLocalToSink(dirSink, Ex);
%     
% %     transfer from local to datasync3/raw
%     transferLocalToSink(dirSink_ds3_raw, Ex);
    
%     % change name for scripting mode
%     checkIter(Ex)
% 
%     % organize scartch folders into channels
%     addChannels(char(Ex))

    % load the data
    data = AutoGU_loadConditionData3D(sinkEx);

    % preprocess, deskew, illum correction, chromatic offset
    preprocess(data, sinkEx, I, B, C)
    
    % save the preprocessed data into datasync3, change function name -
    % confusing
%     transferLocalFolderToSink(dirSink_ds3_processed, sinkEx)   
end
end
toc
disp('All compeleted');
disp(1);


disp('All compeleted');
disp(1);


%% 
% % % % 
% % % % %transfer from  local to scratch AFTER ACQUISITION IS COMPLETE
% % % % transferAcquisition(dirSource, dirSink,keyword)
% % % % 
% % % % %copy raw files itno DS3
% % % % copyRawToDatasync3(dirSource, dirSink_ds3_raw,keyword)
% % % % 
% % % % for kk = 1:length(Exs)
% % % %     Ex = Exs{kk};
% % % %     addChannels(Ex)
% % % %     
% % % %     Data.data = AutoGU_loadConditionData3D(Ex);
% % % %     
% % % %     illumRt = I.dir;
% % % %     illum488CamA = I.chan{1,3};
% % % %     illum560CamA = I.chan{1,5};
% % % %     illum642CamA = I.chan{1,8};
% % % %     
% % % %     dark488 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';
% % % %     dark560 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';
% % % %     dark642 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';
% % % %     
% % % %     doIllum = I.doIllum;
% % % %     
% % % %     rt_488 ='';
% % % %     rt_560 = '';
% % % %     rt_642 = '';
% % % %     FileName488camA =  char(C.chan{1,3});
% % % %     FileName560camA =  char(C.chan{1,5});
% % % %     FileName642camA =  char(C.chan{1,8});
% % % %     
% % % %     Cam = {'CamA','CamB'};
% % % %     Chan = {'405','445','488','514','560','592','607','642'};
% % % %     
% % % %     if ~isempty(C.chan{1,3} ) ||  ~isempty(C.chan{2,3} )
% % % %         [~, ~, XYZ488, ~, ~] = GU_estimateSigma3D(rt_488,FileName488camA); % Get XYZ by adding a PSF
% % % %     end
% % % %     if ~isempty(C.chan{1,5}) ||  ~isempty(C.chan{2,5} )
% % % %         [~, ~, XYZ560, ~, ~] = GU_estimateSigma3D(rt_560,FileName560camA); % Get XYZ by adding a PSF
% % % %     end
% % % %     if ~isempty(C.chan{1,8})  ||  ~isempty(C.chan{2,8} )
% % % %         [~, ~, XYZ642, ~, ~] = GU_estimateSigma3D(rt_642,FileName642camA); % Get XYZ by adding a PSF
% % % %     end
% % % %     
% % % %     %
% % % %     %
% % % %     
% % % %     const = C.ds*sind(31.5);
% % % %     
% % % %     
% % % %     %
% % % %     
% % % %     for ii =1:length(Data)
% % % %         data = Data(ii).data;
% % % %         %     if ii > 1
% % % %         %         for idx = 1:length(
% % % %         
% % % %         counter488chan = regexp(data(1).source, '488');
% % % %         counter560chan = regexp(data(1).source, '560');
% % % %         counter642chan = regexp(data(1).source, '642');
% % % %         % delete(gcp('nocreate'))
% % % %         % parpool(maxNumCompThreads)
% % % %         
% % % %         
% % % %         camflip = false;
% % % %         
% % % %         
% % % %         t = tic;
% % % %         %%%%%%%%%%%%%%%%%%%%%% ONE CHANNEL %%%%%%%%%%%%%%%%%%%%%%
% % % %         if length(data(1).channels) < 2 && ~isempty(counter488chan)
% % % %             disp('488')
% % % %             deskewData(data,...
% % % %                 'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% % % %                 'Overwrite', true,... % usually false, want to overwrite the previous data?
% % % %                 'crop', false,... % used to limit the FOV from original size to the cropped size
% % % %                 'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
% % % %                 'LowerLimit', 0.5,...
% % % %                 'LSImageCh1', [illumRt,filesep illum488CamA],...
% % % %                 'BackgroundCh1', '/net/tkfastfs/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% % % %         elseif length(data(1).channels) < 2 && ~isempty(counter560chan)
% % % %             disp('560')
% % % %             deskewData(data,...
% % % %                 'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% % % %                 'Overwrite', true,... % usually false, want to overwrite the previous data?
% % % %                 'crop', false,... % used to limit the FOV from original size to the cropped size
% % % %                 'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
% % % %                 'LowerLimit', 0.5,...
% % % %                 'LSImageCh1', [illumRt,filesep illum560CamA],...
% % % %                 'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif')
% % % %         elseif length(data(1).channels) < 2 && ~isempty(counter642chan)
% % % %             disp('642')
% % % %             deskewData(data,...
% % % %                 'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% % % %                 'Overwrite', true,... % usually false, want to overwrite the previous data?
% % % %                 'crop', false,... % used to limit the FOV from original size to the cropped size
% % % %                 'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
% % % %                 'LowerLimit', 0.5,...
% % % %                 'LSImageCh1', [illumRt,filesep illum642CamA],...
% % % %                 'BackgroundCh1', '/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% % % %             
% % % %             
% % % %             %%%%%%%%%%%%%%%%%%%%%% TWO CHANNELS %%%%%%%%%%%%%%%%%%%%%%
% % % %             
% % % %         elseif length(data(1).channels)==2 && ~isempty(counter560chan) && ~isempty(counter488chan)
% % % %             disp('488-560');
% % % %             
% % % %             deskewData(data,...
% % % %                 'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% % % %                 'Overwrite', true,... % usually false, want to overwrite the previous data?
% % % %                 'crop', false,... % used to limit the FOV from original size to the cropped size
% % % %                 'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
% % % %                 'LowerLimit', 0.5,...
% % % %                 'LSImageCh1', [illumRt,filesep illum488CamA],...
% % % %                 'LSImageCh2', [illumRt,filesep illum560CamA],...
% % % %                 'BackgroundCh1', dark488,...
% % % %                 'BackgroundCh2', dark560)
% % % %             
% % % %             
% % % %             %
% % % %             data_multipleChan = data;
% % % %             if length(data_multipleChan(1).channels)== 2
% % % %                 disp('2 channels')
% % % %                 if (XYZ488.z < XYZ560.z)
% % % %                     ch1_488_logical = true;
% % % %                     ch2_560_logical = false;
% % % %                 else
% % % %                     ch1_488_logical = false;
% % % %                     ch2_560_logical = true;
% % % %                 end
% % % %                 GU_zOffset3D(data_multipleChan,...
% % % %                     'zOffset', abs(XYZ488.z - XYZ560.z)*const,...
% % % %                     'RawData', false,...
% % % %                     'DS', true,...
% % % %                     'Ch1', ch1_488_logical,...
% % % %                     'Ch2', ch2_560_logical);
% % % %             end
% % % %             
% % % %             
% % % %         elseif length(data(1).channels)==2 && ~isempty(counter642chan) && ~isempty(counter560chan)
% % % %             disp('560-642');
% % % %             
% % % %             deskewData(data,...
% % % %                 'sCMOSCameraFlip', false,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% % % %                 'Overwrite', true,... % usually false, want to overwrite the previous data?
% % % %                 'crop', false,... % used to limit the FOV from original size to the cropped size
% % % %                 'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
% % % %                 'LowerLimit', 0.5,...
% % % %                 'LSImageCh1', [illumRt,filesep illum560CamA],...
% % % %                 'LSImageCh2', [illumRt,filesep illum642CamA],...
% % % %                 'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif',...
% % % %                 'BackgroundCh2', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% % % %             
% % % %             %chroma offset
% % % %             
% % % %             
% % % %             
% % % %             data_multipleChan =data;
% % % %             if length(data_multipleChan(1).channels)== 2
% % % %                 disp('2 channels')
% % % %                 if (XYZ488.z < XYZ642.z)
% % % %                     ch1_488_logical = true;
% % % %                     ch2_642_logical = false;
% % % %                 else
% % % %                     ch1_488_logical = false;
% % % %                     ch2_642_logical = true;
% % % %                 end
% % % %                 GU_zOffset3D(data_multipleChan,...
% % % %                     'zOffset', abs(XYZ560.z - XYZ642.z)*const,...
% % % %                     'RawData', false,...
% % % %                     'DS', true,...
% % % %                     'Ch1', ch1_488_logical,...
% % % %                     'Ch2', ch2_642_logical);
% % % %             end
% % % %             
% % % %         elseif length(data(1).channels)==2 && ~isempty(counter642chan) && ~isempty(counter488chan)
% % % %             disp('488-642');
% % % %             
% % % %             deskewData(data,...
% % % %                 'sCMOSCameraFlip', false,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% % % %                 'Overwrite', true,... % usually false, want to overwrite the previous data?
% % % %                 'crop', false,... % used to limit the FOV from original size to the cropped size
% % % %                 'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
% % % %                 'LowerLimit', 0.5,...
% % % %                 'LSImageCh1', [illumRt,filesep illum488CamA],...
% % % %                 'LSImageCh2', [illumRt,filesep illum642CamA],...
% % % %                 'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif',...
% % % %                 'BackgroundCh2', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% % % %             
% % % %             
% % % %             
% % % %             
% % % %             data_multipleChan =data;
% % % %             if length(data_multipleChan(1).channels)== 2
% % % %                 disp('2 channels')
% % % %                 if (XYZ488.z < XYZ642.z)
% % % %                     ch1_488_logical = true;
% % % %                     ch2_642_logical = false;
% % % %                 else
% % % %                     ch1_488_logical = false;
% % % %                     ch2_642_logical = true;
% % % %                 end
% % % %                 GU_zOffset3D(data_multipleChan,...
% % % %                     'zOffset', abs(XYZ488.z - XYZ642.z)*const,...
% % % %                     'RawData', false,...
% % % %                     'DS', true,...
% % % %                     'Ch1', ch1_488_logical,...
% % % %                     'Ch2', ch2_642_logical);
% % % %             end
% % % %             
% % % %             
% % % %         else
% % % %             disp('488-560-642')
% % % %             %     datatemp = [data,data2,data3];
% % % %             % data = datatemp
% % % %             
% % % %             deskewData(data,...
% % % %                 'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% % % %                 'Overwrite', true,... % usually false, want to overwrite the previous data?
% % % %                 'crop', false,... % used to limit the FOV from original size to the cropped size
% % % %                 'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
% % % %                 'LowerLimit', 0.5,...
% % % %                 'LSImageCh1', [illumRt,filesep illum488CamA],...
% % % %                 'LSImageCh2', [illumRt,filesep illum560CamA],...
% % % %                 'LSImageCh3', [illumRt,filesep illum642CamA],...
% % % %                 'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif',...
% % % %                 'BackgroundCh2', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif',...
% % % %                 'BackgroundCh3', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% % % %             
% % % %             
% % % %             
% % % %           
% % % %             
% % % %             GU_zOffset3D(data,...
% % % %                 'zOffset', abs(XYZ488.z - XYZ560.z)*const,...
% % % %                 'RawData', false,...
% % % %                 'DS', true,...
% % % %                 'Ch1', false,... % 488 % adds to the end of the stack (false)
% % % %                 'Ch2', true,... % 560 % adds to the start of the stack (true)
% % % %                 'Ch3', true); % 642 % adds to the start of the stack (true)
% % % %             
% % % %             GU_zOffset3D(data,...
% % % %                 'zOffset', abs(XYZ560.z - XYZ642.z)*const,...
% % % %                 'RawData', false,...
% % % %                 'DS', true,...
% % % %                 'Ch1', false,... % 488 % adds to the start of the stack (true)
% % % %                 'Ch2', false,... % 560 % adds to the end of the stack (bottom)
% % % %                 'Ch3', true); % 642 % adds to the start of the stack (true)
% % % %             
% % % %             
% % % %             % end
% % % %         end
% % % %         % GU_calcImageProjections(data)
% % % %     end
% % % %     
% % % %     copyToDatasync3(Ex, dirSink_ds3_preprocessed)
% % % %     
% % % % end
% % % % % tt(ii) =toc(t)
% % % % %
% % % % %
% % % % % mean(tt)
% % % % 
% % % % 
% % % % % copy the preprocessed data into ds3
% % % % 
% % % % 









%%
