%[data] = deskewData(varargin) de-skews and rotates light sheet microscope data sets
% The function launches a small GUI enabling input of acquisition parameters, after which
% it prompts for input of cropping regions to minimize file sizes. By default, the function
% generates the de-skewed data required for processing; optionally the function can also
% generate rotated frames for visualization.
%
% Inputs (optional):
%      data : structure returned by loadConditionData()
%
% Options ('specifier', value):
%       'Overwrite' : true|{false}, enables overwriting of previously de-skewed/rotated data
%   'MovieSelector' : String in directory name identifying individual movies. Default: 'cell'
%            'Crop' : {true}|false, automatic cropping of the de-skewed movie at the boundaries
%       'SkewAngle' : Sets the scanning angle of the system. Default: 32.8 degrees
%          'Rotate' : true|{false}. Set to true to generate rotated frames for visualization

% Francois Aguet, 11/2013
% edited Gokul Upadhyayula, Sep 2015
% GU: rotates sCMOS data - case sensitive 'CamA' (rotation) &  'CamB' (rotation and camera flip)
% GU: adds light-sheet correction

% camAbk = squeeze(mean(readtiff('/media/tklab/Data/data32b/Eric/calibrations/Ex04_camA-B_darkCurrent-camPatternMeasurement_z0p2/ex04_CamA_ch0_CAM1_stack0000_488nm_0000000msec_0001057088msecAbs_000x_000y_000z_0000t.tif'),3));
% writetiff(camAbk, ['/media/tklab/Data/data32b/Eric/calibrations/Ex04_camA-B_darkCurrent-camPatternMeasurement_z0p2/camADC.tif'])
% camBbk = squeeze(mean(readtiff('/media/tklab/Data/data32b/Eric/calibrations/Ex04_camA-B_darkCurrent-camPatternMeasurement_z0p2/ex04_CamB_ch1_CAM1_stack0000_560nm_0000000msec_0001057088msecAbs_000x_000y_000z_0000t.tif'),3));
% writetiff(camBbk, ['/media/tklab/Data/data32b/Eric/calibrations/Ex04_camA-B_darkCurrent-camPatternMeasurement_z0p2/camBDC.tif'])
% rt = '/media/tklab/Data/data32b/Eric/calibrations/Ex04_camA-B_darkCurrent-camPatternMeasurement_z0p2/';
% LLCopts = {'LLFFCorrection',true, 'LowerLimit',0.5, ...
%     'LSImageCh1', ['/media/tklab/Data/data32b/Eric/calibrations/Ex02_fieldCorrection_488-560_z0p2/EX02_CamB_ch1_stack0000_560nm_0000000msec_0001815773msecAbs.tif'], ...
%     'LSImageCh2',['/media/tklab/Data/data32b/Eric/calibrations/Ex01_fieldCorrection_642_z0p2/ex01_CamA_ch0_stack0000_642nm_0000000msec_0001310798msecAbs.tif'],...
%     'LSImageCh3','',...
%     'LSImageCh4','',...
%     'BackgroundCh1',[rt 'camBDC.tif'],...
%     'BackgroundCh2',[rt 'camADC.tif'],...
%     'BackgroundCh3','',...
%     'BackgroundCh4',''};
%
% deskewData(data, LLCopts{:});

% 1. camera rot/flip; 2. flat-field correction; 3. deskew; 4. rotate

function AutoDS_deskewData20191117b(M,S,Meta)


% ip = inputParser;
% ip.CaseSensitive = false;
% ip.addOptional('data', [], @isstruct); % data structure from loadConditionData
% ip.addParamValue('Overwrite', false, @islogical);
% ip.addParamValue('MovieSelector', 'cell', @ischar);
% ip.addParamValue('Crop', false, @islogical);
% ip.addParamValue('SkewAngle', 31.5, @isscalar);
% ip.addOptional('Reverse', false, @islogical);
% ip.addParamValue('Rotate', false, @islogical);
% ip.addParamValue('CheckFrameMismatch', false, @islogical);
% ip.addParamValue('LoadSettings', false, @islogical);
% % sCMOS camera flip
% ip.addParamValue('sCMOSCameraFlip', false, @islogical);
% % LLSM Flat-FieldCorrection
% ip.addParamValue('LLFFCorrection', false, @islogical);
% ip.addParamValue('LowerLimit', 0.4, @isnumeric); % this value is the lowest
% ip.addParamValue('LSImageCh1', '' , @isstr);
% ip.addParamValue('LSImageCh2', '' , @isstr);
% ip.addParamValue('LSImageCh3', '' , @isstr);
% ip.addParamValue('LSImageCh4', '' , @isstr);
% ip.addParamValue('BackgroundCh1', '' , @isstr);
% ip.addParamValue('BackgroundCh2', '' , @isstr);
% ip.addParamValue('BackgroundCh3', '' , @isstr);
% ip.addParamValue('BackgroundCh4', '' , @isstr);
% ip.addParamValue('Save16bit', false , @islogical); % saves deskewed data as 16 bit -- not for quantification
% ip.parse(varargin{:});
% data = ip.Results.data;
% if isempty(data)
%     data = loadConditionData3D('MovieSelector', ip.Results.MovieSelector);
% end

% --------------------
nd = numel(M);
% --------------------

ip.Results.LowerLimit = 0.4;

% nd = M.idxTrans(end) -1; % number of tif images to be DSed
% LS Image and Background Paths
LLFFCorrection = S.illum;
if LLFFCorrection % added 20200916
for ii = 1:length(Meta.chan)
    for jj = 1:length(S.I.tif)
           idx = regexp(S.I.tif{jj}, num2str(Meta.chan(ii)));

        % find the first illum file that comes up
        if (idx > 0)
            illum{ii,1} = S.I.tif{jj};
            break;
        end
    end
end
end
Mtransferred = M.transferred;

% % destination path to store crop area & dynamic range
% apath = arrayfun(@(i) [i.source 'Analysis' filesep], data, 'unif', 0);
apath = [Meta.dirChan{1}, filesep 'Analysis'];
if (~exist(apath,'dir'))
    mkdir(apath);
end

% MAKE DS DIRECTORY
for ii = 1:length(Meta.dirChan)
    if (~exist([Meta.dirChan{ii} filesep 'DS'],'dir'))
        mkdir([Meta.dirChan{ii} filesep 'DS']);
    end
end


%-----------------------------------------------------------------------------------------
% 2) Get system parameters for each data set
%-----------------------------------------------------------------------------------------
% dz = Meta.ds;
% xyPixelSize = [data.pixelSize];
% objectiveScan = [data.objectiveScan];
% reversed = [data.reversed];

% length('Z galvo & piezo') = 15
%length('Sample piezo')     = 12
if length(Meta.zmotion) > 13
    objectiveScan = true;
else
    objectiveScan = false;
end
% 
% if ~all(hasDS) || ip.Results.Overwrite || (ip.Results.Rotate && ~all(hasDSR))
%     if ip.Results.LoadSettings
%         loadSettings(data);
%         drawnow;
%     end
%     
%     for i = 1:nd
%         prm.dz = dz(i);
%         prm.xyPixelSize = xyPixelSize(i);
%         prm.objectiveScan = objectiveScan(i);
%         prm.reversed = reversed(i);
%         save([apath{i} 'settings.mat'], '-struct', 'prm');
%     end
% end

%-----------------------------------------------------------------------------------------
% 3) Get crop area ROI for de-skewing
%-----------------------------------------------------------------------------------------
roiVec = cell(1,nd);
% 
ip.Results.Crop = false;
ip.Results.sCMOSCameraFlip = Meta.camflip;

if ip.Results.Crop && ~ip.Results.sCMOSCameraFlip
    % SHOULD NEVER RUN
    for i = 1:nd
        [~,~] = mkdir(apath{i});
        roiPath = [apath{i} 'cropROI.mat'];
        if exist(roiPath, 'file')==2 && ~ip.Results.Overwrite
            load(roiPath);
            roiVec{i} = cropROI;
        else
            cropROI = getCropRegions3D(data(i), 'Overwrite', ip.Results.Overwrite);
            cropROI = cropROI{1};
            save(roiPath, 'cropROI');
            roiVec{i} = cropROI;
        end
    end
elseif ~ip.Results.Crop && ~ip.Results.sCMOSCameraFlip
    for i = 1:nd
        %         roiVec{i} = [1 1 data(i).imagesize(2) data(i).imagesize(1)];
        roiVec{i} = [1 1 Meta.roi(2) Meta.roi(1)];
    end
elseif ~ip.Results.Crop && ip.Results.sCMOSCameraFlip
    for i = 1:nd
        %         roiVec{i} = [1 1 data(i).imagesize(1) data(i).imagesize(2)];
        roiVec{i} = [1 1 Meta.roi(1) Meta.roi(2)];
    end
elseif ip.Results.Crop && ip.Results.sCMOSCameraFlip
    % SHOULD NEVER RUN
    for i = 1:nd
        [~,~] = mkdir(apath{i});
        roiPath = [apath{i} 'cropROI.mat'];
        if exist(roiPath, 'file')==2 && ~ip.Results.Overwrite
            load(roiPath);
            roiVec{i} = cropROI;
        else
            cropROI = getCropRegions3D(data(i), 'Overwrite', ip.Results.Overwrite);
            cropROI = cropROI{1};
            save(roiPath, 'cropROI');
            roiVec{i} = cropROI;
        end
    end
end
SkewAngle = 31.5;
ip.Results.SkewAngle = SkewAngle;
ip.Results.LowerLimit = 0.5;
dz = Meta.ds;
xyPixelSize = 0.104;
reversed = false;


%-----------------------------------------------------------------------------------------
% 4) De-skew data
%-----------------------------------------------------------------------------------------
% for i = 1:nd
% for i=M.idxTrans(1): M.idxTrans(end)-1
tic
for i = 1:nd
    %if ~hasDS(i) || ip.Results.Overwrite
    if true
        
        nf_i = length(dir([Meta.dirChan{end} filesep 'DS' filesep '*.tif']));
        nf_end = length(dir([Meta.dirChan{end} filesep '*.tif']))-1;
        if nf_end <0
            nf_end = 0;
        end
        

        nCh = numel(Meta.chan);
        dRange = zeros(nf_end,2,nCh);
        
        % crop coordinates
        xa = roiVec{i}(1) + (0:roiVec{i}(3)-1);
        ya = roiVec{i}(2) + (0:roiVec{i}(4)-1);
        
        if ip.Results.Crop && ip.Results.sCMOSCameraFlip
            ya = roiVec{i}(1) + (0:roiVec{i}(3)-1);
            xa = roiVec{i}(2) + (0:roiVec{i}(4)-1);
        end
        
        for c = 1:nCh
            dsPath = [Meta.dirChan{c,1} filesep 'DS' filesep];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if (length(Meta.dirChan) > 2)
            if c == 1
                c = 2;
            elseif c == 2
                c = 1;
            end
            end
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if ~objectiveScan
                
                for f = nf_i:nf_end
                    fprintf('%s\t\tDeskewing ch%03d stack%4d\n',timeStr,Meta.chan(c), nf_i);
                    str = sprintf('*stack%04d*',f);
                    dd = dir([Meta.dirChan{c} filesep str]);
                    if (isempty(Mtransferred{f+1,c}))
                        Mtransferred{f+1,c} = [dd(1).folder filesep dd(1).name];
                        fprintf('%s\t\t stack%04d, channel %d loaded in deskewData\n', timeStr, f, Meta.chan(c))
                        
                    end
                    
                    
                    frame = double(readtiff(Mtransferred{f+1,c})); % Ok
                    if Meta.camflip % ok
                        [~, fn, ~] = fileparts(Mtransferred{f+1,c});
                        camidx = regexpi(fn, 'Cam\D') + 3;
                        cam = fn(camidx);
                        frame = GU_sCMOSCameraFlip(frame, cam); % check
                    end 
                    toc
                
                    % LS FF Correction
                    LLFFCorrection = S.illum;
                    
                    if LLFFCorrection
                        fprintf('Applying LLFF correction\n');
%                         LSIm = readtiff([S.I.dir, filesep, illum{c}]);
                        % -----
                        BKImage = getBKimage(Meta,c);
                        % --------
                        BKIm = readtiff(BKImage); % 
                        % get the illumination correction
%                         LSIm = getLSIm(c,S, Meta);
                        %                         frame = GU_LSFlatFieldCorrection(frame,LSIm,BKIm,'LowerLimit', ip.Results.LowerLimit); % check
                        frame = GU_LSFlatFieldCorrection(frame,readtiff([S.I.dir filesep S.I.tif{c}]),BKIm,'LowerLimit', ip.Results.LowerLimit); % check

                    end
                    
                    ds = frame(ya,xa,:);
                    
%                     dsRef = shear3DinDim2(frame(ya,xa,:), ip.Results.SkewAngle, bReverse(i), dz(i), xyPixelSize(i), 0, 0);
%                     ds = deskewFrame3D(ds, ip.Results.SkewAngle, dz(i), xyPixelSize(i), reversed(i),...
%                       'Crop', ip.Results.Crop, 'Reverse', ip.Results.Reverse); %#ok<PFBNS>
                    
                    ds = AutoDS_deskewFrame3D20191117(ds, SkewAngle, dz, xyPixelSize, reversed); %%%#ok<PFBNS>%add option here
                    
                    
                    [~,fname] = fileparts(Mtransferred{f+1,c});
                    % copy file to the DS
                    writetiff(single(ds), [dsPath fname '.tif']);
                    M.DSed{f+1,c} = [dsPath fname '.tif'];
                    dRange(f+1,:,c) = [min(ds(:)) max(ds(:))];
                    fprintf('\b\b\b\b%3d%%\n', round(100*f/nf_end));
                end
                
            end
        end
        save([apath filesep 'dynRange.mat'], 'dRange');
    end
end
