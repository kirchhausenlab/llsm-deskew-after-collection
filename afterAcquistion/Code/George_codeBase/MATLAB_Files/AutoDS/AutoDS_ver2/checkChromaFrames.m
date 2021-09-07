function checkChromaFrames(C, data)
% Cam = {'CamA','CamB'};
Chan = {'405','488','560','592','642'};
% check which channels




%%

[row,col] = find(~cellfun(@isempty, C.chan));

disp('*****************************************************************************');

disp('Chromatic Offset analysis --check your dichroics, filter and galvo-zOffset!!');

if length(col) == 2
    rt1 = char(C.chan{row(1), col(1)});
    rt2 = char(C.chan{row(2), col(2)});
    [~, ~, XYZlow, ~, ~] = GU_estimateSigma3D(char(rt1), ''); % Get XYZ by adding a PSF
    [~, ~, XYZhigh, ~, ~] = GU_estimateSigma3D(char(rt2),''); % Get XYZ by adding a PSF
    
    zO = abs(XYZlow.z - XYZhigh.z) * data(1).dz;
    nF = round(zO/data(1).pixelSize/data(1).zAniso);
    
    fprintf('%s-%s, ds=%1.2f, nF=%d\n', Chan{col(1)}, Chan{col(2)}, data(1).dz,nF);
    
elseif length(col) == 3
    
    rt1 = char(C.chan{row(1), col(1)});
    rt2 = char(C.chan{row(2), col(2)});
     rt3 = char(C.chan{row(3), col(3)});
    [~, ~, XYZlow, ~, ~] = GU_estimateSigma3D(char(rt1), ''); % Get XYZ by adding a PSF
    [~, ~, XYZmid, ~, ~] = GU_estimateSigma3D(char(rt2),''); % Get XYZ by adding a PSF
    [~, ~, XYZhigh, ~, ~] = GU_estimateSigma3D(char(rt3),''); % Get XYZ by adding a PSF

    
    zO = abs(XYZlow.z - XYZmid.z) * data(1).dz;
    z1 = abs(XYZhigh.z - XYZmid.z) * data(1).dz;
    
    nF = round(zO/data(1).pixelSize/data(1).zAniso);
    nF1 = round(z1/data(1).pixelSize/data(1).zAniso);
    
    fprintf('%s-%s, ds=%1.2f, nF=%d\n', Chan{col(1)}, Chan{col(2)}, data(1).dz,nF);
    
    fprintf('%s-%s, ds=%1.2f, nF=%d\n', Chan{col(2)}, Chan{col(3)}, data(1).dz,nF1);

    
else
    fprintf('N_channels = %d, make check chroma folder: %s\n ',length(col),C.chan{row(1), col(1)})

end
disp('*****************************************************************************');
end
