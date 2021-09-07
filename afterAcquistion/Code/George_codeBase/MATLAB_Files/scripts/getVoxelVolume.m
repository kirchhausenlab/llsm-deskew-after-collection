function vox = getVoxelVolume(Meta)
vox = zeros(length(Meta), 4);

% for each Ex, get the settings file, get the z-pix
% if objective scan, no need to put in ds info
% if sample scan, both dz and ds
expression = 'Sample piezo';

for ii = 1:length(Meta)
    vox(ii,1) = 104; %nm/pix
    vox(ii,2) = 104;
    % check if obejctive scan or Sample piezo scan
    flag = regexp(Meta(ii).zmotion, expression);
    if flag % true then sample scan
        vox(ii,4) = Meta(ii).ds*1000;  % this is s in sample scan
        vox(ii,3) = vox(ii,4)*sind(31.5); % this is z in sample scan
    else
        vox(ii,3) = Meta(ii).ds; % this is z in objective scan
        vox(ii,4) = -1; % objscan does not have s scan
    end
    
end

fprintf('Pixel sensitivity in [nm] of the last acquisiton\n x: %1.3f, y: %1.3f, z: %1.3f, s: %1.3f\n',vox(end,1), vox(end,2), vox(end,3),vox(end,4))

end
