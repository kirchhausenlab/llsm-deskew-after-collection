function  preprocess2(TifDirs, I, B, C)
for ii = 1:length(TifDirs.source)
    for jj = 1:length(TifDirs.source(ii).tif)
        
        % deskew and apply illum correction
        if strcmp(TifDirs.source(ii).meta.zmotion, 'Sample piezo') || strcmp(TifDirs.source(ii).meta.zmotion, 'X stage')
            deskewData_KGO2(TifDirs,...
                'sCMOSCameraFlip', Meta.camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
                'Overwrite', true,... % usually false, want to overwrite the previous data?
                'crop', false,... % used to limit the FOV from original size to the cropped size
                'LLFFCorrection', I.doIllum,...
                'LSImageChannels',I,... % illum correction structure
                'BkImageChannels', B) % background correction structure); % lattice light flat field correction (aka illumination correction)
            
            disp(1)
%             % chromatic offset
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
end


end
