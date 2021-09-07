function preprocess4(data, sinkEx, I, B, C)

% get metadata
Meta = getMeta2_AO(sinkEx);

% deskew and apply illum correction
if strcmp(Meta.zmotion, 'Sample piezo') || strcmp(Meta.zmotion, 'X stage')
    %     deskewData_KGO(data,...
    %         'sCMOSCameraFlip', Meta.camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
    %         'Overwrite', true,... % usually false, want to overwrite the previous data?
    %         'crop', false,... % used to limit the FOV from original size to the cropped size
    %         'LLFFCorrection', I.doIllum,...
    %         'LSImageChannels',I,... % illum correction structure
    %         'BkImageChannels', B) % background correction structure); % lattice light flat field correction (aka illumination correction)
    deskewData_KGO4(data,...
        'sCMOSCameraFlip', Meta.camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
        'Overwrite', true,... % usually false, want to overwrite the previous data?
        'crop', false,... % used to limit the FOV from original size to the cropped size
        'LLFFCorrection', I.doIllum,...
        'LSImageChannels',I,... % illum correction structure
        'BkImageChannels', B) % background correction structure); % lattice light flat field correction (aka illumination correction)
    
    disp(1)
    % chromatic offset
    if length(Meta.chan) > 1 && C.doChroma 
        applyChromaticOffset2(data, Meta, C)
    end
    
else
    disp('Not sample scan, no transformation applied.');
end
disp('')
disp('Complete')
disp('');
end
