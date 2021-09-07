%[data] = deskewData(varargin) de-skews and rotates light sheet microscope data sets
% The function launches a small GUI enabling input of acquisition parameters, after which
% it prompts for input of cropping regions to minimize file sizes. By default, the function
% generates the de-skewed data required for processing; optionally the function can also
% generate rotated frames for visualization.
%
% Inputs (optional
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

function [data] = deskewData_KGO2(varargin)

Cam = {'CamA','CamB'};
% Chan = {'stack\d+_405nm','stack\d+_445nm','stack\d+_488nm','stack\d+_514nm','stack\d+_560nm','stack\d+_592nm','stack\d+_607nm','stack\d+_642nm'};
Chan = {'405','445','488','514','560','592','607','642'};

ip = inputParser;
ip.CaseSensitive = false;
ip.addOptional('data', [], @isstruct); % data structure from loadConditionData
ip.addParamValue('Overwrite', false, @islogical);
ip.addParamValue('MovieSelector', 'cell', @ischar);
ip.addParamValue('Crop', false, @islogical);
ip.addParamValue('SkewAngle', 31.5, @isscalar);
ip.addOptional('Reverse', false, @islogical);
ip.addParamValue('Rotate', false, @islogical);
ip.addParamValue('CheckFrameMismatch', false, @islogical);
ip.addParamValue('LoadSettings', false, @islogical);
% sCMOS camera flip
ip.addParamValue('sCMOSCameraFlip', false, @islogical);
% LLSM Flat-FieldCorrection
ip.addParamValue('LLFFCorrection', false, @islogical);
ip.addParamValue('LowerLimit', 0.4, @isnumeric); % this value is the lowest
ip.addParamValue('LSImageCh1', '' , @isstr);
ip.addParamValue('LSImageCh2', '' , @isstr);
ip.addParamValue('LSImageCh3', '' , @isstr);
ip.addParamValue('LSImageCh4', '' , @isstr);
ip.addParamValue('BackgroundCh1', '' , @isstr);
ip.addParamValue('BackgroundCh2', '' , @isstr);
ip.addParamValue('BackgroundCh3', '' , @isstr);
ip.addParamValue('BackgroundCh4', '' , @isstr);
ip.addParamValue('Save16bit', false , @islogical); % saves deskewed data as 16 bit -- not for quantification
ip.addParamValue('LSImageChannels', [], @isstruct);
ip.addParamValue('BkImageChannels', [], @iscell);
ip.parse(varargin{:});
data = ip.Results.data;
if isempty(data)
    data = loadConditionData3D('MovieSelector', ip.Results.MovieSelector);
end
nd = numel(data);
I = ip.Results.LSImageChannels;
B = ip.Results.BkImageChannels;

% LS Image and Background Paths
% LLFFCorrection = ip.Results.LLFFCorrection;
LLFFCorrection = I.doIllum;

% lattice light flat field
%%%%%%%%%%%%%%%%%% LLFF correction and background images  %%%%%%%%%%%%%%%%%%
for ii = 1:length(data.channels)
    % get channel info
    expression = '/ch(\w+)nm.*(Cam[AB])';
    
    % matches for debugging purposes
    [tokens,matches] = regexp(data.channels{ii},expression,'tokens','match');
    
    if isempty(tokens)
        cam = 'CamA';
        channel = regexpi(data.channels{ii},'((?<=/ch)\d+(?=nm))','match','once');
    else
        assert(length(tokens{1}) == 2)
        channel = char(tokens{1}{1});
        cam = char(tokens{1}{2});
    end
    
    
    keyCandidate = sprintf('ch%snm%s',channel, cam);
    try 
        I.tif_av(keyCandidate)
    catch
        break
    end
    
    
    
    % match channel with the given channel cells
    idx_cam_candidates = regexpi(cam,Cam);
    idx_cam = find(~cellfun(@isempty,idx_cam_candidates));
    assert( length(idx_cam) == 1);
    
    idx_chan_candidates = regexpi(channel,Chan);
    idx_chan = find(~cellfun(@isempty,idx_chan_candidates));
    assert( length(idx_chan) == 1);
    if isempty(I.chan{idx_cam, idx_chan})
        LLFFCorrection = false;
        continue
    end
    
    LSImage{ii} = [I.dir filesep I.chan{idx_cam, idx_chan}];
    
    BKImage{ii} = B{idx_cam};
    
    
end
disp(1)


%-----------------------------------------------------------------------------------------
% 0) Repair dropped frames in movies from Wes's systems
%-----------------------------------------------------------------------------------------
if ip.Results.CheckFrameMismatch
    frameID = '_stack';
    mismatch = false;
    for i = 1:nd
        for c = 1:numel(data(i).channels)
            idx = str2double(regexpi(data(i).framePaths{c}, ['(?<=' frameID ')\d+'], 'match', 'once'));
            if any(getMultiplicity(idx)>1)
                fprintf('Frame mismatch in channel %d of %s detected ...\n', c, getShortPath(data(i)));
                restoreDroppedFrames(data(i), frameID);
                fprintf(' ... repaired\n');
                mismatch = true;
            end
        end
    end
    % reload movie information if dropped frames were repaired
    if mismatch
        fprintf('Re-loading data after frame repair.\n');
        data = loadConditionData('MovieSelector', ip.Results.MovieSelector);
    end
end

%-----------------------------------------------------------------------------------------
% 1) Check whether de-skewing has already been run
%-----------------------------------------------------------------------------------------
hasDS = false(1,nd);
hasDSR = false(1,nd);
for i = 1:nd
    % check whether de-skewing has been run
    tmp = dir([data(i).source 'DS']);
    tmp = {tmp(~[tmp.isdir]).name}';
    tmp = tmp(~cellfun(@isempty, regexpi(tmp, '\.tif')));
    hasDS(i) = numel(tmp)==data(i).movieLength;
    
    % check whether rotation has already been run
    tmp = dir([data(i).source 'DSR']);
    tmp = {tmp(~[tmp.isdir]).name}';
    tmp = tmp(~cellfun(@isempty, regexpi(tmp, '\.tif')));
    hasDSR(i) = numel(tmp)==data(i).movieLength;
end


% destination path to store crop area & dynamic range
apath = arrayfun(@(i) [i.source 'Analysis' filesep], data, 'unif', 0);
for i = 1:numel(data)
    if ~(exist(apath{i},'dir')==7)
        [~,~] = mkdir(apath{i});
    end
end

%-----------------------------------------------------------------------------------------
% 2) Get system parameters for each data set
%-----------------------------------------------------------------------------------------
dz = [data.dz];
xyPixelSize = [data.pixelSize];
objectiveScan = [data.objectiveScan];
reversed = [data.reversed];

if ~all(hasDS) || ip.Results.Overwrite || (ip.Results.Rotate && ~all(hasDSR))
    if ip.Results.LoadSettings
        loadSettings(data);
        drawnow;
    end
    
    for i = 1:nd
        prm.dz = dz(i);
        prm.xyPixelSize = xyPixelSize(i);
        prm.objectiveScan = objectiveScan(i);
        prm.reversed = reversed(i);
        save([apath{i} 'settings.mat'], '-struct', 'prm');
    end
end

%-----------------------------------------------------------------------------------------
% 3) Get crop area ROI for de-skewing
%-----------------------------------------------------------------------------------------
roiVec = cell(1,nd);

if ip.Results.Crop && ~ip.Results.sCMOSCameraFlip
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
        roiVec{i} = [1 1 data(i).imagesize(2) data(i).imagesize(1)];
    end
elseif ~ip.Results.Crop && ip.Results.sCMOSCameraFlip
    for i = 1:nd
        roiVec{i} = [1 1 data(i).imagesize(1) data(i).imagesize(2)];
    end
elseif ip.Results.Crop && ip.Results.sCMOSCameraFlip
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

%-----------------------------------------------------------------------------------------
% 4) De-skew data
%-----------------------------------------------------------------------------------------
% tic
for i = 1:nd
    if ~hasDS(i) || ip.Results.Overwrite
        
        nf = data(i).movieLength;
        nCh = numel(data(i).channels);
        dRange = zeros(nf,2,nCh);
        
        % crop coordinatesnd image
        xa = roiVec{i}(1) + (0:roiVec{i}(3)-1);
        ya = roiVec{i}(2) + (0:roiVec{i}(4)-1);
        
        if ip.Results.Crop && ip.Results.sCMOSCameraFlip
            ya = roiVec{i}(1) + (0:roiVec{i}(3)-1);
            xa = roiVec{i}(2) + (0:roiVec{i}(4)-1);
        end
        
        for c = 1:nCh
            dsPath = [data(i).channels{c} 'DS' filesep];
            [~,~] = mkdir(dsPath);
            if LLFFCorrection
                LSIm = readtiff(LSImage{c});
                BKIm = readtiff(BKImage{c});
                % average out the backgrou
                if ndims(BKIm)==3
                    BKIm = squeeze(mean(BKIm,3));
                end
                
                % average z planes of LS image
                if ndims(LSImage)==3
                    LSImage = squeeze(mean(LSImage,3));
                end
            end
                p = tic;

            if ~objectiveScan(i)
                fprintf('De-skewing ''%s'', channel %d:   0%%', getShortPath(data(i)), c);
                
                parfor f = 1:nf % PARFOR
                    
                    frame = double(readtiff(data(i).framePaths{c}{f})); %#ok<PFBNS>
                    
                    % sCMOS camera rotation / flip if necessary
                    
                    if ip.Results.sCMOSCameraFlip
                        
                        [~, fn, ~] = fileparts(data(i).framePaths{c}{f});
                        camidx = regexpi(fn, 'Cam\D') + 3;
                        cam = fn(camidx);
                        frame = GU_sCMOSCameraFlip(frame, cam);
                    end
                    
                    % LS FF Correction
                    
                    if LLFFCorrection
                        frame = GU_LSFlatFieldCorrection(frame,LSIm,BKIm,'LowerLimit', ip.Results.LowerLimit);
                    end
                    
                    
                    ds = frame(ya,xa,:);
                    
                    
                    
                    %dsRef = shear3DinDim2(frame(ya,xa,:), ip.Results.SkewAngle, bReverse(i), dz(i), xyPixelSize(i), 0, 0);
                    ds = deskewFrame3D(ds, ip.Results.SkewAngle, dz(i), xyPixelSize(i), reversed(i),...
                        'Crop', ip.Results.Crop, 'Reverse', ip.Results.Reverse); %#ok<PFBNS>
                    
                    [~,fname] = fileparts(data(i).framePaths{c}{f});
                    
           
                    writetiff(single(ds), [dsPath fname '.tif']);
                    
                    dRange(f,:,c) = [min(ds(:)) max(ds(:))];
                    fprintf('\b\b\b\b%3d%%', round(100*f/nf));
                    
                    
                    
                end
                frame = double(readtiff(data(i).framePaths{c}{1}));
                
                if LLFFCorrection
                    if sum(size(frame,1:2) > size(LSIm,1:2)) > 1
                        save(fullfile(dsPath,'LLFF_not_applied.txt'));
                    else
                        expression = [filesep '(\w+).tif'];
                        str = char(regexp(char(LSImage{c}),expression,'match'));
                        % do not include the .tif extention
                        %                         save([dsPath filesep 'AppliedLLFF_' str(2:end-4) '.txt']);
                        str = [dsPath filesep 'AppliedLLFF_' str(2:end-4) '.txt'];
                        fclose(fopen(str,'w'));
                        
                    end
                else
                    save(fullfile(dsPath,'LLFF_not_applied.txt'));
                end
                
                fprintf('\n');
                
                
            else % crop only
                fprintf('Cropping ''%s'', channel %d ... ', getShortPath(data(i)), c);
                parfor f = 1:nf
                    % load frame
                    frame = double(readtiff(data(i).framePaths{c}{f})); %#ok<PFBNS>
                    if ip.Results.sCMOSCameraFlip
                        [~, fn, ~] = fileparts(data(i).framePaths{c}{f});
                        camidx = regexpi(fn, 'Cam\D') + 3;
                        cam = fn(camidx);
                        frame = GU_sCMOSCameraFlip(frame, cam);
                    end
                    if LLFFCorrection
                        LSIm = readtiff(LSImage{c});
                        BKIm = readtiff(BKImage{c});
                        frame = GU_LSFlatFieldCorrection(frame,LSIm,BKIm,'LowerLimit', ip.Results.LowerLimit);
                    end
                    ds = frame(ya,xa,:);
                    [~,fname] = fileparts(data(i).framePaths{c}{f});
                    if ip.Results.Save16bit
                        writetiff(uin16(ds), [dsPath fname '.tif']);
                    else
                        writetiff(single(ds), [dsPath fname '.tif']);
                    end
                    dRange(f,:,c) = [min(ds(:)) max(ds(:))];
                end
                fprintf('done.\n');
            end
            toc(p)
        end
        save([apath{i} 'dynRange.mat'], 'dRange');
    end
end


%-----------------------------------------------------------------------------------------
% 4) Rotate data
%-----------------------------------------------------------------------------------------
if ip.Results.Rotate
    for i = 1:nd
        if ~hasDSR(i) || ip.Results.Overwrite
            load([apath{i} 'dynRange.mat']);
            
            for c = 1:numel(data(i).channels)
                dsPath = [data(i).channels{c} 'DS' filesep];
                dsrPath = [data(i).channels{c} 'DSR' filesep];
                [~,~] = mkdir(dsrPath);
                
                iRange = [min(dRange(:,1,c)) max(dRange(:,2,c))];
                
                fprintf('Rotating ''%s'' channel %d:   0%%', getShortPath(data(i)), c);
                nf = data(i).movieLength;
                parfor f = 1:nf
                    [~,fname] = fileparts(data(i).framePaths{c}{f}); %#ok<PFBNS>
                    ds = readtiff([dsPath fname '.tif']);
                    dsr = rotateFrame3D(ds, ip.Results.SkewAngle, data(i).zAniso, reversed(i),...
                        'Crop', true, 'ObjectiveScan', objectiveScan(i)); %#ok<PFBNS>
                    writetiff(uint16(scaleContrast(dsr, iRange, [0 65535])), [dsrPath fname '.tif']);
                    fprintf('\b\b\b\b%3d%%', round(100*f/nf));
                end
                fprintf('\n');
            end
        end
    end
end


    function loadSettings(data)
        
        nd = numel(data);
        
        tpos = get(0, 'DefaultFigurePosition');
        tpos = [tpos(1)+tpos(3)/2-150 tpos(2)+tpos(4)/2-75 400 245];
        
        selectedData = 1;
        
        pht = figure('Units', 'pixels', 'Position', tpos, 'Name', 'De-skewing settings',...
            'PaperPositionMode', 'auto', 'Menubar', 'none', 'Toolbar', 'none',...
            'Color', get(0,'defaultUicontrolBackgroundColor'),...
            'DefaultUicontrolUnits', 'pixels', 'Units', 'pixels',...
            'NumberTitle', 'off');
        
        
        % selection sliders
        b  = 155;
        if nd>1
            uicontrol(pht, 'Style', 'text', 'String', 'Select data set:',...
                'Position', [5 b+35 120 20], 'HorizontalAlignment', 'left');
            dataTxt = uicontrol(pht, 'Style', 'text', 'String', ['# ' num2str(selectedData)],...
                'Position', [5 b+18 40 20], 'HorizontalAlignment', 'left');
            dataSlider = uicontrol(pht, 'Style', 'slider',...
                'Value', 1, 'SliderStep', 1/(nd-1)*[1 1], 'Min', 1, 'Max', nd,...
                'Position', [50 b+20 200 18]);
            addlistener(handle(dataSlider), 'Value', 'PostSet', @dataSlider_Callback);
        end
        dataTxt2 = uicontrol(pht, 'Style', 'text', 'String', getDirFromPath(data(selectedData).source),...
            'Position', [20 b-5 300 20], 'HorizontalAlignment', 'left');
        
        % Category selection buttons
        b = 115;
        uicontrol(pht, 'Style', 'text', 'String', 'Select system: ',...
            'Position', [5 b 90 20], 'HorizontalAlignment', 'left');
        
        frameChoice = uicontrol(pht, 'Style', 'popup',...
            'String', {'Slice', 'Bi-Chang', 'Wes'},...
            'Position', [105 b+3 100 20], 'Callback', @frameChoice_Callback);
        function frameChoice_Callback(varargin)
            contents = cellstr(get(frameChoice, 'String'));
            switch contents{get(frameChoice, 'Value')}
                case 'Slice'
                    reversed(selectedData) = false;
                    xyPixelSize(selectedData) = 0.104;
                case 'Bi-Chang'
                    reversed(selectedData) = true;
                    xyPixelSize(selectedData) = 0.114;
                case 'Wes'
                    reversed(selectedData) = false;
                    xyPixelSize(selectedData) = 0.104;
            end
        end
        
        uicontrol(pht, 'Style', 'text', 'String', ['z-step [' char(181) 'm] :'],...
            'Position', [225 b 190 20], 'HorizontalAlignment', 'left');
        dzText = uicontrol(pht, 'Style', 'edit',...
            'String', num2str(dz(selectedData)),...
            'Position', [310 b 80 25], 'Callback', @dzText_Callback);
        
        function dzText_Callback(varargin)
            dz(selectedData) = str2double(get(dzText, 'String'));
        end
        
        
        
        scanCheck = uicontrol(pht, 'Style', 'checkbox', 'String', 'Objective scan (no de-skewing)',...
            'Position', [85 b-30 220 15], 'HorizontalAlignment', 'left',...
            'Value', objectiveScan(selectedData), 'Callback', @objectiveScan_Callback);
        function objectiveScan_Callback(varargin)
            objectiveScan(selectedData) = get(scanCheck, 'Value');
        end
        
        
        uicontrol(pht, 'Style', 'pushbutton', 'String', 'Apply',...
            'Position', [180 5 100 20], 'HorizontalAlignment', 'left',...
            'Callback', @applyButton_Callback);
        
        function dataSlider_Callback(~, eventdata)
            % update z-step first
            %dz(selectedData) = str2double(get(dzText, 'String'))
            
            obj = get(eventdata, 'AffectedObject');
            selectedData = round(get(obj, 'Value'));
            %set(selectedData, 'Value', selectedData);
            set(dataTxt, 'String', ['# ' num2str(selectedData)]);
            set(dataTxt2, 'String', getDirFromPath(data(selectedData).source));
            
            % refresh system choice
            if ~reversed(selectedData) && xyPixelSize(selectedData)==0.114
                set(frameChoice, 'Value', 1);
            elseif reversed(selectedData) && xyPixelSize(selectedData)==0.114
                set(frameChoice, 'Value', 2);
            else
                set(frameChoice, 'Value', 3);
            end
            
            % refresh scan
            set(scanCheck, 'Value', objectiveScan(selectedData));
            
            set(dzText, 'String', num2str(dz(selectedData)));
        end
        
        function applyButton_Callback(varargin)
            dz(selectedData) = str2double(get(dzText, 'String'));
            close(pht);
        end
        
        uiwait(pht);
    end
end

