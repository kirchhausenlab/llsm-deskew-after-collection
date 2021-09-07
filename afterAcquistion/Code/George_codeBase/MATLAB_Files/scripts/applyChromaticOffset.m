function applyChromaticOffset(data, Meta, C)
Chan = {'405','445','488','514','560','592','607','642'};
Cam = {'CamA','CamB'};
% check which channels were used

disp('Apply chromatic offset')

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
    
    % match channel with the given channel cells
    idx_cam_candidates = regexpi(cam,Cam);
    idx_cam = find(~cellfun(@isempty,idx_cam_candidates));
    assert( length(idx_cam) == 1);
    
    idx_chan_candidates = regexpi(channel,Chan);
    idx_chan = find(~cellfun(@isempty,idx_chan_candidates));
    assert( length(idx_chan) == 1);
    
    Chroma{ii} = cellstr([  char(C.chan{idx_cam, idx_chan})]); 
    cam_track{ii} = Cam{idx_cam};
    chan_track{ii} = Chan{idx_chan};
end

assert(length(cam_track) == length(chan_track))

for ii = 1:length(cam_track)
    fprintf('Loaded %s%s\n', char(chan_track{ii}), char(cam_track{ii}))
end
disp('calculating PSF centroid');
% get the centoid information, in order of [data]
for ii = 1:length(Chroma)
    if isempty(char(Chroma{ii}))
        disp('No offset beads found. Skipping chromatic offset');
        return
    end
    disp(char(Chroma{ii}))
    [~,~,XYZ,~,~] =  GU_estimateSigma3D(char(Chroma{ii}),'');
    XYZz(ii) = XYZ.z;
end
% /net/tkfastfs/scratch/George/20210112_p5_p55_sCMOS_George_sampleData//LLSCalibrations/chroma/Ex01c_488_560_642_z0p2/ch488nmCamA/DS/ex01c_CamA_ch0_stack0000_488nm_0000000msec_0002711380msecAbs.tif
% /net/tkfastfs/scratch/George/20210112_p5_p55_sCMOS_George_sampleData//LLSCalibrations/chroma/Ex01c_488_560_642_z0p2/ch560nmCamA/DS/ex01c_CamA_ch1_stack0000_560nm_0000000msec_0002711380msecAbs.tif

const = C.ds*sind(31.5);

assert (length(XYZz) > 1)
if length(XYZz) == 2
    disp('Applying offset for 2 chan data')
    % 488 is false, >488 is true
    GU_zOffset3D(...
        data,...
        'zOffset', abs(XYZz(1) - XYZz(2))*const,...
        'RawData', false,...
        'DS', true,...
        'Ch1', false,...
        'Ch2', true...
        )
    
elseif length(XYZz) == 3
    disp('Applying offset for 3 chan data')
    GU_zOffset3D(...
        data,...
        'zOffset', abs(XYZz(1) - XYZz(2))*const,...
        'RawData', false,...
        'DS', true,...
        'Ch1', false,... % 488 % adds to the end of the stack (false)
        'Ch2', true,... % 560 % adds to the start of the stack (true)
        'Ch3', true...
        ); % 642 % adds to the start of the stack (true)
    
    GU_zOffset3D(...
        data,...
        'zOffset', abs(XYZz(2) - XYZz(3))*const,...
        'RawData', false,...
        'DS', true,...
        'Ch1', false,... % 
        'Ch2', false,... % 
        'Ch3', true...
        ); 
    
     
else
    disp('More than 3 channels detected -- offset will not be corrected');
    

end

disp('Chromatic offset applied')


end