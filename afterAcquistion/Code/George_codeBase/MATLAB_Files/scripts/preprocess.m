function preprocess(data, sinkEx, I, B, C)

% get metadata
Meta = getMeta2_AO(sinkEx);

% deskew and apply illum correction
if strcmp(Meta.zmotion, 'Sample piezo') || strcmp(Meta.zmotion, 'X stage')
    deskewData_KGO(data,...
        'sCMOSCameraFlip', Meta.camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
        'Overwrite', true,... % usually false, want to overwrite the previous data?
        'crop', false,... % used to limit the FOV from original size to the cropped size
        'LLFFCorrection', I.doIllum,...
        'LSImageChannels',I,... % illum correction structure
        'BkImageChannels', B) % background correction structure); % lattice light flat field correction (aka illumination correction)
    
    disp(1)
    % chromatic offset
    if length(Meta.chan) > 1 && C.doChroma 
        applyChromaticOffset(data, Meta, C)
    end
    
else
    disp('Not sample scan, no transformation applied.');
end
disp('')
disp('Complete')
disp('');
end


% % function preprocess(data, sinkEx, I, B, C)
% % 
% % % get metadata
% % Meta = getMeta2(sinkEx);
% % Ex = sinkEx;
% % 
% % % deskew and apply illum correction
% % if strcmp(Meta.zmotion, 'Sample piezo')
% %    
% % %
% % Data.data = AutoGU_loadConditionData3D(Ex);
% % %
% % 
% % illumRt = I.dir;
% % illum488CamA = I.chan{1,3};
% % illum560CamA = I.chan{1,5};
% % illum642CamA = I.chan{1,8};
% % 
% % dark488 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';
% % dark560 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';
% % dark642 = '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif';
% % 
% % doIllum = I.doIllum;
% % 
% % rt_488 ='';
% % rt_560 = '';
% % rt_642 = '';
% % FileName488camA =  char(C.chan{1,3});
% % FileName560camA =  char(C.chan{1,5});
% % FileName642camA =  char(C.chan{1,8});
% % 
% % Cam = {'CamA','CamB'};
% % Chan = {'405','445','488','514','560','592','607','642'};
% % 
% % if ~isempty(C.chan{1,3} ) ||  ~isempty(C.chan{2,3} )
% %     [~, ~, XYZ488, ~, ~] = GU_estimateSigma3D(rt_488,FileName488camA); % Get XYZ by adding a PSF
% % end
% % if ~isempty(C.chan{1,5}) ||  ~isempty(C.chan{2,5} )
% %     [~, ~, XYZ560, ~, ~] = GU_estimateSigma3D(rt_560,FileName560camA); % Get XYZ by adding a PSF
% % end
% % if ~isempty(C.chan{1,8})  ||  ~isempty(C.chan{2,8} )
% %     [~, ~, XYZ642, ~, ~] = GU_estimateSigma3D(rt_642,FileName642camA); % Get XYZ by adding a PSF
% % end
% % 
% % %     
% % 
% % const = C.ds*sind(31.5);
% % 
% % 
% % %
% % 
% % for ii =1:length(Data)
% % %    ii = 1:length(Data)
% %    data = Data(ii).data;
% % %     if ii > 1
% % %         for idx = 1:length(
% %     
% % counter488chan = regexp(data(1).source, '488');
% % counter560chan = regexp(data(1).source, '560');
% % counter642chan = regexp(data(1).source, '642'); 
% % % delete(gcp('nocreate'))
% % % parpool(maxNumCompThreads)
% % 
% % 
% % camflip = false;
% % 
% % 
% % t = tic;
% % %%%%%%%%%%%%%%%%%%%%%% ONE CHANNEL %%%%%%%%%%%%%%%%%%%%%%
% % if length(data(1).channels) < 2 && ~isempty(counter488chan)
% %     disp('488')
% %     deskewData(data,...
% %     'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% %     'Overwrite', true,... % usually false, want to overwrite the previous data? 
% %     'crop', false,... % used to limit the FOV from original size to the cropped size
% %     'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
% %     'LowerLimit', 0.5,...
% %     'LSImageCh1', [illumRt,filesep illum488CamA],...
% %     'BackgroundCh1', '/net/tkfastfs/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% % elseif length(data(1).channels) < 2 && ~isempty(counter560chan)
% %      disp('560')
% %     deskewData(data,...
% %     'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% %     'Overwrite', true,... % usually false, want to overwrite the previous data? 
% %     'crop', false,... % used to limit the FOV from original size to the cropped size
% %     'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
% %     'LowerLimit', 0.5,...
% %     'LSImageCh1', [illumRt,filesep illum560CamA],...
% %     'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif')
% % elseif length(data(1).channels) < 2 && ~isempty(counter642chan)
% %      disp('642')
% %     deskewData(data,...
% %     'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% %     'Overwrite', true,... % usually false, want to overwrite the previous data? 
% %     'crop', false,... % used to limit the FOV from original size to the cropped size
% %     'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
% %     'LowerLimit', 0.5,...
% %     'LSImageCh1', [illumRt,filesep illum642CamA],...
% %     'BackgroundCh1', '/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% % 
% % 
% % 
% % 
% % %%%%%%%%%%%%%%%%%%%%%% TWO CHANNELS %%%%%%%%%%%%%%%%%%%%%%
% % 
% % elseif length(data(1).channels)==2 && ~isempty(counter560chan) && ~isempty(counter488chan)
% %     disp('488-560');
% %     
% %     deskewData(data,...
% %         'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% %         'Overwrite', true,... % usually false, want to overwrite the previous data?
% %         'crop', false,... % used to limit the FOV from original size to the cropped size
% %         'LLFFCorrection', doIllum,... % lattice light flat field correction (aka illumination correction)
% %         'LowerLimit', 0.5,...
% %         'LSImageCh1', [illumRt,filesep illum488CamA],...
% %         'LSImageCh2', [illumRt,filesep illum560CamA],...
% %         'BackgroundCh1', dark488,...
% %         'BackgroundCh2', dark560)
% %     
% %     
% % %     
% %     data_multipleChan = data;
% %     if length(data_multipleChan(1).channels)== 2
% %         disp('2 channels')
% %         if (XYZ488.z < XYZ560.z)
% %             ch1_488_logical = true;
% %             ch2_560_logical = false;
% %         else
% %             ch1_488_logical = false;
% %             ch2_560_logical = true;
% %         end
% %         GU_zOffset3D(data_multipleChan,...
% %             'zOffset', abs(XYZ488.z - XYZ560.z)*const,...
% %             'RawData', false,...
% %             'DS', true,...
% %             'Ch1', ch1_488_logical,...
% %             'Ch2', ch2_560_logical);
% %     end
% % 
% % 
% % elseif length(data(1).channels)==2 && ~isempty(counter642chan) && ~isempty(counter560chan)
% %     disp('560-642');
% % 
% %       deskewData(data,...
% %     'sCMOSCameraFlip', false,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% %     'Overwrite', true,... % usually false, want to overwrite the previous data? 
% %     'crop', false,... % used to limit the FOV from original size to the cropped size
% %     'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
% %     'LowerLimit', 0.5,...
% %     'LSImageCh1', [illumRt,filesep illum560CamA],...
% %     'LSImageCh2', [illumRt,filesep illum642CamA],...
% %     'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif',...
% %     'BackgroundCh2', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% % 
% %   %chroma offset
% %     
% %     
% %     
% %     data_multipleChan =data;
% %     if length(data_multipleChan(1).channels)== 2
% %         disp('2 channels')
% %         if (XYZ488.z < XYZ642.z)
% %             ch1_488_logical = true;
% %             ch2_642_logical = false;
% %         else
% %             ch1_488_logical = false;
% %             ch2_642_logical = true;
% %         end
% %         GU_zOffset3D(data_multipleChan,...
% %             'zOffset', abs(XYZ560.z - XYZ642.z)*const,...
% %             'RawData', false,...
% %             'DS', true,...
% %             'Ch1', ch1_488_logical,...
% %             'Ch2', ch2_642_logical);
% %     end
% % 
% % elseif length(data(1).channels)==2 && ~isempty(counter642chan) && ~isempty(counter488chan)
% %     disp('488-642');
% % 
% %       deskewData(data,...
% %     'sCMOSCameraFlip', false,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% %     'Overwrite', true,... % usually false, want to overwrite the previous data? 
% %     'crop', false,... % used to limit the FOV from original size to the cropped size
% %     'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
% %     'LowerLimit', 0.5,...
% %     'LSImageCh1', [illumRt,filesep illum488CamA],...
% %     'LSImageCh2', [illumRt,filesep illum642CamA],...
% %     'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif',...
% %     'BackgroundCh2', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% % 
% % 
% %     
% %     
% %     data_multipleChan =data;
% %     if length(data_multipleChan(1).channels)== 2
% %         disp('2 channels')
% %         if (XYZ488.z < XYZ642.z)
% %             ch1_488_logical = true;
% %             ch2_642_logical = false;
% %         else
% %             ch1_488_logical = false;
% %             ch2_642_logical = true;
% %         end
% %         GU_zOffset3D(data_multipleChan,...
% %             'zOffset', abs(XYZ488.z - XYZ642.z)*const,...
% %             'RawData', false,...
% %             'DS', true,...
% %             'Ch1', ch1_488_logical,...
% %             'Ch2', ch2_642_logical);
% %     end
% % 
% %     
% % else
% %     disp('488-560-642')
% % %     datatemp = [data,data2,data3];
% % % data = datatemp
% %     
% %      deskewData(data,...
% %     'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
% %     'Overwrite', true,... % usually false, want to overwrite the previous data? 
% %     'crop', false,... % used to limit the FOV from original size to the cropped size
% %     'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
% %     'LowerLimit', 0.5,...
% %     'LSImageCh1', [illumRt,filesep illum488CamA],...
% %     'LSImageCh2', [illumRt,filesep illum560CamA],...
% %     'LSImageCh3', [illumRt,filesep illum642CamA],...
% %     'BackgroundCh1', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif',...
% %     'BackgroundCh2', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamBDC.tif',...
% %     'BackgroundCh3', '/net/10.117.38.184/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
% % 
% %     
% %     
% % %     rt_488 = '/net/tkfastfs/scratch/Gustavo/20201022_P5_P55_sCMOS_Gu/LLSCalibrations/chroma/Ex00_488_560_642_z0p5/ch488nmCamA/DS/';
% % %     rt_560 = '/net/tkfastfs/scratch/Gustavo/20201022_P5_P55_sCMOS_Gu/LLSCalibrations/chroma/Ex00_488_560_642_z0p5/ch560nmCamB/DS/';
% % %     rt_642 = '/net/tkfastfs/scratch/Gustavo/20201022_P5_P55_sCMOS_Gu/LLSCalibrations/chroma/Ex00_488_560_642_z0p5/ch642nmCamA/DS/';
% % %     
% % %     FileName488camA = 'chroma_CamA_ch0_stack0000_488nm_0000000msec_0005999292msecAbs.tif';
% % %     FileName560camB = 'chroma_CamB_ch1_stack0000_560nm_0000000msec_0005999292msecAbs.tif';
% % %     FileName642camA = 'chroma_CamA_ch2_stack0000_642nm_0000000msec_0005999292msecAbs.tif';
% % %     
% % %     
% % %     [~, ~, XYZ488, ~, ~] = GU_estimateSigma3D(rt_488,FileName488camA); % Get XYZ by adding a PSF
% % %     [~, ~, XYZ560, ~, ~] = GU_estimateSigma3D(rt_560,FileName560camB); % Get XYZ by adding a PSF
% % %     [~, ~, XYZ642, ~, ~] = GU_estimateSigma3D(rt_642,FileName642camA); % Get XYZ by adding a PSF
% % %     const = 0.5*sind(31.5);
% % %     
% % %     disp('3 channels') 
% % %     for d:data
% % 
% % % for jj = 1:length(data)
% % %     dd = data(jj);
% % %     const = 0.2*sind(31.5);
% %     
% %     GU_zOffset3D(data,...
% %         'zOffset', abs(XYZ488.z - XYZ560.z)*const,... 
% %         'RawData', false,...
% %         'DS', true,...
% %         'Ch1', false,... % 488 % adds to the end of the stack (false)
% %         'Ch2', true,... % 560 % adds to the start of the stack (true)
% %         'Ch3', true); % 642 % adds to the start of the stack (true)
% % 
% %     GU_zOffset3D(data,...
% %         'zOffset', abs(XYZ560.z - XYZ642.z)*const,... 
% %         'RawData', false,...
% %         'DS', true,...
% %         'Ch1', false,... % 488 % adds to the start of the stack (true)
% %         'Ch2', false,... % 560 % adds to the end of the stack (bottom)
% %         'Ch3', true); % 642 % adds to the start of the stack (true)
% % 
% %       
% % % end
% % end
% % % GU_calcImageProjections(data)
% % end
% % % tt(ii) =t
% %     
% %     
% % else
% %     disp('Not sample scan, no transformation applied.');
% % end
% % 
% % end
