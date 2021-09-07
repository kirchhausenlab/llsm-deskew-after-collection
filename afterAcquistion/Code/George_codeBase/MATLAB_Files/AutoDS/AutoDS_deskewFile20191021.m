%[data] = deskewData(varargin) de-skews and rotates light sheet microscope data sets
% The function launches a small GUI enabling input of acquisition parameters, after which
% it prompts for input of cropping regions to minimize file sizes. By default, the function
% generates the de-skewed data required for processing; optionally the function can also
% generate rotated frames for visualization.
%
% single file deskew
% Gokul & Simon June 2018
%last edited 7/26/18 by Simon


% 1. camera rot/flip; 2. flat-field correction; 3. deskew; 4. rotate

function AutoDS_deskewFile20191021(filepath, S)


SkewAngle = 31.5;
dz = 0.4;
pixelSize =0.104;


%
% ip = inputParser;
% ip.CaseSensitive = false;
%
% % file params
% ip.addRequired('filepath', @isstr);
% ip.addParameter('dz', 0.4, @isnumeric); % in um
% ip.addParameter('pixelSize', 0.104, @isnumeric); % in um
% ip.addParameter('ObjectiveScan', false, @islogical);
% ip.addParameter('ReverseScanDirection', false, @islogical);
% ip.addParameter('Interp', 'linear', @(x) any(strcmpi(x, {'cubic', 'linear'})));
%
% % operation params
% ip.addParameter('SkewAngle', 31.5, @isscalar);
% ip.addParameter('Rotate', false, @islogical);
%
% % sCMOS camera flip
% ip.addParameter('sCMOSCameraFlip', false, @islogical);
%
% % LLSM Flat-FieldCorrection
% ip.addParameter('LLFFCorrection', false, @islogical);
% ip.addParameter('LowerLimit', 0.4, @isnumeric); % this value is the lowest
% ip.addParameter('LSImageCh1', '' , @isstr);
% ip.addParameter('BackgroundCh1', '' , @isstr);
% ip.addParameter('Save16bit', true , @islogical); % saves deskewed data as 16 bit -- not for quantification
%
% % % --------------------------------------------------
% ip.addParameter('DSdone', false , @islogical); % saves deskewed data as 16 bit -- not for quantification
% % % --------------------------------------------------


%ip.addParameter('filepath', 'C:\Users\gokul\Desktop\test_folder_simon', @isstr);
% ip.parse('filepath', filepath, varargin{:});

%-----------------------------------------------------------------------------------------
% 1) Get system parameters for each data set
%-----------------------------------------------------------------------------------------

% filepath = ip.Results.filepath;
dz = S.ds;
xyPixelSize = S.pixSize;
if length(S.zmotion) < 13
    if (S.zmotion == 'Sample piezo')
        objectiveScan = false;
    end
else
    if (S.zmotion == 'Z galvo & piezo')
        objectiveScan = true;
    end
end

if (S.camFlip == 0)
    reversed = false;
else
    reversed = true;
end
zAniso = dz/xyPixelSize;

% LS Image and Background Paths
if (~isempty(S.illum))
    LLFFCorrection = false;
else
    LLFFCorrection = true;
end
% LSImage = ip.Results.LSImageCh1;
% BKImage = ip.Results.BackgroundCh1;

%-----------------------------------------------------------------------------------------
% 4) De-skew data
%-----------------------------------------------------------------------------------------



frame = double(readtiff(S.toBeDSed)); %#ok<PFBNS>

ds = AutoDS_deskewFrame3D(frame, SkewAngle, dz, xyPixelSize, reversed,S); %%%#ok<PFBNS>%add option here
% copy existing to the DS
copyfile(S.toBeDSed,S.sink) 
writetiff(single(ds),[S.sink filesep S.name]);




% if ~objectiveScan
%     % sample scan
%     frame = double(readtiff(filepath)); %#ok<PFBNS>
%     % sCMOS camera rotation / flip if necessary
%     if ip.Results.sCMOSCameraFlip
%         camidx = regexpi(fn, 'Cam\D') + 3;
%         cam = fn(camidx);
%         frame = GU_sCMOSCameraFlip(frame, cam);
%     end
%     % LS FF Correction
%     if LLFFCorrection
%         % average z planes of LS image
%         [LSfp, LSfn, ext] = fileparts(LSImage);
%         new_fn = [filesep 'AVG_' LSfn];
%         LSIm = readtiff([LSfp filesep new_fn ext]);
%         BKIm = readtiff(BKImage);
%         frame = GU_LSFlatFieldCorrection(frame,LSIm,BKIm,'LowerLimit', ip.Results.LowerLimit);
%     end
%     ds = deskewFrame3D(frame, SkewAngle, dz, xyPixelSize, reversed, 'Interp', ip.Results.Interp); %#ok<PFBNS>%add option here
%     writetiff(single(ds), [sink]);
% else
%     % crop only
%     frame = double(readtiff(filepath)); %#ok<PFBNS>
%     if ip.Results.sCMOSCameraFlip
%         camidx = regexpi(fn, 'Cam\D') + 3;
%         cam = fn(camidx);
%         frame = GU_sCMOSCameraFlip(frame, cam);
%     end
%     if LLFFCorrection
%         [LSfp, LSfn, ext] = fileparts(LSImage);
%         new_fn = [filesep 'AVG_' LSfn];
%         LSIm = readtiff([LSfp filesep new_fn ext]);
%         BKIm = readtiff(BKImage);
%         frame = GU_LSFlatFieldCorrection(frame,LSIm,BKIm,'LowerLimit', ip.Results.LowerLimit);
%     end
%     if ip.Results.Save16bit
%         writetiff(uint16(frame), [dsPath fn ext]);
%     else
%         writetiff(single(frame), [dsPath fn ext]);
%     end
% end
%
% %-----------------------------------------------------------------------------------------
% % 4) Rotate data
% %-----------------------------------------------------------------------------------------
% if ip.Results.Rotate
%     dsPath = [fp filesep 'DS' filesep];
%     dsrPath = [fp filesep 'DSR' filesep];
%     [~,~] = mkdir(dsrPath);
%     %
%     %added interpolation mode parameter to the call to rotateFrame3D
%     %7/26/18
%     ds = readtiff([dsPath fn ext]);
%     dsr = rotateFrame3D(ds, ip.Results.SkewAngle, zAniso, reversed,...
%         'Crop', false, 'ObjectiveScan', objectiveScan, 'Interp', ip.Results.Interp); %#ok<PFBNS>
%     writetiff(uint16(dsr), [dsrPath fn ext]);
% end
